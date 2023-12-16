%% Loading Signals

zs_ddot = out.acc.Data;

suspension_deflection_1 = out.suspension_deflection_1.Data;

damper_velocity_1 = out.damper_velocity_1.Data;

F_t_1 = out.F_t_1.Data;

t = out.t.Data;

rms_zs_ddot = rms(zs_ddot)
rms_F_t_1 = rms(F_t_1)
rms_suspension_deflection_1 = rms(suspension_deflection_1)
rms_damper_velocity_1 = rms(damper_velocity_1)

%% Signal Processing Parameters

fres = 0.1; % Required Frequency Resolution

fs = 1/0.001; % Samping frequency

nfft = fs/fres;

noverlap = nfft/4;

window = hann(nfft);

[psd_zs_ddot, hz_zs_ddot] = pwelch(zs_ddot, window, noverlap,nfft,fs);

figure
loglog(hz_zs_ddot,psd_zs_ddot)

%% Ride Comfort Index - Weighting Func
hz_weight_ride_comfort_raw = ([0.1  1    4  8  80 100 200 300 400 500]);
weight_ride_comfort_raw =    ([0.5  0.5  1  1  0.1 0.1 0.1 0.1 0.1 0.1]);

weight_ride_comfort_filt = interp1(hz_weight_ride_comfort_raw, weight_ride_comfort_raw, (hz_zs_ddot),"linear","extrap");

figure
loglog((hz_weight_ride_comfort_raw), (weight_ride_comfort_raw))
grid minor

%% Ride Comfort Index - Calculation & Plotting

ride_comfort_index = psd_zs_ddot .* (weight_ride_comfort_filt);

figure
loglog(hz_zs_ddot,ride_comfort_index)

cumtrapz(ride_comfort_index)


