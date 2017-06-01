


myf <- function(n) {
	rt <- (433.6 * 1199.3) /((433.6^n+1199.3^n)^(1/n))-405.6
	return(rt)
}

dmyf <- D(expression((433.6 * 1199.3) /((433.6^n+1199.3^n)^(1/n))-405.6),'n')

ddmyf <- function(n){
	rt <- -((433.6 * 1199.3) * ((433.6^n + 1199.3^n)^((1/n) - 1) * ((1/n) * 
    (433.6^n * log(433.6) + 1199.3^n * log(1199.3))) - (433.6^n + 
    1199.3^n)^(1/n) * (log((433.6^n + 1199.3^n)) * (1/n^2)))/((433.6^n + 
    1199.3^n)^(1/n))^2)
    return(rt)
}

acc <- 1e-4
diff <- Inf

while(abs(diff)>acc){
   n <- n - myf(n) / ddmyf(n)
   diff <- myf(n)
}
n
