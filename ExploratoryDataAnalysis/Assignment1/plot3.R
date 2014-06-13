dat=read.table("household_power_consumption.txt",header=T,sep=";",as.is=T)
dat$Date=as.Date(dat$Date,format="%d/%m/%Y")
subsetIdx = which(dat$Date>="2007-02-01" & dat$Date<="2007-02-02")

newDat=dat[subsetIdx,]
x=strptime(paste(newDat$Date,newDat$Time),format = "%Y-%m-%d %H:%M:%S")

plot(x,as.numeric(newDat$Sub_metering_1),type='l',xlab="",ylab="Energy sub metering")
lines(x,as.numeric(newDat$Sub_metering_2),col="red")
lines(x,as.numeric(newDat$Sub_metering_3),col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","blue","red"), lty=c(1, 1, 1))

dev.copy(png, file = "plot3.png") 
dev.off()