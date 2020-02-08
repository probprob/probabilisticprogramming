m <- decompose(co2)
str(m)
plot(m)
m$type
stl(co2, s.window="periodic")
plot(stl(co2, s.window="periodic"))
library(forecast)
plot(forecast(co2))
str(forecast(co2))
