# set working directory
setwd("~/Desktop")
maindir <- getwd()
datadir <- file.path("~/Desktop/")

# load packages
library("readxl")
library("ggplot2")
library("ggpubr")
library("reshape2")
library("emmeans")
library("hrbrthemes")
library("umx")
library("interactions")
library("car")

# import data
data_ppi <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/palm_data/data/ppi_domain_x_outcome.xlsx")
design_contrast <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/palm_data/design_contrast.xlsx")
data_act <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/palm_data/data/act_outcome.xlsx")
design_average <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/palm_data/design_average.xlsx")



# residual scatterplots

# ppi_VS-dmPFC, domain * outcome, c8: SU-neg
model1 <- lm(data_ppi$dmPFC ~
               design_contrast$tsnr + design_contrast$fd_mean + design_contrast$RS + design_contrast$RS_square + design_contrast$SU + design_contrast$SUxRS + design_contrast$SUxRS_sq)
summary(model1)
# Partial Residual Plot
crModel <- crPlots(model1, 
                   smooth=FALSE, 
                   col="yellow",
                   col.lines="grey",
                   pch=16,
                   lwd=1,
                   grid=FALSE
)

# ppi_VS-vmPFC, domain * outcome, c3: RS-pos
model1 <- lm(data_ppi$vmPFC ~
               design_contrast$tsnr + design_contrast$fd_mean + design_contrast$RS + design_contrast$RS_square + design_contrast$SU + design_contrast$SUxRS + design_contrast$SUxRS_sq)
summary(model1)
# Partial Residual Plot
crModel <- crPlots(model1, 
                   smooth=FALSE, 
                   col=carPalette()[5], # 5=orange, 6=gray (dmPFC is supposed to be yellow, w/e)
                   col.lines=carPalette()[],
                   pch=16,
                   lwd=1,
                   grid=FALSE
)

# act, outcome, c12: SU*RS_sq-neg
model1 <- lm(data_act$VS ~
               design_average$tsnr_avg + design_average$fd_mean_avg + design_average$RS + design_average$RS_square + design_average$SU + design_average$SUxRS + design_average$SUxRS_sq)
summary(model1)

# scatter plot dividing by aberrant vs moderate RS (i.e., positive RS_sq vs negative)
scatter <- ggplot(design_average, aes(x=SU, y=VS, col=RS))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, linetype="dashed")
# remove gridlines
scatter + scale_color_grey() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                     panel.background = element_blank(), axis.line = element_line(colour = "black"))
# https://r-graph-gallery.com/ggplot2-color.html
scatter
