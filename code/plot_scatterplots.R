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

# import data:
df <- read_excel("~/Documents/Github/istart-socdoors/code/istart_covariates_7june2022_simplified.xlsx")

# residualize measures
model1 <- lm(comp_RS ~ fd_mean_social * tsnr_social * comp_RS_square * comp_substance_use,
             data=df)
summary(model1)

# calculate standardized residuals
res_p1_comp_RS <- rstandard(model1)
final_df <- cbind(df, res_p1_comp_RS)

# create plots
p1 <- ggplot(final_df, aes(x=res_p1_comp_RS, y=nppi_pallidum)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ poly(x, 2), se=TRUE) +
  #geom_smooth(method="lm") +
  scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("nPPI-DMN Model 3, Pallidum Connectivity") +
  xlab("Reward Sensitivity") +
  ylab("(social win>social loss) > (doors win>doors loss)")
  #theme_ipsum()
p1
cor1 <- cor.test(final_df$res_p1_comp_RS, final_df$nppi_pallidum, method = "pearson")
cor1


p2 <- ggplot(df, aes(x=comp_RS, y=ppi_pcg)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ x, se=TRUE) +
  scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("PPI-VS Model 3, Post Central Gyrus Connectivity") +
  xlab("Reward Sensitivity") +
  ylab("((social win + doors win)/2) > ((social loss+doors loss)/2)")
p2
cor2 <- cor.test(df$comp_RS, df$ppi_pcg, method = "pearson")
cor2

p3 <- ggplot(df, aes(x=comp_substance_use, y=act_precuneus, color=group_two)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ x, se=TRUE) +
  #scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("Act Model 2, Precuneus Activation") +
  xlab("Substance Use") +
  ylab("((social win + doors win)/2) > ((social loss+doors loss)/2)")
p3
#cor3 <- cor.test(df$comp_RS, df$act_precuneus, method = "pearson")
#cor3

p4 <- ggplot(df, aes(x=comp_RS, y=act_sma)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ poly(x, 2), se=TRUE) +
  #geom_smooth(method="lm") +
  scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("Act Model 3, SMA Activation") +
  xlab("Reward Sensitivity") +
  ylab("(social win>social loss) > (doors win>doors loss)")
#theme_ipsum()
p4
cor4 <- cor.test(df$comp_RS, df$act_sma, method = "pearson")
cor4

p5 <- ggplot(df, aes(x=comp_RS, y=act_frontal_operculum)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ poly(x, 2), se=TRUE) +
  #geom_smooth(method="lm") +
  scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("Act Model 3, Frontal Operc. Activation") +
  xlab("Reward Sensitivity") +
  ylab("(social win>social loss) > (doors win>doors loss)")
#theme_ipsum()
p5
cor5 <- cor.test(df$comp_RS, df$act_frontal_operculum, method = "pearson")
cor5

p6 <- ggplot(df, aes(x=comp_substance_use, y=ppi_cingulate)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ x, se=TRUE) +
  #scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("PPI Model 3, Cingulate Connectivity") +
  xlab("Substance Use") +
  ylab("(social win>social loss) > (doors win>doors loss)")
#theme_ipsum()
p6
cor6 <- cor.test(df$comp_substance_use, df$ppi_cingulate, method = "pearson")
cor6

p7 <- ggplot(df, aes(x=comp_RS, y=act_pcg)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ x, se=TRUE) +
  #scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("Act Model 3, Post Cent. Gyrus Activation") +
  xlab("Reward Sensitivity") +
  ylab("(social win>social loss) > (doors win>doors loss)")
#theme_ipsum()
p7
cor7 <- cor.test(df$comp_RS, df$act_pcg, method = "pearson")
cor7
