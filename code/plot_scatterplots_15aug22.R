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
socialdoors_model4 <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/imaging_plots/istart_covariates_socialdoors_4.xlsx")
socialdoors_model2 <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/imaging_plots/istart_covariates_socialdoors_2.xlsx")
socialanddoors_model5 <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/imaging_plots/istart_covariates_social+doors_5.xlsx")
socialanddoors_model4 <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/imaging_plots/istart_covariates_social+doors_4.xlsx")
socialanddoors_model3 <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/imaging_plots/istart_covariates_social+doors_3.xlsx")
socialanddoors_model2 <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/imaging_plots/istart_covariates_social+doors_2.xlsx")


# Socialdoors Model 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Cluster tstat 8 (SU-neg) Lateral Occipital Cortex
model1 <- lm(aug22_task_socialdoors_model_2_type_act_cnum_4_thresh_clustere_corrp_tstat8 ~
               tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq, data=socialdoors_model2)
summary(model1)

crModel <- crPlots(model1, smooth=FALSE)
summary(crModel)

# Socialdoors Model 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Cluster tstat 13 (RT-pos) Cerebellum
model2 <- lm(aug22_task_socialdoors_model_4_type_nppi_dmn_cnum_4_thresh_clustere_corrp_tstat13 ~
               tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq + RT, data=socialdoors_model4)
crPlots(model2, smooth=FALSE)

# Vox tstat 13 (RT-pos) Cerebellum
#model3 <- lm(aug22_task_socialdoors_model_4_type_act_cnum_4_thresh_vox_corrp_tstat7 ~
#               tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq + RT, data=socialdoors_model4)
#crPlots(model3)

# Social + Doors Model 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Thresh zstat 4 (RS-neg) Precuneus
model4 <- lm(aug22_task_socialanddoors_model_2_type_act_cnum_4_thresh_zstat4 ~
               tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq, data=socialanddoors_model2)
crPlots(model4, smooth=FALSE)

# Thresh zstat 7 (SU-pos) Lateral Occipital
model5 <- lm(aug22_task_socialanddoors_model_2_type_act_cnum_4_thresh_zstat7 ~
                tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq, data=socialanddoors_model2)
crPlots(model5, smooth=FALSE)

# Thresh zstat 8 (SU-neg) Occipital Pole 
model6 <- lm(aug22_task_socialanddoors_model_2_type_nppi_dmn_cnum_4_thresh_zstat8 ~
                tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq, data=socialanddoors_model2)
crPlots(model6, smooth=FALSE)

# Thresh zstat 5 (RS_sq-pos) Middle Frontal Gyrus
model7 <- lm(aug22_task_socialanddoors_model_2_type_ppi_seed_VS_thr5_cnum_4_thresh_zstat5 ~
                tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq, data=socialanddoors_model2)
crPlots(model7)

# Thresh zstat 10 (RT-neg) Precuneus
model7b <- lm(aug22_task_socialanddoors_model_2_type_act_cnum_4_thresh_zstat10_cluster_7 ~
               tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq, data=socialanddoors_model2)
crPlots(model7b, smooth=FALSE)

# Social + Doors Model 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Thresh zstat 3 (RS-pos) Middle Temporal Gyrus
model8 <- lm(aug22_task_socialanddoors_model_3_type_act_cnum_4_thresh_zstat3 ~
               tsnr + fd_mean + RS + RS_square + SU, data=socialanddoors_model3)
crPlots(model8, smooth=FALSE)

# Thresh zstat 7 (SU-pos) Lateral Occipital
model9 <- lm(aug22_task_socialanddoors_model_3_type_act_cnum_4_thresh_zstat7 ~
                tsnr + fd_mean + RS + RS_square + SU, data=socialanddoors_model3)
crPlots(model9, smooth=FALSE)

# Thresh zstat 3 (RS-pos) Postcentral Gyrus
model10 <- lm(aug22_task_socialanddoors_model_3_type_ppi_seed_VS_thr5_cnum_4_thresh_zstat3 ~
                tsnr + fd_mean + RS + RS_square + SU, data=socialanddoors_model3)
crPlots(model10, smooth=FALSE)

# Thresh zstat 7 (SU-neg) Cingulate Gyrus
model11 <- lm(aug22_task_socialanddoors_model_3_type_ppi_seed_VS_thr5_cnum_4_thresh_zstat7 ~
                 tsnr + fd_mean + RS + RS_square + SU, data=socialanddoors_model3)
crPlots(model11, smooth=FALSE)

# Social + Doors Model 4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Thresh zstat 4 (RS-neg) Precuneus
model12 <- lm(aug22_task_socialanddoors_model_4_type_act_cnum_4_thresh_zstat4 ~
               tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq + RT, data=socialanddoors_model4)
crPlots(model12)


# Thresh zstat 7 (SU-pos) Inferior Temporal Gyrus
model13 <- lm(aug22_task_socialanddoors_model_4_type_act_cnum_4_thresh_zstat7 ~
                 tsnr + fd_mean + RS + RS_square + SU + SUxRS + SUxRS_sq + RT, data=socialanddoors_model4)
crPlots(model13)

### PLACEHOLDER FOR ZSTAT 10 (With the multiple clusters!)

# Social + Doors Model 5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Thresh zstat 10 (RT-neg) Juxtapositional Cortex
model14 <- lm(aug22_task_socialanddoors_model_5_type_act_cnum_4_thresh_zstat10 ~
                tsnr + fd_mean + RS + RS_square + SU + RT, data=socialanddoors_model5)
crPlots(model14, smooth=FALSE)

# Thresh zstat 7 (SU-pos) Thalamus
model15 <- lm(aug22_task_socialanddoors_model_5_type_nppi_dmn_cnum_4_thresh_zstat7 ~
                tsnr + fd_mean + RS + RS_square + SU + RT, data=socialanddoors_model5)
crPlots(model15, smooth=FALSE)

# Thresh zstat 3 (RS-pos) Postcentral Gyrus
model16 <- lm(aug22_task_socialanddoors_model_5_type_ppi_seed_VS_thr5_cnum_4_thresh_zstat3 ~
                tsnr + fd_mean + RS + RS_square + SU + RT, data=socialanddoors_model5)
crPlots(model16, smooth=FALSE)

# Thresh zstat 7 (SU-pos) Intracalcarine Cortex
model17 <- lm(aug22_task_socialanddoors_model_5_type_ppi_seed_VS_thr5_cnum_4_thresh_zstat7 ~
                 tsnr + fd_mean + RS + RS_square + SU + RT, data=socialanddoors_model5)
crPlots(model17, smooth=FALSE)

