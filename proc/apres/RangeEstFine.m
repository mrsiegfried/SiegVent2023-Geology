% Author: Paul Summers July 2020

% Purpose: Extract fine range estimates from time series 'image' of PRES
% data generated by mainCode_simple.m

% Instructions: Change the image file, manually unwrap some outlier bins if needed

clear; clc

%% Load file
% TimeInDays starts on the first data point and is fractional days since
% Jan 1, 2019.

load('ImageP2.mat','RawImage','Rcoarse','RfineBarTime','data','TimeInDays');

%% Calculate wavelength of signal for unwrapping
f_c = 300e6;
c = 3e8/1.79;
lambda_c = c/f_c;


%% Pick bed bin from signal
% only find bed signals deep enough, ignore surface signals. Pick
% brightest range bin, save the corresponding fine range value.
n = length(TimeInDays);
thres = 2000;
[Y,I] = max(RawImage(thres:end,:),[],1);
I = I + thres-1;
RfinePick = zeros(1,n);
for i = 1:n
    RfinePick(i) = RfineBarTime(I(i),i);    
end

%% Manually unwrap outliers
% These are found by visual inspection, probably could be auto found, but
% there are not many
RfinePick([1428,1431,1433:1458,1672:1678,1680:1789]) = ...
    RfinePick([1428,1431,1433:1458,1672:1678,1680:1789]) - lambda_c/2;

%% Plot
% Range data from 1 Az point (center image) for fun
figure(1)
clf
plot(10*log10(abs(RawImage(:,floor(n/2)).^2)))
ylabel('Power [dB]')
xlabel('Range Bin [ ]')
title('Raw Power in range [dB]')

% Plot history of Rfine for bins that ever have bed in them
figure(2)
clf
plot(TimeInDays,(I - mean(I))*.25)
hold on
pl = plot(TimeInDays,RfineBarTime(min(I):max(I),:)','-*','linewidth',.5);
plot(TimeInDays,RfinePick,'k--','linewidth',3)

% Plot Rcourse and Rcoarse+Rfine estimates of bed
figure(3)
clf
plot(TimeInDays,Rcoarse(I))
hold on
plot(TimeInDays,Rcoarse(I) + RfinePick ,'-*')
% plot(Rcoarse(I))
% hold on
% plot(Rcoarse(I) + RfinePick ,'-*')
legend('Coarse','Fine Estimate','Location','SouthEast')
title('Range over time')
ylabel('Range [m]')
xlabel('Time [days]')

%% Save data file
range = Rcoarse(I)' + RfinePick';
save('rangeOverTime','range','TimeInDays');