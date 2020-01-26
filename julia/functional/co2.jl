#https://github.com/STOR-i/GaussianProcesses.jl/blob/master/notebooks/Mauna_Loa_time_series.ipynb

using GaussianProcesses
using DelimitedFiles

data = readdlm("./CO2_data.csv", ',')

year = data[:,1]; co2 = data[:,2];
#Split the data into training and testing data
xtrain = year[year.<2004]; ytrain = co2[year.<2004];
xtest = year[year.>=2004]; ytest = co2[year.>=2004];

#Kernel is represented as a sum of kernels
kernel = SE(4.0,4.0) + Periodic(0.0,1.0,0.0)*SE(4.0,0.0) + RQ(0.0,0.0,-1.0) + SE(-2.0,-2.0);

gp = GP(xtrain,ytrain,MeanZero(),kernel,-2.0)   #Fit the GP

optimize!(gp) #Estimate the parameters through maximum likelihood estimation

μ, Σ = predict_y(gp,xtest);

using Plots

plot(xtest,μ,ribbon=Σ, title="Time series prediction",label="95% predictive confidence region")
scatter!(xtest,ytest,label="Observations")

