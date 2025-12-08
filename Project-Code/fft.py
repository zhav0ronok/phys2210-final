            #---------------------------------------------------------------------------------------------#
            # Python script to analyze audio files and extract significant frequency components using FFT #
            #---------------------------------------------------------------------------------------------#





#\_____________________________________________________________________________________________________/
# ------- Import necessary libraries ---|>

import soundfile as sf # for reading .flac files
import numpy as np # for performing FFT
import pandas as pd # table formatting
from scipy.signal import get_window # for windowing function
#\_____________________________________________________________________________________________________/






#\_____________________________________________________________________________________________________/
# ------- Parameters ------------------|>

MIN_FREQ = 80        # ignore scraping noise and subharmonic junk
AMP_THRESHOLD = 0.01 # ignore very low-amplitude partials (fraction of max)
WINDOW = 'hann'      # smooths spectrum

# ------- Audio Setup  ---------------|>

audio, sr = sf.read("/home/zhav0ronok/Physics/PHYS2210-data/Processed Data/Low E String/lowestringfret5.flac") # load audio file

if audio.ndim > 1: # take only first channel if stereo/home/zhav0ronok/Physics/gstringfret12test.flac
    audio = audio[:, 0]

w = get_window(WINDOW, audio.size) # apply window
audio_win = audio * w
#\_____________________________________________________________________________________________________/






#\_____________________________________________________________________________________________________
# ------------ FFT ------------------|>

N = len(audio_win)
fft_vals = np.fft.rfft(audio_win)
fft_freqs = np.fft.rfftfreq(N, 1/sr)
magnitudes = np.abs(fft_vals)

# --- Filter out low-end noise ------|>

mask = fft_freqs >= MIN_FREQ
fft_freqs = fft_freqs[mask]
magnitudes = magnitudes[mask]

# --- Normalize & threshold -------|>

max_mag = magnitudes.max()
keep = magnitudes > AMP_THRESHOLD * max_mag

fft_freqs = fft_freqs[keep]
magnitudes = magnitudes[keep]
#\_____________________________________________________________________________________________________/






#\_____________________________________________________________________________________________________/
# --- Create table ---

df = pd.DataFrame({
    "frequency_Hz": fft_freqs,
    "amplitude": magnitudes})

# --- Sort highest amplitude -> lowest ---

df = df.sort_values("amplitude", ascending=False).reset_index(drop=True)

# --- Display results ---
print(df.head(20))  # show strongest peaks
#\_____________________________________________________________________________________________________/
