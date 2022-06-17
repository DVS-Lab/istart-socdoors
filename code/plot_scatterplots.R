# set working directory
setwd("~/Desktop")
maindir <- getwd()
datadir <- file.path("~/Desktop/")

library("readxl")
library("ggplot2")
library("ggpubr")
library("reshape2")
library("emmeans")
library("hrbrthemes")

# import data:
df <- read_excel("~/Desktop/mask_model-3_task-socialdoors_type-nppi-dmn_vox-tstat5_pallidum_bin_task-socialdoors_type-nppi-dmn_cope-4.xlsx")


p1 <- ggplot(df, aes(x=comp_RS, y=pallidum_nppi_dmn)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ poly(x, 2), se=TRUE) +
  #geom_smooth(method="lm") +
  scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("nPPI-DMN Model 3, Pallidum Connectivity") +
  xlab("Reward Sensitivity") +
  ylab("(social win>social loss) > (doors win>doors loss)")
  #theme_ipsum()
p1
cor1 <- cor.test(df$comp_RS, df$pallidum_nppi_dmn, method = "pearson")
cor1

p2 <- ggplot(df, aes(x=comp_RS, y=post_cent_gyrus_ppi)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ x, se=TRUE) +
  scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("PPI-VS Model 3, Post Central Gyrus Connectivity") +
  xlab("Reward Sensitivity") +
  ylab("((social win + doors win)/2) > ((social loss+doors loss)/2)")
p2
cor2 <- cor.test(df$comp_RS, df$post_cent_gyrus_ppi, method = "pearson")
cor2

p3 <- ggplot(df, aes(x=comp_substance_use, y=post_cent_gyrus_ppi, color=group_two)) +
  geom_point() +
  geom_smooth(method="lm", formula=y ~ x, se=TRUE) +
  #scale_x_continuous(breaks = seq(-4.5, 4.5, by = 1)) +
  ggtitle("Act Model 2, Precuneus Activation") +
  xlab("Substance Use") +
  ylab("((social win + doors win)/2) > ((social loss+doors loss)/2)")
p3
#cor2 <- cor.test(df$comp_RS, df$post_cent_gyrus_ppi, method = "pearson")
#cor2


# histogram of audit_sum
comp_RS_square <- df$comp_RS_square
hist(audit,
     main="Distribution of AUDIT Scores",
     xlab="Total AUDIT Score",
     col="gray")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# scatterplots of VS activation with AUDIT
var1 <- df$pallidum_nppi_dmn_1
var2 <- df$comp_RS_square_1
var3 <- df$pallidum_nppi_dmn_2
var4 <- df$comp_RS_square_2
var5 <- df$pallidum_nppi_dmn_3
var6 <- df$comp_RS_square_3

# scatter plot for CB: BOLD * AUDIT for high vs. low RS
plot(var1, var2, pch=19,
     main = "nPPI-DMN Model 3, Pallidum Connectivity",
     xlab = "RS-square",
     ylab = "(social win>social loss) > (doors win>doors loss)",
     ylim = c(-50,50),
     col = "blue")
abline(lm(var2 ~ var1),col = "blue")
# add doors losses
points(var3, var4, pch=19, col = "red")
abline(lm(var3 ~ var4), col = "red")
# add doors losses
points(var5, var6, pch=19, col = "green")
abline(lm(var5 ~ var6), col = "green")
# add legend
legend("topright", legend=c("Low RS-sq", "Med RS-sq", "High RS-sq"), col=c("blue", "red", "green"), lty=1:1)
# add stats
cor1 <- cor.test(var1, var2, method = "pearson")
cor1
cor2 <- cor.test(var3, var4, method = "pearson")
cor2
cor3 <- cor.test(var5, var6, method = "pearson")
cor3