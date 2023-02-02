% Authors: Nicole Bienert, Sean Peters
% later Paul Summers July 2020.

% Purpose: plot aPRES measurements. Paul modified to bulk process multiple
% data sets, and save them in a rectangular image file.

% Instructions: Change the variables file, burst, datafolder, figureFolder.
% You can extract a changing bed reflection over time using RangeEstFine.m

%If you want the plots to save automatically, uncomment the saveas

clc

close all

clear 

%% vars

%This is where you are now, so we can get back here
hmDir = pwd;

% The folder where the data file exists
dataFolder = '../../data/apres/raw';

% If plots are saving automatically, where do you want them saved to?
figureFolder = '';

% The pRES data files. Do not include the .dat file extension

files = dir([dataFolder, '/*.DAT']);
fileNames = string({files.name});
fileNames = erase(fileNames,'.DAT');

% Apologies for hard coding depth the length here, I'm a monster (PS)
RawImage = zeros(9511,numel(fileNames));
RfineBarTime = zeros(9511,numel(fileNames));
TimeInDays = zeros(numel(fileNames),1);



for i = 1:numel(fileNames)

%extracting days since from the file name, may need to adjust if you name
%data files differently
TimeInDays(i) = days(datetime(extractAfter(fileNames(i),"DATA"),...
    'InputFormat','yyyy-MM-dd-HHmm') - datetime(2019,1,1));

file = char(fileNames(i));

fileType='.dat'; %file extension

maxH=2000; %Limit the max ice thickness on the plot

permittivity = 3.18; %relative permittivity of ice

filename = [dataFolder,'/',file,fileType] %prints to let you know how its going

%% read the header and extract the voltage data from the PRES file
data = fmcw_load(filename,permittivity);

%% calculate range data
[Rcoarse,Rfine,spec_cor,spec] =fmcw_range(data,2,maxH,@blackman); %Paul Changed pad to 2

%% average all bursts

R = abs(mean(spec_cor));

%% find the max amplitude

maxA = max(max(abs(spec_cor(:,1000:4000))));

%% Save image and fine range estimate
RawImage(:,i) = mean(spec_cor)';
RfineBarTime(:,i) = mean(Rfine)';

%Plot

% figure()
% 
% plot(Rcoarse,abs(spec_cor)),xlim([0 maxH]),ylim([0 1.5*maxA])
% 
% hTitle = title(regexprep(file,"_"," "));
% 
% hXlabel = xlabel('Range');
% 
% hYlabel = ylabel('|Magnitude|');
% 
% Aesthetics_Script
% 
% saveas(gcf, [figureFolder,'\',file,'-ptMeasurement'], 'fig')
% 
% saveas(gcf, [figureFolder,'\',file,'-ptMeasurement'], 'png')
% 
% figure(2)
% 
% plot(Rcoarse,10*log10(abs(R)),'-'),xlim([0 maxH])
% 
% hTitle = title(regexprep(file,"_"," "));
% 
% hXlabel=xlabel('Range');
% 
% hYlabel = ylabel('|Magnitude| (dB)');
% hold on
% legend
% Aesthetics_Script

end
% saveas(gcf, [figureFolder,'\',file,'-ptMeasurement-coherentSum'], 'fig')

% saveas(gcf, [figureFolder,'\',file,'-ptMeasurement-coherentSum'], 'png')

% P2 for pad = 2 image
save ImageP2
