
library(car)
library(gplots)
library(psych)

# 导入数据
# 首先去掉了一些缺失变量并且选择要分析的变量
soil <- read.csv('soil.csv',header = T)
my_soil <- soil[,c(4,7:34)]
str(my_soil)

water <- read.csv('water.csv',header = T)
my_water <- water[,c(3,6:11,14:16,20:21,23:25,27,29:32)]
str(my_water)


# normal Transform
normal_transfrom <- function(mydata){
	for (i in names(mydata[,-1])) {
		x <- mydata[,i]
		if(shapiro.test(x)$p>=0.05){
			cat(i,' ==== is normal and p value of w test is ',round(shapiro.test(x)$p,4),'\n')
		} else if(sum(x<=0,na.rm=T)==0){
		  if(shapiro.test(log(x))$p>=0.05 ){
	          cat(i,' ==== log transfrom is normal and p value of w test is ',round(shapiro.test(log(x))$p,4),'\n')
		  } else if(shapiro.test(log10(x))$p>=0.05){
		  	cat(i,' ==== log10 transfrom is normal and p value of w testis ',round(shapiro.test(log10(x))$p,4),'\n')
		  } else{
			a <- round(powerTransform(x)$lambda,2)
			cat(i,' ==== try powerTransform,lambda is ',a,'p value of w test  is ',round(shapiro.test(x^a)$p,4),'\n')}
		}
	}
}

# 运行程序
normal_transfrom(my_soil)
normal_transfrom(my_water)

# scatterplotMatrix
scatterplotMatrix(~.|my_water$Sample,data = my_water[,-1])
scatterplotMatrix(~.|my_soil$Type,data = my_soil[,-1])


# histogram
my_hist <- function(mydata,col=c(2:7)){
	par(mfrow=c(2,3),las=2)
	for (i in col) {
	  hist(mydata[,i],main=names(mydata)[i],probability = T,xlab='',ylab='')
	  lines(density(na.omit(mydata[,i])),col='red',lty=2)
	}
}

my_hist(mydata = my_soil,col=2:7)
my_hist(mydata = my_soil,col=8:13)
my_hist(mydata = my_soil,col=14:19)
my_hist(mydata = my_water,col=2:7)
my_hist(mydata = my_water,col=8:13)
my_hist(mydata = my_water,col=14:19)


# boxplot
my_box <- function(mydata,col=c(2:7)){
	par(mfrow=c(2,3),las=2)
	for (i in col) {
	  boxplot(mydata[,i]~mydata[,1],
	  	data=mydata,
	  	outline=F,
	  	col=colors()[c(25,35,45)],
	  	main=names(mydata)[i])
	}
}

my_box(mydata = my_soil,col=2:7)
my_box(mydata = my_soil,col=8:13)
my_box(mydata = my_soil,col=14:19)
my_box(mydata = my_water,col=2:7)
my_box(mydata = my_water,col=8:13)
my_box(mydata = my_water,col=14:19)


# mean plot 
my_mean_compare <- function(mydata,col=c(2:7)){
	par(mfrow=c(2,3),las=2)
	for (i in col) {
    plotmeans(mydata[,i]~mydata[,1],
			   	na.action=na.omit,
			   	use.t = F,
			   	bars = T,
			   	n.label = F,
			   	mean.labels = F,
			   	digits = 2,
			   	xlab='',
			   	ylab='',
			   	main=names(mydata)[i])
	}
}
my_mean_compare(mydata = my_soil,col=2:7)
my_mean_compare(mydata = my_soil,col=8:13)
my_mean_compare(mydata = my_soil,col=14:19)
my_mean_compare(mydata = my_water,col=2:7)
my_mean_compare(mydata = my_water,col=8:13)
my_mean_compare(mydata = my_water,col=14:19)



# relationship

corr.test(my_water[,-1])
corr.test(my_soil[,-1])




histogram( ~ height | voice.part, data = singer,
          xlab = "Height (inches)", type = "density",
          panel = function(x, ...) {
              panel.histogram(x, ...)
              panel.mathdensity(dmath = dnorm, col = "black",
                                args = list(mean=mean(x),sd=sd(x)))
          } )