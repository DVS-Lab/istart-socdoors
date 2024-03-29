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
library("ggscatter")

# import data:
df <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/code/correlations_istart-covars_full.xlsx")
head(df)

#df2 <- read_excel("~/Desktop/ISTART-ALL-Combined-042122_2.xlsx")
#head(df2)
#socialdoors_model4 <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/derivatives/imaging_plots/istart_covariates_socialdoors_4.xlsx")
#socialdoors_model4 <- socialdoors_model4[-c(15,21),]

rtdf <- read_excel("~/Desktop/manuscript_draft_istart/RT_data.xlsx")

#model1 <- data.frame(socialdoors_model4$tsnr, socialdoors_model4$fd_mean, df2$score_susd_mania, df2$score_susd_depress)
#model2 <- data.frame(socialdoors_model4$tsnr, socialdoors_model4$fd_mean, df2$audit_standard_score)
#model3 <- data.frame(socialdoors_model4$tsnr, socialdoors_model4$fd_mean, socialdoors_model4$RS, socialdoors_model4$RS_square, df2$audit_standard_score, df2$score_susd_mania, df2$score_susd_depress)

model <- data.frame(df$RS, df$RS_square, df$SU, rtdf$Percent_Change_Doors, rtdf$Percent_Change_Soc, rtdf$RT_soc_minus_doors)
model

#hist(df2$score_susd_mania)
#hist(df2$score_susd_depress)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Correlation Heat Maps
cormat <- round(cor(model),2)
head(cormat)

melted_cormat <- melt(cormat)
head(melted_cormat)

ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value))+
  geom_tile()

# Get lower triangle of the correlation matrix
get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
# Get upper triangle of the correlation matrix
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}

upper_tri <- get_upper_tri(cormat)
upper_tri

# Melt the correlation matrix
library(reshape2)
melted_cormat <- melt(upper_tri, na.rm = TRUE)
# Heatmap
library(ggplot2)
ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed()


# Scatterplots

sp <- ggscatter(model, x = "df.RS", y = "rtdf.RT_soc_minus_doors",
                add = "reg.line",
                add.params = list(color = "blue", fill = "lightgray"),
                conf.int=TRUE,
                ylab="RT (social>monetary)",
                xlab="RS (linear)"
                )
sp + stat_cor(method = "pearson")

sp <- ggscatter(model, x = "df.RS_square", y = "rtdf.RT_soc_minus_doors",
                add = "reg.line",
                add.params = list(color = "blue", fill = "lightgray"),
                conf.int=TRUE,
                ylab="RT (social>monetary)",
                xlab="RS (quadratic)"
)
sp + stat_cor(method = "pearson")

sp <- ggscatter(model, x = "df.SU", y = "rtdf.RT_soc_minus_doors",
                add = "reg.line",
                add.params = list(color = "blue", fill = "lightgray"),
                conf.int=TRUE,
                ylab="RT (social>monetary)",
                xlab="Substance"
)
sp + stat_cor(method = "pearson")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ANOVA models

# import data:
df <- read_excel("~/Documents/Documents_Air/Github/istart-socdoors/code/anova_istart-RTs.xlsx")
head(df)

y1 <- df$RT_t2

two.way <- aov(y1 ~ df$domain + df$outcome)
interaction <- aov(y1 ~ df$domain * df$outcome)
summary(two.way)
summary(interaction)

# estimated marginal means (EMMs)
(frg <- ref_grid(interaction))
#emmeans(frg, "NM_full")
emmeans(frg, "Acc")
emmeans(frg, "Domain")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# plot of estimated marginal means for Accuracy (avg across domain) & average striatal activation
y2 <- df2$DSR
emcorr <- 0.0462
emincorr <- -0.0159
emmon <- 0.0120
emsoc <- 0.0183
se <- 0.0111

t.test(emcorr, emincorr)

Acc.levels <- c("Incorrect", "Correct")
Acc.emmeans <- c(emincorr, emcorr) #input accuracy emmeans
Acc.emmeans.df <- data.frame(Acc.levels, Acc.emmeans)

Acc_plot <- ggplot(Acc.emmeans.df, aes(x=Acc.levels, y=Acc.emmeans)) + 
  ggtitle("Striatal activation by Accuracy")+
  xlab("Accuracy")+ylab("Percent signal change, striatal activation")+
  geom_col(fill = "pink")+
  geom_errorbar(aes(ymin=Acc.emmeans-se, ymax=Acc.emmeans+se), width=.2) #input accuracy emmeans SE
Acc_plot





# 1. Raw brain data & raw behavioral data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
p1 <- ggplot(df, aes(x=comp_RS, y=nppi_pallidum)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ poly(x, 2), se=TRUE) +
  #geom_smooth(method="lm") +
  scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ylim(-40,70) +
  #ggtitle("nPPI-DMN Model 3, Pallidum Connectivity") +
  ggtitle("1. Raw brain data & raw behavioral data") +
  xlab("Reward Sensitivity") +
  ylab("(social win>social loss) > (doors win>doors loss)")
#theme_ipsum()
p1


# Analyses: Does striatal activation vary by NM, Accuracy, or Domain?

# In this script, we're running 3-way anovas for NM x Accuracy x Domain in each of 
# the four ROIs. Run the 3-way anova first to determine if the overall model is significant.
# Then plot main effects for each var, followed by interaction (NM x Correct & Incorrect
# in each domain)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # 
