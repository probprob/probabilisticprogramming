library(plotly)
#
# plot_ly: rows along x-axis, columns along y-axis
plot_ly(z=~matrix(1:15, nrow=3), type="surface")
#
#persp(x=1:3, y=1:5, matrix(1:15, nrow=3))
# persp: column along x-axis, row along y-axis
#
m = diag(2)
# vektorisiert, nicht normiert
e2 <- function(x,y) exp(-rowSums((cbind(x,y) %*% solve(m) * cbind(x,y))))
#
x <- y<- seq(-4,4, length.out=100)
#persp(x=x, y=y, z=outer(x, y, function(a,b) e2(a,b)))

plot_ly(x=x, y=y, z=~outer(x, y, function(a,b) e2(a,b)), type="surface")

m=rbind(c(1.1,0.5), c(0.5,3.1))
#transponierung wegen x -> x-Achse
plot_ly(x=x, y=y, z=~t(outer(x, y, function(a,b) e2(a,b))), type="surface")
