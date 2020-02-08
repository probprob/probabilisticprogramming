library(forecast)
shampoo <- read.csv("./shampoo.csv")
View(shampoo)
plot(forecast(auto.arima(shampoo$Sales)))
#decompose(shampoo$Sales)

