% MRS rewritten 30 Aug 2020 for Baseline D (switch from binary to NetCDF)
%MRS 17 July 2013
%function cs2raw2useable(hdr,cs) takes the output from 
%Cryo_Read_L2 and turns it into a Nx6 matrix
%final matrix is [lon,lat,elev,time,backscatter,surface flag,SLA,ocean_tide,lpe_ocean]

function out=cs2raw2useable(file)

out=struct;

% at 20Hz
t20=ncread(file,'/time_20_ku');
lon20=ncread(file,'/lon_poca_20_ku');
lat20=ncread(file,'/lat_poca_20_ku');
h20r1=ncread(file,'/height_1_20_ku');
h20r2=ncread(file,'/height_2_20_ku');
h20r3=ncread(file,'/height_3_20_ku');
range20r1=ncread(file,'/range_1_20_ku'); 
range20r2=ncread(file,'/range_2_20_ku'); 
range20r3=ncread(file,'/range_3_20_ku'); 
sig20r1=ncread(file,'/sig0_1_20_ku');
sig20r2=ncread(file,'/sig0_2_20_ku');
sig20r3=ncread(file,'/sig0_3_20_ku');
surf20=ncread(file,'/surf_type_20_ku');
ot20=ncread(file,'/ssha_interp_20_ku');

peaky20=ncread(file,'/peakiness_20_ku');
beamN20=ncread(file,'/echo_avg_numval_20_ku');
qual20r1=ncread(file,'/retracker_1_quality_20_ku');
qual20r2=ncread(file,'/retracker_2_quality_20_ku');
qual20r3=ncread(file,'/retracker_3_quality_20_ku');

flag_corr_applied20=ncread(file,'/flag_cor_applied_20_ku'); 

flags_prod=ncread(file,'/flag_prod_status_20_ku');
binary_flags=de2bi(flags_prod); % converts to N_20Hz x 29 binary number -- each column is a N_20Hz long vector of 0s or 1 for an individual flag
sz_binary=size(binary_flags);
if sz_binary(2)<12
    err_SIN_xtrack_angle20=zeros(size(t20));
else
    err_SIN_xtrack_angle20=binary_flags(:,12);
end
if sz_binary(2)<11
    err_SIN_ch120=zeros(size(t20));
else
    err_SIN_ch120=binary_flags(:,11);
end
if sz_binary(2)<10
    err_SIN_ch220=zeros(size(t20));
else
    err_SIN_ch220=binary_flags(:,10);
end
if sz_binary(2)<4
    err_SIN_Baseline_bad20=zeros(size(t20));
else
    err_SIN_Baseline_bad20=binary_flags(:,4);
end
if sz_binary(2)<3
    err_SIN_Out_of_Range20=zeros(size(t20));
else
    err_SIN_Out_of_Range20=binary_flags(:,3);
end
if sz_binary(2)<2
    err_SIN_Velocity_bad20=zeros(size(t20));
else
    err_SIN_Velocity_bad20=binary_flags(:,2);
end
if sz_binary(2)<28
    err_block_degraded=zeros(size(t20));
else
    err_block_degraded=binary_flags(:,28); 
end
if sz_binary(2)<26
    err_orbit_discontinuity=zeros(size(t20));
else
    err_orbit_discontinuity=binary_flags(:,26); 
end

% at 1Hz
t1=ncread(file,'/time_cor_01');
nadir_lat=ncread(file,'/lat_01'); 
nadir_lon=ncread(file,'/lon_01'); 
altitude=ncread(file,'/alt_01');
pitch=ncread(file,'/off_nadir_pitch_angle_str_01');
yaw=ncread(file,'/off_nadir_yaw_angle_str_01');
roll=ncread(file,'/off_nadir_roll_angle_str_01');

dry_tropo=ncread(file,'/mod_dry_tropo_cor_01');
wet_tropo=ncread(file,'/mod_wet_tropo_cor_01');
ibe=ncread(file,'/inv_bar_cor_01');
dy_atm=ncread(file,'/hf_fluct_total_cor_01');
iono=ncread(file,'/iono_cor_01');
iono_gim=ncread(file,'/iono_cor_gim_01'); 
seastatebias=ncread(file,'/sea_state_bias_01_ku');
ocean_tide=ncread(file,'/ocean_tide_01');
lpe_ocean=ncread(file,'/ocean_tide_eq_01');
ocean_loading=ncread(file,'/load_tide_01');
solid_earth=ncread(file,'/solid_earth_tide_01');
geoc_polar=ncread(file,'/pole_tide_01');
mss_geoid=ncread(file,'/geoid_01');
odle=ncread(file,'/odle_01');
ice_conc=ncread(file,'/sea_ice_concentration_01');
snow_depth=ncread(file,'/snow_depth_01');
snow_density=ncread(file,'/snow_density_01');

flag_corrections_error=ncread(file,'/flag_cor_err_01');

% zeropad flag
pad20=~err_block_degraded;


% turn 1hz data in 20hz data
idx=ncread(file,'/ind_meas_1hz_20_ku') + 1; % indices to go from 1hz => 20hz---they are 0-indexed, so add 1 for matlab's indexing
t1_20=t1(idx);
dry_tropo20=dry_tropo(idx);
wet_tropo20=wet_tropo(idx);
ibe20=ibe(idx);
dy_atm20=dy_atm(idx);
iono20=iono(idx);
iono_gim20=iono_gim(idx); 
seastatebias20=seastatebias(idx);
ocean_tide20=ocean_tide(idx);
lpe_ocean20=lpe_ocean(idx);
ocean_loading20=ocean_loading(idx);
solid_earth20=solid_earth(idx);
geoc_polar20=geoc_polar(idx);
mss_geoid20=mss_geoid(idx);
odle20=odle(idx);
ice_conc20=ice_conc(idx);
snow_depth20=snow_depth(idx);
snow_density20=snow_density(idx);
pitch20=pitch(idx);
yaw20=yaw(idx);
roll20=roll(idx);
nadir_lat20=nadir_lat(idx);
nadir_lon20=nadir_lon(idx); 
altitude20=altitude(idx); 
flag_corrections_error20=flag_corrections_error(idx);

if(strcmp(ncreadatt(file,'/','ascending_flag'),'D'))
    ascendTF20=zeros(size(t20));
else
    ascendTF20=ones(size(t20));
end


% only take the non-zero padded numbers

out.lon=lon20(pad20);
out.lat=lat20(pad20);
out.h_r1=h20r1(pad20);
out.h_r2=h20r2(pad20);
out.h_r3=h20r3(pad20);
out.time=t20(pad20);
out.sigma0_r1=sig20r1(pad20);
out.sigma0_r2=sig20r2(pad20);
out.sigma0_r3=sig20r3(pad20);
out.range_r1=range20r1(pad20);
out.range_r2=range20r2(pad20);
out.range_r3=range20r3(pad20);
out.surf_flag=surf20(pad20);
out.ssha_interp=ot20(pad20);
out.peakiness=peaky20(pad20);
out.n_beams=beamN20(pad20);
out.asendTF=ascendTF20(pad20);

out.qual_r1=qual20r1(pad20);
out.qual_r2=qual20r2(pad20);
out.qual_r3=qual20r3(pad20);
out.err_SIN_xtrack_angle=err_SIN_xtrack_angle20(pad20);
out.err_SIN_ch1=err_SIN_ch120(pad20);
out.err_SIN_ch2=err_SIN_ch220(pad20);
out.err_SIN_Baseline_bad=err_SIN_Baseline_bad20(pad20);
out.err_SIN_Out_of_Range=err_SIN_Out_of_Range20(pad20);
out.err_SIN_Velocity_bad=err_SIN_Velocity_bad20(pad20);
out.err_orbit_discontinuity=err_orbit_discontinuity(pad20);

out.tropo_d=dry_tropo20(pad20);
out.tropo_w=wet_tropo20(pad20);
out.ibe=ibe20(pad20);
out.dy_atm=dy_atm20(pad20);
out.iono=iono20(pad20);
out.iono_gim=iono_gim20(pad20);
out.seastatebias=seastatebias20(pad20);
out.ocean_tide=ocean_tide20(pad20);
out.lpe_ocean=lpe_ocean20(pad20);
out.ocean_loading=ocean_loading20(pad20);
out.solid_earth=solid_earth20(pad20);
out.geoc_polar=geoc_polar20(pad20);
out.mss_geoid=mss_geoid20(pad20);
out.odle=odle20(pad20);
out.ice_conc=ice_conc20(pad20);
out.snow_depth=snow_depth20(pad20);
out.snow_density=snow_density20(pad20);
out.time_1Hz=t1_20(pad20);
out.flag_corrections_applied=flag_corr_applied20(pad20);
out.flag_corrections_error=flag_corrections_error20(pad20);

out.nadir_lat=nadir_lat20(pad20);
out.nadir_lon=nadir_lon20(pad20);
out.spacecraft_altitude=altitude20(pad20);
out.spacecraft_pitch=pitch20(pad20);
out.spacecraft_roll=roll20(pad20);
out.spacecraft_yaw=yaw20(pad20);


