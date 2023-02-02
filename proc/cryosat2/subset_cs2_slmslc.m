% subsets cryosat2 data to a region surrounding SLM and SLC
% MRS 12 September 2020
function subset_cs2_slmslc

buffer_size=10000; % use points in 10 km buffer around lake for "outside" sample
outline_fold='~/Documents/data/lakeoutlines/FrickerScambos';
subset_fold='data/cs2/baseline_d';
cs2_fold='/Users/siegfried/Documents/data/cryosat2/baseline_d/monthly';
matlabfmt=true;
ascii=true;
polar=true;

files=dir([cs2_fold '/*.mat']);
numFiles=length([files.isdir]);

lakes = [{[outline_fold '/slm.xy']}, {[outline_fold '/slc.xy']}, {[outline_fold '/uslc.xy']}, ];

for i=1:numFiles
    t1=now;
    disp([files(i).name ': subsetting to ' num2str(3) ' polygons']); 
    
    disp(['...loading ' cs2_fold '/' files(i).name]);
    d=load([cs2_fold '/' files(i).name]);
    fn=fieldnames(d);
    data=d.(fn{1});
    
    [~,datastem,~]=fileparts(files(i).name);
    subsetCryosatMonthPolyList(data,lakes(3),buffer_size,datastem,subset_fold,matlabfmt,ascii,polar,'none');
    t2=now;
end
end