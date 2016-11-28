class _BaseEpochs
  # (ProjMixin, ContainsMixin, UpdateChannelsMixin, SetChannelsMixin, InterpolationMixin, FilterMixin, ToDataFrameMixin, TimeMixin, SizeMixin)
  def initalize(self, info, data, events, event_id=None, tmin=-0.2, tmax=0.5, baseline=[None, 0], raw=None, picks=None, name='Unknown', reject=None, flat=None, decim=1, reject_tmin=None, reject_tmax=None, detrend=None, add_eeg_ref=True, proj=True, on_missing='error', preload_at_end=False, selection=None, drop_log=None, verbose=None)

  end

  def load_data(self)

  end

  def decimate(self, decim, offset=0)

  end

  def apply_baseline(self, baseline=[None, 0], verbose=None)

  end

  def apply_baseline(self, baseline=[None, 0], verbose=None)

  end

  def _reject_setup(self, reject, flat)

  end

  def _is_good_epoch(self, data, verbose=None)

  end

  def _detrend_offset_decim(self, epoch, verbose=None)

  end

  def iter_evoked(self)

  end

  def subtract_evoked(self, evoked=None)

  end

  def __next__(self, *args, **kwargs)

  end

  def standard_error(self, picks=None)

  end

  def _compute_mean_or_stderr(self, picks, mode='ave')

  end

  def _evoked_from_epoch_data(self, data, info, picks, n_events, kind)

  end

end

module Epoch
  def _read_one_epoch_file(f, tree, fname, preload)

  end
  def read_epochs(fname, proj=True, add_eeg_ref=False, preload=True,
                verbose=None)
  end


  class _RawContainer(object)
    def __init__(self, fid, data_tag, event_samps, epoch_shape, cals)
    end
    def __del__(self)
    end
  end

  class EpochsFIF(_BaseEpochs)
    def __init__(self, fname, proj=True, add_eeg_ref=True, preload=True,
                   verbose=None)
    end
    def _get_epoch_from_raw(self, idx, verbose=None)
    end

    def bootstrap(epochs, random_state=None)
    end

    def _check_merge_epochs(epochs_list)
    end
    def add_channels_epochs(epochs_list, name='Unknown', add_eeg_ref=True,
                          verbose=None)
    end


    def _compare_epochs_infos(info1, info2, ind)
    end


    def _concatenate_epochs(epochs_list, with_data=True)
    end


    def _finish_concat(info, data, events, event_id, tmin, tmax, baseline,
                     selection, drop_log, verbose)
    end


    def concatenate_epochs(epochs_list)
    end
    def average_movements(epochs, head_pos=None, orig_sfreq=None, picks=None,
                        origin='auto', weight_all=True, int_order=8, ext_order=3,
                        destination=None, ignore_ref=False, return_mapping=False,
                        mag_scale=100., verbose=None)
    end
  end
end