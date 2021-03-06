% Detects left/right step from gyroscope_y data

function [ICleft, ICright] = IClr(input, Fs, Fc, IC, visualize)

% detrend 
input = rad2deg(input);
in_detrend = detrend(input);

% LPF - 1 or 2Hz - 4th order
Wn = Fc / (Fs/2);
[B, A] = butter(4, Wn, 'low');
in_filt = filtfilt(B, A, in_detrend);

ICleft = IC(find(in_filt(IC) >= 0));
ICright = IC(find(in_filt(IC) < 0));

% in realta' mi interessa solo il primo passo, gli altri si alternano 
if ICleft(1) < ICright(1) % primo passo e' un sx
   ICleft = IC(1:2:end);
   ICright = IC(2:2:end);
else % primo passo e' un dx
   ICleft = IC(2:2:end);
   ICright = IC(1:2:end);
end

% Plot
if visualize
    figure; plot(5000:1:7000, in_filt(5000:7000), 'k'); 
    hold on; plot(ICleft(20:28), in_filt(ICleft(20:28)), 'ko'); ...
    hold on; plot(ICright(21:28), in_filt(ICright(21:28)), 'k^');
        xlabel('samples');
        ylabel('deg/s');
    legend('2Hz-filtered + detrended input', 'ICleft', 'ICright', 'Location', 'SouthEast');
end