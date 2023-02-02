%MRS 17 July 2013
%cs2importmonthly(infolder,year,month,outfold)
%ALL INPUTS ARE STRINGS! month can be a Nx2 char matrix
function cs2importmonthly(infolder,year,mnths,outfold,baseline)
%function cs2importmonthly
% infolder is usually /Volumes/MOULIN/cryosat2/SIR_SIN_L2/science-pds.cryosat.esa.int/SIR_SIN_L2
% outfold is usually /Volumes/MOULIN/cryosat2/SIR_SIN_L2/monthly
% example: cs2importmonthly(in,'2013',['01';'02';'03'],out)

%infolder='/local/data/cryosat2/SIR_SIN_L2/science-pds.cryosat.esa.int/SIR_SIN_L2';
%outfold='/local/data/cryosat2/SIR_SIN_L2/monthly';
%year='2013';
%mnths=['01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12'];
%mnths=['01';'02';'03';'04';'05'];

nmonths=size(mnths);

for j=1:nmonths(1)
    
    month=mnths(j,:);

    disp(['starting work on month ' month ' of ' year '.']);

    monthdir=[infolder '/' year '/' month];
    f=dir([monthdir '/CS_*.nc']);

    numFiles=length([f.isdir]);
    monthdata=struct;
    %for i=1:numFiles;
    for i=1:numFiles
        thisfile=f(i);
        disp(['loading ' thisfile.name ' (' num2str(i) ' of ' num2str(numFiles) ')']);
        if (strcmp(baseline,'d'))
            thisdata=cs2raw2useable([thisfile.folder '/' thisfile.name]);
        elseif (strcmp(baseline,'c'))
            thisdata=cs2raw2useable_baselinec(hdr,cs);
        elseif (strcmp(baseline,'b'))
            thisdata=cs2raw2useable_baselineb(hdr,cs);
        else
            error('Baseline must be ''b'' or ''c''. Try again.')
        end
                
		fn=fieldnames(thisdata);
        %keyboard
		for k=1:length(fn)
            if i==1
                monthdata.(fn{k})=thisdata.(fn{k});
            else
                monthdata.(fn{k})=[monthdata.(fn{k}); thisdata.(fn{k})];
            end
        end
        clear hdr cs thisdata thisfile
		%monthdata=[monthdata;thisdata];
    end

    filename=['cs2_SINL2_' year month '.mat'];
    varname=['cs2_SINL2_' year month];
    eval([varname '=monthdata;']);
    disp(['saving to ' outfold '/' filename]);
    tic
    save([outfold '/' filename],varname,'-v7.3')
    toc

end
