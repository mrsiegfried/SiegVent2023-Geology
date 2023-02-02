# CryoSat-2 pre-processing

This processing chain follows Siegfried & Fricker (2021, GRL) exactly. This is old code from my PhD that should be re-written for any number of reasons, but I haven't done that. I would almost certainly suggest you find someone else's more modern code to do similar analysis 🤪

1. data from the full CryoSat-2 SARIn POCA mission are re-spun into monthly `.mat` files to make loading a lot quicker using `cs2importAll.m` (this calls `cs2importmonthly.m`, which calls `cs2raw2useable`). 
2. the monthly `.mat` files are subset to each of the lake regions using `subset_cs2_slmslc.m`, which calls `subsetCryosatMonthPolyList.m`.
3. run `make_slm_timeseries.sh` to do the data processing for generating a subglacial lake time series from SARIn POCA data for all three subglacial lakes. This will generate the `corr` folders in `./data/cs2/baseline_d/slm` folders, which contains the `.corr` files in the main data archive under `cs2/slm_corr`.
4. generate the lake time series data found in the main data archive under `cs2/timeseries` by subtracting the `mean elev OUT` column from the `mean elev IN` column in the `data/cs2/proc_out/[lake_name]/[lake_name]_elevs.dat` files. 


