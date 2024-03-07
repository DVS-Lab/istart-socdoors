# Set working directory
setwd("~/Desktop")
maindir <- getwd()
datadir <- file.path("~/Desktop/")

# Load packages
library("readxl")
library("ggplot2")
library("ggpubr")
library("reshape2")
library("emmeans")
library("hrbrthemes")
library("umx")
library("interactions")
library("car")

# Import data
data_act <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/palm_data/data/act_domain_x_outcome.xlsx")
data_act <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/palm_data/data/act_outcome.xlsx")

#nondec: 1012, 1019, 1247, 1251, 1303, 3116, 3143, 3176)
# Separate non-deceived subs
data_dec <- data_act[!((data_act$sub==1012) | (data_act$sub==1019) | (data_act$sub==1247) | (data_act$sub==1251) | (data_act$sub==1303) | (data_act$sub==3116) | (data_act$sub==3143) | (data_act$sub==3176)), ]
data_nondec <- data_act[((data_act$sub==1012) | (data_act$sub==1019) | (data_act$sub==1247) | (data_act$sub==1251) | (data_act$sub==1303) | (data_act$sub==3116) | (data_act$sub==3143) | (data_act$sub==3176)), ]

summary(data_nondec)
summary(data_dec)
