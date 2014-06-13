dat=read.table("household_power_consumption.txt",header=T,sep=";")
dat$Date=as.Date(dat$Date,format="%d/%m/%Y")
dat$Global_active_power=as.character(dat$Global_active_power)
dat$Global_active_power[which(dat$Global_active_power=="?")]=NA
dat$Global_active_power = as.numeric(dat$Global_active_power)
subsetIdx = which(dat$Date>="2007-02-01" & dat$Date<="2007-02-02")
hist(dat$Global_active_power[subsetIdx],col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power")
dev.copy(png, file = "plot1.png") 
dev.off()
