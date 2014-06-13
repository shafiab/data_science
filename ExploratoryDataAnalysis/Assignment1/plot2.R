dat=read.table("household_power_consumption.txt",header=T,sep=";",as.is=T)
dat$Date=as.Date(dat$Date,format="%d/%m/%Y")
dat$Global_active_power=as.character(dat$Global_active_power)
dat$Global_active_power[which(dat$Global_active_power=="?")]=NA
dat$Global_active_power = as.numeric(dat$Global_active_power)
subsetIdx = which(dat$Date>="2007-02-01" & dat$Date<="2007-02-02")

newDat=dat[subsetIdx,]
x=strptime(paste(newDat$Date,newDat$Time),format = "%Y-%m-%d %H:%M:%S")
y = newDat$Global_active_power
plot(x,y,type='l',ylab="Global Active Power (kilowatts)",xlab="")
dev.copy(png, file = "plot2.png") 
dev.off()