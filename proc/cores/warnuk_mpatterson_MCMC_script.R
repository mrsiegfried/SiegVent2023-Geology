############################################################################
########### MCMC simulations on grayscale data for SALSA Project ###########
############################################################################

# Monte Carlo Simulations of sub-glacial lakes sedimentation rates
# by: Molly Patterson and Will Arnuk
# last updated: 6/11/2021

# Description: This script performs a series of Monte Carlo simulations on
# core image data. The goal of this analysis is to simulate variability in
# the spatial and temporal heterogeneity of sedimentation when running 
# Mann and Lees (1996) robust red noise MTM and Average Spectral Misfit
# analyses to find significant sedimentation frequencies and to improve 
# confidence in the fact that "significant" frequencies are truly significant.
# The analyses are performed using the 'astrochron' package (Meyers, 2014)
# using the 'sapply' function to quickly apply the same functions over an array
# of randomized time series samples. 

# Load the "astrochron" package for data pre-processing and analysis
library(astrochron)

# Load "ggplot2" library for plotting
library(ggplot2)

# Set a working directory for input/output files
setwd("../../data/cores/spectral_analysis")

# Load the dataset of grayscale transect data from core imaging
data = read.csv("core_traces_filtered.csv")

depth = data[,1]
datasets = data[,2:length(data)]

colnames(datasets) <- sapply(1:length(datasets), function(i) paste("T", i, sep=""))
#colnames(datasets) <- 1:length(datasets)

# Setting the number of Monte-Carlo simulations to run
# ideally, we find a magnitude at which results are consistent
n_trials = 1000    # ... try from 500, 1000, 10000, etc.

# Initialize lists to store transect label and results for each transect
# The list of labels will help for saving output with corresponding file names
# The results will be of variable length, stored as nested lists
transects = list() # labels for each analysis
freq = list() # significant frequencies from MTM analyses
significant_rates = list() # sedimentation rates from ASM analyses

# Open a log/overwrite. Trial start/completion times will be logged to this file
write(paste("BEGIN", "...", Sys.time()), "runtime.log")

# Iterate through each transect in the list of transect data ...
for (i in seq_along(datasets)) {
  
  # Write the trial number and start time to the log file
  write(paste(i, "...", Sys.time(), "... START"), "runtime.log", append = TRUE)
  
  # make a label for the transect (i.e. 'T1') for output column names
  name = paste("T",i, sep="")
  
  # add the label to the list of transect labels, for post-processing/output
  transects = append(transects, name)
  
  # Prepare data.frame for analysis inputs. 1st col is depth, 2nd is core CT grayscale
  df = na.omit(data.frame(depth, datasets[i]))
  
  # Trimming the dataset of outliers
  df_trim=trim(df,c=.7,genplot=F,verbose=F)
  
  # Convert distance/depth from mm to m scale
  df_trim$X1 = df_trim$X1 / 1000
  
  # Making an interpolated depth interval using median sampling interval
  # Use the approx function on the results of "strats" to get 50th percentile
  # depth interval, i.e. the median dt
  dt = approx(strats(df_trim, output=1, genplot=0), xout=50)$y
  
  # Make a new depth vector that uses a uniform sampling interval, dt
  new_depth = seq(from = min(df_trim$X1), to = max(df_trim$X1), by=dt)
  
  # Identify how many samples should be taken from a full dataset w/ uniform dt
  n_sample = length(new_depth)
  
  # Make randomly sampled 90% subsets of the trimmed dataset, interpolate to even dt
  # ... each subset will be missing 10% of the dataset at random locations
  # ... that missing 10% will be different from trial to trial
  
  df_resample = sapply(1:n_trials, 
                       function(x){ resample(df_trim[sort(sample(c(1:dim(df_trim)[1]), size=floor(dim(df_trim)[1]*0.9), replace=FALSE)),], xout=new_depth, genplot=F, verbose=F) })
                                             
  # Perform Mann and Lees MTM analysis on each random subset to find significant frequencies
  mtm_results = sapply(1:n_trials, function(x){ mtmML96(dat=df_resample[,x], output=3, genplot = F, verbose = F) })
  
  # Add the significant frequencies from the MTM analysis to the results list
  freq = append(freq, list(x = unlist(mtm_results[1,], use.names=FALSE)))
  
  # Prepare inputs for ASM analysis on MTM results
  n = sapply(df_resample, length) # the number of samples for each randomized subset
  target = c(1/0.006, 1/0.005, 1/0.004)
  rayleigh=1/(n*dt)
  nyquist=1/(2*dt)
  numsed=200
  sedmin=0
  sedmax=250
  iter=10000
  
  # Perform ASM analysis on each set of significant frequencies from MTM analyses
  # ... if the mtmML96 analysis returned frequencies. otherwise, return NaN for the trial
  asm_results = sapply(1:n_trials, function(x){if (length(na.omit(unlist(mtm_results[1, x]))) > 0) { asm(freq = na.omit(unlist(mtm_results[1, x]), use.names = FALSE), target = target, rayleigh = rayleigh[x], nyquist = nyquist, numsed = numsed, sedmin = sedmin, sedmax = sedmax, iter = iter, linLog = 0, output = T, genplot = F) } else { list(NaN, NaN, NaN, NaN) } } )
  
  # make a data.frame of all sedimentation rates statistically significant at 95%
  rates = unlist(asm_results[1,], use.names=FALSE)
  significance = unlist(asm_results[3,], use.names=FALSE)
  
  # Determine the critical p-value for reporting significant sedimentation rates
  critical_sig = 1 / numsed * 100 # inverse of the number of rates tested against
  
  # Subset only the sedimentation rates that exceed the critical value for significance
  significant_rates = append(significant_rates, list(x = rates[significance <= critical_sig]))
  
  # Reset the graphics object so that new plots revert to defaults
  graphics.off()
  
  write(paste(i, "...", Sys.time(), "... DONE"), "runtime.log", append = TRUE)
}

# Get the maximum number of rows needed to store the frequencies
nrows = max(sapply(freq, length))

# Pad transects with NA values so that all transects have the same dimensions
# and coerce into a data.frame object
freq = data.frame(sapply(freq, function(x) c(x, rep(NA, nrows-length(x)))))

# Get the maximum number of rows needed to store the sedimentation rates
nrows = max(sapply(significant_rates, length))

# Pad transects with NA values so that all transects have the same dimensions
# and coerce into a data.frame object
significant_rates = data.frame(sapply(significant_rates, function(x) c(x, rep(NA, nrows-length(x)))))

# Set the column names of each results data.frame to the transect labels
colnames(freq) = transects
colnames(significant_rates) = transects

# Write the results data.frame objects to CSV files
write.csv(freq, file="freq_all.csv", row.names=FALSE)
write.csv(significant_rates, file="rates_all.csv", row.names=FALSE)

