% 1 Sep 2016 MRS
% matthew.siegfried.phd@gmail.com

% subset Cryosat data
% goes through all the .mat files in /Volumes/MOULIN/cryosat2/monthly/
% and subsets based on a PS71 or lon/lat Nx2 polygon
% also adds an additional row for CATS2008 tidal predictions
function subsetCryosatMonthPolyList(cs2data,pgon_files,buffer_size,datastem,outfold,matlabfmt,ascii,polar,tideLoc)


numPolys=length(pgon_files);


if ~polar
        % do it in lat/lon
    disp('never rewrote the code for doing this in lat lon')
else

%%% do it in polar stereographic
    for i=1:numPolys
        thisfile=pgon_files{i};
        [~,pgon_name]=fileparts(thisfile);
        
        outline=loadMultiSeg(thisfile); % load polygon
        pgon=polybuffer(outline(:,1:2),'points',buffer_size); % expand polygon

        newname=[pgon_name '_' datastem];

        %first just take stuff south of -60 so we can convert to PS71
        ind=logical(cs2data.lat < -60);
        fields=fieldnames(cs2data);
        antdata=struct;
        for j=1:length(fields)
            antdata.(fields{j})=cs2data.(fields{j})(ind);
        end
        
        %disp('converting to ps71')
        [x,y]=wgs2pss(antdata.lon,antdata.lat,'StandardParallel',-71);
        antdata.x=x;
        antdata.y=y;

        %disp('subsetting')
        % first subset based on mix/max of pgon to reduce # of pts
        xl=min(pgon.Vertices(:,1));
        xh=max(pgon.Vertices(:,1));
        yl=min(pgon.Vertices(:,2));
        yh=max(pgon.Vertices(:,2));
        in=logical(antdata.x >= xl & antdata.x <= xh & antdata.y >= yl & antdata.y <= yh);

        if(sum(in) > 0)
            fields=fieldnames(antdata);
            tmpdata=struct;
            for j=1:length(fields)
                tmpdata.(fields{j})=antdata.(fields{j})(in);
            end
            
            these=isinterior(pgon,tmpdata.x,tmpdata.y);
            if(sum(these) > 0)
                fields=fieldnames(tmpdata);
                subset=struct;
                for j=1:length(fields)
                    subset.(fields{j})=tmpdata.(fields{j})(these);
                end

                switch tideLoc
                    case 'ROSS'
                        PadmanModel = 'Model_CATS2008a_ris';
                    case 'AMERY'
                        PadmanModel = 'Model_CATS2008a_ais';
                    case 'ANTP'
                        PadmanModel = 'Model_CATS2008a_antp';
                    case 'enderby'
                        PadmanModel = 'Model_CATS2008a_ender';
                    case 'FRIS'
                        PadmanModel = 'Model_CATS2008a_fris';
                    case 'maud'
                        PadmanModel = 'Model_CATS2008a_maud';
                    case 'eant1'
                        PadmanModel = 'Model_CATS2008a_eant1';
                    case 'eant2'
                        PadmanModel = 'Model_CATS2008a_eant2';
                    case 'pig'
                        PadmanModel = 'Model_CATS2008a_pig';
                    case 'unk'
                        PadmanModel = 'Model_CATS2008a_opt';
                    case 'none'
                        PadmanModel = 'none';             
                end

                if ~strcmp(PadmanModel,'none')
                    disp(['......Using ', PadmanModel, ' tide model'])
                    mtime=cs2timecalc(subset.time);
                    sdtime=datenum(mtime);
                    %keyboard
                    disp([num2str(size(sdtime)) ' ' num2str(size(subset.lat)) ' ' num2str(size(subset.lon))]);
                    tidepredz=tide_pred(PadmanModel,sdtime,subset.lat,subset.lon,'z');
                    disp('......done predicting tides')
                    subset.h_cats=tidepredz';
                else
                    %disp('......no tidal corrections applied');
                end
                
                foldname=[outfold '/' pgon_name];
                if ~isfolder(foldname)
                    mkdir(foldname);
                end

                if matlabfmt
                    disp(['......saving matlab format: ' newname '.mat'])

                    eval([newname '=subset;']);
                    save([foldname '/' newname '.mat'],newname);

                end

                if ascii
                    disp(['......saving ascii format:  ' newname '.txt'])

                    if ~strcmp(PadmanModel,'none')
                        asciiout=[subset.x subset.y subset.h_r1 subset.time subset.sigma0_r1 ...
                            subset.qual_r1 subset.peakiness subset.ocean_tide subset.h_cats subset.asendTF];
                    else
                        asciiout=[subset.x subset.y subset.h_r1 subset.time subset.sigma0_r1 ...
                            subset.qual_r1 subset.peakiness subset.ocean_tide zeros(size(subset.ocean_tide)) subset.asendTF];
                    end
                    dlmwrite([foldname '/' newname '.txt'],asciiout,...
                        'delimiter',',','precision','%.5f');

                end
            end
        end

    end
    
end