module EEG

  def _check_fname(fname)

  end

  def _check_mat_struct(fname):

  end

  def _to_loc(ll)

  end

  def _get_info(eeg, montage, eog=()):

  end

  def method_name

  end

  def read_raw_eeglab(input_fname, montage=None, eog, event_id=None, event_id_func='strip_to_integer', preload=False, verbose=None, uint16_codec=None)

  end

  def read_epochs_eeglab(input_fname, events=None, event_id=None, montage=None, eog, verbose=None, uint16_codec=None)

  end

end

class RawEEGLAB

  def initialize(self, input_fname, montage, eog, event_id=None, event_id_func='strip_to_integer', preload=False, verbose=None, uint16_codec=None):

  end

  def _create_event_ch(self, events, n_samples=None)

  end

  def _read_segment_file(self, data, idx, fi, start, stop, cals, mult)

  end

end

class EpochsEEGLAB
  def initialize(self, input_fname, events=None, event_id=None, tmin=0, baseline=None,  reject=None, flat=None, reject_tmin=None, reject_tmax=None, montage=None, eog, verbose=None, uint16_codec=None):

  end

  def read_eeglab_events(eeg, event_id=None, event_id_func='strip_to_integer')

  end

  def strip_to_integer(trigger)

  end
end