module EGI

  def _read_header(fid)
    version = np.fromfile(fid, NMatrix.int32, 1)[0]

    if version > 6 & ~NMatrix.bitwise_and(version, 6):
        version = version.byteswap().astype(NMatrix.uint32)
    else:
        ValueError('Watchout. This does not seem to be a simple '
                   'binary EGI file.')

    def my_fread(*x, **y):
        return NMatrix.fromfile(*x, **y)[0]

    info = dict(
        version=version,
        year=my_fread(fid, '>i2', 1),
        month=my_fread(fid, '>i2', 1),
        day=my_fread(fid, '>i2', 1),
        hour=my_fread(fid, '>i2', 1),
        minute=my_fread(fid, '>i2', 1),
        second=my_fread(fid, '>i2', 1),
        millisecond=my_fread(fid, '>i4', 1),
        samp_rate=my_fread(fid, '>i2', 1),
        n_channels=my_fread(fid, '>i2', 1),
        gain=my_fread(fid, '>i2', 1),
        bits=my_fread(fid, '>i2', 1),
        value_range=my_fread(fid, '>i2', 1)
    )

    unsegmented = 1 if NMatrix.bitwise_and(version, 1) == 0 else 0
    precision = NMatrix.bitwise_and(version, 6)
    if precision == 0:
        RuntimeError('Floating point precision is undefined.')

    if unsegmented:
        info.update(dict(n_categories=0,
                         n_segments=1,
                         n_samples=NMatrix.fromfile(fid, '>i4', 1)[0],
                         n_events=NMatrix.fromfile(fid, '>i2', 1)[0],
                         event_codes=[],
                         category_names=[],
                         category_lengths=[],
                         pre_baseline=0))
        for event in range(info['n_events']):
            event_codes = ''.join(NMatrix.fromfile(fid, 'S1', 4).astype('U1'))
            info['event_codes'].append(event_codes)
        info['event_codes'] = NMatrix.array(info['event_codes'])
    else:
        raise NotImplementedError('Only continuous files are supported')
    info['unsegmented'] = unsegmented
    info['dtype'], info['orig_format'] = {2: ('>i2', 'short'),
                                          4: ('>f4', 'float'),
                                          6: ('>f8', 'double')}[precision]
    info['dtype'] = NMatrix.dtype(info['dtype'])
    return info
  end

  def _read_events(fid, info)
    events = NMatrix.zeros([info['n_events'],
                       info['n_segments'] * info['n_samples']])
    fid.seek(36 + info['n_events'] * 4, 0)  # skip header
    for si in range(info['n_samples']):
      # skip data channels
      fid.seek(info['n_channels'] * info['dtype'].itemsize, 1)
      # read event channels
      events[:, si] = NMatrix.fromfile(fid, info['dtype'], info['n_events'])
    return events
  end

  def _combine_triggers(data, remapping=None)

  end

  def self.read_raw_egi
    # (input_fname, montage=None, eog=None, misc=None, include=None, exclude=None, preload=False, verbose=None)
    puts "hello"
    RawEGI(input_fname, montage, eog, misc, include, exclude, preload, verbose)
  end

  end
end

class RawEGI

  def initialize(self, input_fname, montage=None, eog=None, misc=None)

    if eog is None:
            eog = []
        if misc is None:
            misc = []
        with open(input_fname, 'rb') as fid:  # 'rb' important for py3k
            logger.info('Reading EGI header from %s...' % input_fname)
            egi_info = _read_header(fid)
            logger.info('    Reading events ...')
            egi_events = _read_events(fid, egi_info)  # update info + jump
            if egi_info['value_range'] != 0 and egi_info['bits'] != 0:
                cal = egi_info['value_range'] / 2 ** egi_info['bits']
            else:
                cal = 1e-6

        logger.info('    Assembling measurement info ...')

        if egi_info['n_events'] > 0:
            event_codes = list(egi_info['event_codes'])
            if include is None:
                exclude_list = ['sync', 'TREV'] if exclude is None else exclude
                exclude_inds = [i for i, k in enumerate(event_codes) if k in
                                exclude_list]
                more_excludes = []
                if exclude is None:
                    for ii, event in enumerate(egi_events):
                        if event.sum() <= 1 and event_codes[ii]:
                            more_excludes.append(ii)
                if len(exclude_inds) + len(more_excludes) == len(event_codes):
                    warn('Did not find any event code with more than one '
                         'event.', RuntimeWarning)
                else:
                    exclude_inds.extend(more_excludes)

                exclude_inds.sort()
                include_ = [i for i in np.arange(egi_info['n_events']) if
                            i not in exclude_inds]
                include_names = [k for i, k in enumerate(event_codes)
                                 if i in include_]
            else:
                include_ = [i for i, k in enumerate(event_codes)
                            if k in include]
                include_names = include

            for kk, v in [('include', include_names), ('exclude', exclude)]:
                if isinstance(v, list):
                    for k in v:
                        if k not in event_codes:
                            raise ValueError('Could find event named "%s"' % k)
                elif v is not None:
                    raise ValueError('`%s` must be None or of type list' % kk)

            event_ids = NMatrix.arange(len(include_)) + 1
            logger.info('    Synthesizing trigger channel "STI 014" ...')
            logger.info('    Excluding events {%s} ...' %
                        ", ".join([k for i, k in enumerate(event_codes)
                                   if i not in include_]))
            self._new_trigger = _combine_triggers(egi_events[include_],
                                                  remapping=event_ids)
            self.event_id = dict(zip([e for e in event_codes if e in
                                      include_names], event_ids))
        else:
            # No events
            self.event_id = None
            self._new_trigger = None
        info = _empty_info(egi_info['samp_rate'])
        info['buffer_size_sec'] = 1.  # reasonable default
        info['filename'] = input_fname
        my_time = datetime.datetime(
            egi_info['year'], egi_info['month'], egi_info['day'],
            egi_info['hour'], egi_info['minute'], egi_info['second'])
        my_timestamp = time.mktime(my_time.timetuple())
        info['meas_date'] = NMatrix.array([my_timestamp], dtype=np.float32)
        ch_names = ['EEG %03d' % (i + 1) for i in
                    range(egi_info['n_channels'])]
        ch_names.extend(list(egi_info['event_codes']))
        if self._new_trigger is not None:
            ch_names.append('STI 014')  # our new_trigger
        nchan = len(ch_names)
        cals = np.repeat(cal, nchan)
        ch_coil = FIFF.FIFFV_COIL_EEG
        ch_kind = FIFF.FIFFV_EEG_CH
        chs = _create_chs(ch_names, cals, ch_coil, ch_kind, eog, (), (), misc)
        sti_ch_idx = [i for i, name in enumerate(ch_names) if
                      name.startswith('STI') or len(name) == 4]
        for idx in sti_ch_idx:
            chs[idx].update({'unit_mul': 0, 'cal': 1,
                             'kind': FIFF.FIFFV_STIM_CH,
                             'coil_type': FIFF.FIFFV_COIL_NONE,
                             'unit': FIFF.FIFF_UNIT_NONE})
        info['chs'] = chs
        info._update_redundant()
        _check_update_montage(info, montage)
        super(RawEGI, self).__init__(
            info, preload, orig_format=egi_info['orig_format'],
            filenames=[input_fname], last_samps=[egi_info['n_samples'] - 1],
            raw_extras=[egi_info], verbose=verbose)

  end

  def _read_segment_file(self, data, idx, fi, start, stop, cals, mult)

  end

end