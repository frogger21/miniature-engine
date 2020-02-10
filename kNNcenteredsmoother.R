#Jae Chang 2020/Feb/09
#***dataset should be sorted by x values
# Here I simulate a sin wave with gaussian noise and use k-NN centered smoother 
x = seq(0,2*pi,length=1000)
Y = sin(x)*2 #the actual Y
Y_obs = Y + rnorm(length(x),0,0.8) #add noise to Y

x1 = matrix(x,length(x),1)
y1 = matrix(Y_obs,length(x),1)
sample_set = cbind(x1,y1) #in this example x is already sorted

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~  some functions needed   ~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
euclidean_distance <- function(p,q){
	#p and q are expected to be an array
	temp = 0
	for(i in 1:length(p)){
		temp = temp + (p[i]-q[i])^2
	}	
	tempAns = temp^(1/2)
	return(temp)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~nearest neighbour smoother~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

NNsmoother <- function(sample,k=16){
	#assuming matrix of nx2 matrix
	#this one is slower
	output_m = matrix(0,nrow(sample),2)
	for(i in 1:nrow(sample)){
		#idea is at each point in x we want to grab the k closest
		current_x = c(sample[i,1])
		score = matrix(0,nrow(sample),2) #1st col value of distance x from current_x, 2nd col value of y of x
		for(j in 1:nrow(sample)){
			temp = c(sample[j,1])
			score[j,1] = euclidean_distance(current_x,temp)
			score[j,2] = sample[j,2]
		}
		score = score[order(score[,1],decreasing=FALSE),] #closest to current_x at top in sorted matter
		output_m[i,1] = sample[i,1]
		output_m[i,2] = mean(score[1:k,2])
	}
	return(output_m)
}

#~~~~~~~~~~~~~~~~#
# matrix version #
#~~~~~~~~~~~~~~~~#

NNsmoother_fast <- function(sample,k=17,type="c"){
	#assume sample is sorted by x, k should be odd
	#this is a centered version (it's basically a centered moving average)
	if(k %% 2 == 0){
		stop("k must be odd")
	}
	m = nrow(sample)
	S = matrix(0,m-k+1,m)
	counter = 1
	for(i in 1:(m-k+1)){
		S[i,(counter):(counter+k-1)] = seq(1:k)*0 + 1/k
		counter = counter + 1
	}
	output = S[1:(m-(k-1)),1:m]%*%sample[,2] #assuming 1st column is x and 2nd column is y
	weuseX = sample[(floor(k/2)+1):(m-floor(k/2)),1] #the x points associated with the smoothed values
	if(type!="c"){
		#one sided
		weuseX = sample[k:m,1] #the x points associated with the smoothed values
	}
	output2 = cbind(weuseX,output)
	return(output2)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~plot of actual and smoothers~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
par(mfrow=c(1,1))
par(cex=1)
k = 61
testing = NNsmoother(sample_set,k)
plot(x,Y_obs,type="p",main="(ignores boundary problem)k-Nearest Neighbor Smoother")
lines(x,Y,col="red",lwd=2)
legend("bottomleft",box.lty=1,legend=c("Observed = Y + Gaussian Noise","True Y",paste("Nearest Neighbor smoother k =",k)),col=c("black","red","purple"),lwd=c(NA,2,2),pch=c(1,NA,NA))
lines(testing[,1],testing[,2],col="purple",lwd=2)

faster = NNsmoother_fast(sample_set,k,"c")
faster2 = NNsmoother_fast(sample_set,k,"s")
plot(x,Y_obs,type="p",main="Centered k-Nearest Neighbor Smoother",ylab="Y",xlab="X")
lines(x,Y,col="red",lwd=2)
lines(faster[,1],faster[,2],col="purple",lwd=3)
lines(faster2[,1],faster2[,2],col="seagreen4",lwd=3)
legend("bottomleft",box.lty=1,legend=c("Observed = Y + Gaussian Noise","True Y",paste("centered NN smoother k =",k),"one-sided NN smoother"),col=c("black","red","purple","green"),lwd=c(NA,2,2,2),pch=c(1,NA,NA,NA))





