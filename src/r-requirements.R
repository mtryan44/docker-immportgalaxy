#
# Initialize R for ImmPort-Galaxy
# https://github.com/ImmPortDB/immport-galaxy

source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("flowCore") # version 1.42.0
biocLite("flowDensity") # version 1.10.0
biocLite("flowCL") # version 1.14.0
biocLite("flowAI") # version 1.4.2
install.packages("plyr",repos="http://cran.r-project.org")
install.packages("ggplot2",repos="http://cran.r-project.org")
biocLite("flowViz")
biocLite("ncdfFlow")
biocLite("rgl")
biocLite("ks")
biocLite("flowWorkspace")
biocLite("flowStats")
biocLite("flowVS")
biocLite("ggcyto") # version 1.5.1
biocLite("FlowSOM")