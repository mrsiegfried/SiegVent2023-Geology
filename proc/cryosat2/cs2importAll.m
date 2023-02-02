% MRS 1 Sept 2016
% cs2importAll just is a wrapper for running through all the CS2 
% months and converting from binary to matlab structures

% add to this as more files come on line

%infolder='/local/data/cryosat2/baseline_c/SIR_SIN_L2/science-pds.cryosat.esa.int/SIR_SIN_L2';
%infolder='/Volumes/CREVASSE/cryosat2/baseline_c/science-pds.cryosat.esa.int/SIR_SIN_L2';
%infolder='/Volumes/cirque/data/altimetry/cryosat2/baseline_c/science-pds.cryosat.esa.int/SIR_SIN_L2';
%infolder='/Volumes/moulin/data/altimetry/cryosat2/baseline_d/science-pds.cryosat.esa.int/SIR_SIN_L2';
%infolder='/Volumes/SCINI_1/cryosat2/baselined';
infolder='/Volumes/moulin/data/altimetry/cryosat2/baseline_d/science-pds.cryosat.esa.int/SIR_SIN_L2'
outfold='~/Documents/data/cryosat2/baseline_d/monthly';
baseline='d';
%%%
%% 2010
year='2010';
mnths=['07';'08';'09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
%%%
%% 2011
year='2011';
%mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
mnths=['08';'09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
%%%
%% 2012
year='2012';
mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
%mnths=['09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
%%
% %% 2013
 year='2013';
 mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
% mnths=['04';'05';'06';'07';'08';'09';'10';'11';'12'];
 cs2importmonthly(infolder,year,mnths,outfold,baseline);
% 
%%
% % 2014
 year='2014';
 mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
% %mnths=['08';'09';'10';'11';'12'];
 cs2importmonthly(infolder,year,mnths,outfold,baseline);
%% 2015
year='2015';
mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
%mnths=['10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);

%% 2016
t1=now;
year='2016';
mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
t2=now;
disp(['this took ' num2str((t2-t1)*24) ' hours'])
%% 2017
t1=now;
year='2017';
mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
t2=now;
disp(['this took ' num2str((t2-t1)*24) ' hours'])
%% 2018
t1=now;
year='2018';
mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
t2=now;
disp(['this took ' num2str((t2-t1)*24) ' hours'])
%%
t1=now;
year='2019';
mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
t2=now;
disp(['this took ' num2str((t2-t1)*24) ' hours'])
%%
t1=now;
year='2020';
%mnths=['01';'02';'03';'04';'05';'06';'07'];
mnths=['07';'08';'09';'10';'11';'12'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
t2=now;
disp(['this took ' num2str((t2-t1)*24) ' hours'])
%%
t1=now;
year='2021';
%mnths=['01';'02';'03';'04';'05'];
mnths=['02';'03';'04';'05'];
cs2importmonthly(infolder,year,mnths,outfold,baseline);
t2=now;
disp(['this took ' num2str((t2-t1)*24) ' hours'])