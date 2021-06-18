############################################################################
############## Frequency and Sed Rate Plots for SALSA Project ##############
############################################################################

# Plotting the results from MCMC MLMTM96 & ASM Analtses of SALSA core 
# CT Scan grayscale transects
# by: Molly Patterson and Will Arnuk
# last updated: 6/17/2021

# Load the ggplot library for plotting
library(ggplot2)

# Set the working directory to the location with the rates/frequency output
# from the monte carlo time series analyses
setwd("~/documents/github/salsa_lake_seds/mtm-asm_analysis")

# Open a new PDF to save the plots to, set the filename and dimensions
pdf("summary_plots.pdf", width = 11, height=8.5)

# Load the sedimentation rate results and convert to mm/yr
rates = read.csv("rates_all.csv") / 100

# remove any NaN values from the data.frame and convert into an iteratable list
rates1 = sapply(rates, function(x) na.omit(x, mode="any"))

# iterate through the list of each transect, assign x to be transect number, 
# assign y to be sedimentation rates; flatten resulting lists
x = unlist(sapply(1:length(rates1), function(x) {array(x, length(unlist(rates1[x])))}))
y = unlist(sapply(1:length(rates1), function(x) {unlist(rates1[x], use.names=F)}))

# make a data.frame out of the flattened lists x and y, coerce transect to be a factor
# that can be plotted linearly along the x-axis
new_rates = data.frame(transect=x, sedrate=y)
new_rates$transect = as.factor(new_rates$transect)

# run kernel density function on the new_rates data.frame
# assign the sedimentation rates to "x"
# assign the density values to "y"
# put the density values (y) on a scale relative scale 0-1
# assign the transect number to "z"
dens_x = data.frame(sapply(rates1, function(x){density(x, from=0, to=2.5)$x}))
dens_y = sapply(rates1, function(x){density(x, from=0, to=2.5)$y})
dens_y = data.frame(apply(dens_y, 2, function(x) (x-min(x))/(max(x)-min(x))))
dens_z = data.frame(t(array(1:length(rates1), dim=rev(dim(dens_x)))))

# make a data.frame from the above variables that can be used by ggplot
dens = data.frame(x = as.vector(as.matrix(dens_x)), 
                  y = as.vector(as.matrix(dens_y)), 
                  z = as.vector(as.matrix(dens_z)))

# Plot 1 is a pseudo-Heatmap plot. 
# Each vertical track represents a single transect with a gradient, scaled to density
# The y-axis shows the sedimentation rates
# The color axis (z) shows the kernel density estimates on a 0-1 scale, relative to the transect
plot1 <- ggplot(data = dens, mapping=aes(x=z, y=x, fill=y)) + 
  geom_tile() + 
  scale_fill_gradient2(midpoint = 0.5, low = "blue", mid="white", high="red", limits=c(0, 1)) +
  theme_classic() +
  scale_x_continuous(breaks=1:length(rates1), labels=array("", length(rates1))) + 
  theme(legend.position = "none") +
  ggtitle("Plot of Sedimentation Rate Density from Core Grayscale Transects") +
  xlab("Transect") + ylab("Sedimentation Rate (mm/yr)")

print(plot1)

# Repeat the previous plot with a Summary track

# Estimate kernel density for the bulk results of sedimentation rate
# Scale the density values to 0-1 relative scale
# Assign the summary track a plotting location beyond 10% of the individual tranect plots
d = density(new_rates$sedrate, from=0, to=2.5)
dens_x$a = d$x
dens_y$a = (d$y - min(d$y)) / (max(d$y) - min(d$y))
dens_z$a = length(rates1) + floor(0.1*length(rates1))

# Add some extra tracks to the summary track to make it appear thicker
dens_x$b = dens_x$a
dens_y$b = dens_y$a
dens_z$b = dens_z$a + 1
dens_x$c = dens_x$b
dens_y$c = dens_y$b
dens_z$c = dens_z$b + 1
dens_x$d = dens_x$c
dens_y$d = dens_y$c
dens_z$d = dens_z$c + 1
dens_x$e = dens_x$d
dens_y$e = dens_y$d
dens_z$e = dens_z$d + 1

# Make a data.frame of the density estimates to be used by ggplot
dens = data.frame(x = as.vector(as.matrix(dens_x)), 
                  y = as.vector(as.matrix(dens_y)), 
                  z = as.vector(as.matrix(dens_z)))
                  
# Pseudo-Heatmap plot with a summary track
plot2 <- ggplot(data = dens, mapping=aes(x=z, y=x, fill=y)) + 
  geom_tile() + 
  scale_fill_gradient2(midpoint = 0.5, low = "blue", mid="white", high="red", limits=c(0, 1)) +
  theme_classic() +
  scale_x_continuous(breaks=1:length(rates1), labels = array("", length(rates1))) + 
  theme(legend.position = "none") +
  ggtitle("Plot of Sedimentation Rate Density from Core Grayscale Transects") +
  xlab("Transect") + ylab("Sedimentation Rate (mm/yr)")
print(plot2)

# Same plot as the previous two, but with a summary track and a summary violin plot
plot3 <- ggplot(data = dens, mapping=aes(x=z, y=x, fill=y)) + 
  geom_tile() + 
  scale_fill_gradient2(midpoint = 0.5, low = "blue", mid="white", high="red", limits=c(0, 1)) +
  theme_classic() +
  scale_x_continuous(breaks=1:length(rates1), labels = array("", length(rates1))) + 
  theme(legend.position = "none") +
  ggtitle("Plot of Sedimentation Rate Density from Core Grayscale Transects") +
  xlab("Transect") + ylab("Sedimentation Rate (mm/yr)") +
  geom_violin(data=data.frame(y=new_rates$sedrate), aes(x=dens_z$e[1]+floor(0.1*length(rates1)), y=y), width=10, fill='lightblue')
print(plot3)


# The next plot is just the kernel density distribution itself for the sed rates
d = density(new_rates$sedrate)

# Make a ploygon out of the density curve to fill the area underneath the curve
d0 = data.frame(x = c(d$x, rev(d$x)), y=c(d$y, array(0, dim=length(d$x))))

# Find local maxima by determining where the slope changes from positive to zero to negative (i.e. peaks)
peaks = d$x[seq(1, length(d$x))[which(diff(sign(diff(d$y)))==-2)]+1]
peaks_y = d$y[!is.na(match(d$x, peaks))]

# make a blank array the same size as the density curve, at which to derive an average
smoother = array(0, dim=length(d$x))

# for each location on the x-axis, estimate IDW average
for (i in 1:length(smoother)) {
  location = d$x[i]
  #distance = 1 - (abs(d$x - location) / max(abs(d$x - location)))^0.5
  distance = 1 - (abs(d$x - location) / max(abs(d$x - location)))
  smoother[i] = sum(distance * d$y) / sum(distance)
}

# get the IDW average values at the peak locations
peaks_bg = smoother[!is.na(match(d$x, peaks))]

# filter only the peaks with a higher density estimate than the average
peaks_sig = peaks[peaks_y > peaks_bg]
sig_y = d$y[!is.na(match(d$x, peaks_sig))]

# add the peaks to a text file
write(paste("peak rates:", paste(peaks, collapse=", ")), "peaks.txt")
write(paste("sig peak rates:", paste(peaks_sig, collapse=", ")), "peaks.txt", append=T)

# plot the density curve with the peaks and the IDW average curve
dens_all = data.frame(x=d$x, y=d$y)
plot4 = ggplot(dens_all, aes(x=x, y=y)) +
  geom_polygon(fill = "lightblue") + geom_line() +
  scale_x_continuous(breaks=seq(from=0, to=2.5, by=0.25)) +
  geom_vline(xintercept = peaks_sig, col="red") +
  ggtitle("Plot of significant sedimentation rates from all transects") +
  xlab("Sedimentation Rate (mm/yr)") + ylab("Density") +
  geom_line(data=data.frame(x=d$x, y=smoother), aes(x=x, y=y), linetype="dashed", col="red") +
  geom_label(data=data.frame(x = peaks_sig, y= sig_y), aes(x=x, y=y+0.05, label=round(x, 2)))
print(plot4)

# Load the frequency results
freq = read.csv("freq_all.csv")

freq1 = sapply(freq, function(x) na.omit(x, mode="any"))

x = unlist(sapply(1:length(freq1), function(x) {array(x, length(unlist(freq1[x])))}))
y = unlist(sapply(1:length(freq1), function(x) {unlist(freq1[x], use.names=F)}))

new_freq = data.frame(transect=x, freq=y)
new_freq $transect = as.factor(new_freq$transect)


dens_x = data.frame(sapply(freq1, function(x){density(x, from=0, to=1500)$x}))
dens_y = sapply(freq1, function(x){density(x, from=0, to=1500)$y})
dens_y = data.frame(apply(dens_y, 2, function(x) (x-min(x))/(max(x)-min(x))))
dens_z = data.frame(t(array(1:length(freq1), dim=rev(dim(dens_x)))))

dens = data.frame(x = as.vector(as.matrix(dens_x)), 
                  y = as.vector(as.matrix(dens_y)), 
                  z = as.vector(as.matrix(dens_z)))

plot5 <- ggplot(data = dens, mapping=aes(x=z, y=x, fill=y)) + 
  geom_tile() + 
  scale_fill_gradient2(midpoint = 0.5, low = "blue", mid="white", high="red", limits=c(0, 1)) +
  theme_classic() +
  scale_x_continuous(breaks=1:length(freq1), labels=array("", length(freq1))) + 
  theme(legend.position = "none") +
  ggtitle("Plot of Significant Frequencies from Mann and Lees MTM Analysis") +
  xlab("Transect") + ylab("Frequency (cycles/m)")
print(plot5)

# With Summary track
d = density(new_freq$freq, from=0, to=1500)
dens_x$a = d$x
dens_y$a = (d$y - min(d$y)) / (max(d$y) - min(d$y))
dens_z$a = length(freq1) + floor(0.1*length(freq1))

dens_x$b = dens_x$a
dens_y$b = dens_y$a
dens_z$b = dens_z$a + 1
dens_x$c = dens_x$b
dens_y$c = dens_y$b
dens_z$c = dens_z$b + 1
dens_x$d = dens_x$c
dens_y$d = dens_y$c
dens_z$d = dens_z$c + 1
dens_x$e = dens_x$d
dens_y$e = dens_y$d
dens_z$e = dens_z$d + 1

dens = data.frame(x = as.vector(as.matrix(dens_x)), 
                  y = as.vector(as.matrix(dens_y)), 
                  z = as.vector(as.matrix(dens_z)))
plot6 <- ggplot(data = dens, mapping=aes(x=z, y=x, fill=y)) + 
  geom_tile() + 
  scale_fill_gradient2(midpoint = 0.5, low = "blue", mid="white", high="red", limits=c(0, 1)) +
  theme_classic() +
  scale_x_continuous(breaks=1:length(rates1), labels = array("", length(rates1))) + 
  theme(legend.position = "none") +
  ggtitle("Plot of Significant Frequencies from Mann and Lees MTM Analysis") +
  xlab("Transect") + ylab("Frequency (cycles/m)") 
  
print(plot6)

plot7 <- ggplot(data = dens, mapping=aes(x=z, y=x, fill=y)) + 
  geom_tile() + 
  scale_fill_gradient2(midpoint = 0.5, low = "blue", mid="white", high="red", limits=c(0, 1)) +
  theme_classic() +
  scale_x_continuous(breaks=1:length(rates1), labels = array("", length(rates1))) + 
  theme(legend.position = "none") +
  ggtitle("Plot of Significant Frequencies from Mann and Lees MTM Analysis") +
  xlab("Transect") + ylab("Frequency (cycles/m)") +
  geom_violin(data=data.frame(y=new_freq$freq), aes(x=dens_z$e[1]+floor(0.1*length(freq1)), y=y), width=10, fill='lightblue')
print(plot7)

d = density(new_freq$freq)

d0 = data.frame(x = c(d$x, rev(d$x)), y=c(d$y, array(0, dim=length(d$x))))

peaks = d$x[seq(1, length(d$x))[which(diff(sign(diff(d$y)))==-2)]+1]
peaks_y = d$y[!is.na(match(d$x, peaks))]

smoother = array(0, dim=length(d$x))

for (i in 1:length(smoother)) {
  location = d$x[i]
  #distance = 1 - (abs(d$x - location) / max(abs(d$x - location)))^0.5
  distance = 1 - (abs(d$x - location) / max(abs(d$x - location)))
  smoother[i] = sum(distance * d$y) / sum(distance)
}

peaks_bg = smoother[!is.na(match(d$x, peaks))]

peaks_sig = peaks[peaks_y > peaks_bg]
sig_y = d$y[!is.na(match(d$x, peaks_sig))]

write(paste("peak freqs:", paste(peaks, collapse=", ")), "peaks.txt", append=T)
write(paste("sig peak freqs:", paste(peaks_sig, collapse=", ")), "peaks.txt", append=T)

dens_all = data.frame(x=d$x, y=d$y)
plot8 = ggplot(dens_all, aes(x=x, y=y)) +
  geom_polygon(fill = "lightblue") + geom_line() +
  scale_x_continuous(breaks=seq(from=0, to=1500, by=100)) +
  geom_vline(xintercept = peaks_sig, col="red") +
  ggtitle("Plot of Significant Frequencies from Mann and Lees MTM Analysis with Major Peaks in Red") +
  xlab("Frequency (cycles/m)") + ylab("Density") +
  geom_line(data=data.frame(x=d$x, y=smoother), aes(x=x, y=y), linetype="dashed", col="red") +
  geom_label(data=data.frame(x = peaks_sig, y=sig_y), aes(x=x, y=y+0.0005, label=round(x, 2)))
print(plot8)

dev.off()
