if (!file.exists("household_power_consumption.rds")) {
  if (!file.exists("household_power_consumption.zip")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, dest="household_power_consumption.zip", mode="wb") 
  }
  unzip(zipfile="household_power_consumption.zip")
  dta <- read.table("household_power_consumption.txt",
                    header = TRUE,
                    sep = ";",
                    na.strings = c("NA", "?"))
  dta$date <- strptime(paste(as.Date(dta$Date, "%d/%m/%Y"), dta$Time), format = "%Y-%m-%d %H:%M:%S")
  dta <- dta[dta$date >= "2007-02-01 00:00:00 CET" & dta$date < "2007-02-03 00:00:00 CET", ]
  dta <- na.omit(dta) # somehow, some date conversions (in March in the years 2007 - 2010) yield NA values. We ignore them for the assignment as these dates are not in the scope of the exercises
  saveRDS(dta, file = "household_power_consumption.rds")
}

dta <- invisible(readRDS("household_power_consumption.rds"))
par(mfrow = c(1,1))

## Plot 3: Energy submetering by day and by meter
plot(dta$date, dta$Sub_metering_1,
     xlab = "",
     ylab = "Energy sub metering",
     type = "l")
lines(dta$date, dta$Sub_metering_2, col = "red")
lines(dta$date, dta$Sub_metering_3, col = "blue")
legend("topright",
       lty = 1, 
       col = c("black", "red", "blue"),
       legend = colnames(dta[7:9]))
dev.copy(png, file = "plot3.png")
dev.off()
