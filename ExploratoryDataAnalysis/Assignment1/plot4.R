dat=read.table("household_power_consumption.txt",header=T,sep=";",as.is=T)
dat$Date=as.Date(dat$Date,format="%d/%m/%Y")
subsetIdx = which(dat$Date>="2007-02-01" & dat$Date<="2007-02-02")

newDat=dat[subsetIdx,]

par(mfrow = c(2, 2))
datetime=strptime(paste(newDat$Date,newDat$Time),format = "%Y-%m-%d %H:%M:%S")

plot(datetime,as.numeric(newDat$Global_active_power),type='l',ylab="Global Active Power (kilowatts)",xlab="")
plot(datetime,as.numeric(newDat$Voltage),type='l',ylab="Voltage")
plot(datetime,as.numeric(newDat$Sub_metering_1),type='l',xlab="",ylab="Energy sub metering")
lines(datetime,as.numeric(newDat$Sub_metering_2),col="red")
lines(datetime,as.numeric(newDat$Sub_metering_3),col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","blue","red"), lty=c(1, 1, 1), bty="n", y.intersp = 0.3,cex=0.75,pt.cex=1,inset=-.09)
plot(datetime,as.numeric(newDat$Global_reactive_power), ylab="Global_reactive_power",type="l")

dev.copy(png, file = "plot4.png") 
dev.off()
