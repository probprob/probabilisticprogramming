using Turing
using StatsPlots

# Define a simple Normal model with unknown mean and variance.
@model gdemo(x, y) = begin
  s ~ InverseGamma(2,3)
  m ~ Normal(0,sqrt(s))
  x ~ Normal(m, sqrt(s))
  y ~ Normal(m, sqrt(s))
end

#  Run sampler, collect results
chn = sample(gdemo(11.5, 12), HMC(1000, 0.1, 5))

# Summarise results (currently requires the master branch from MCMCChain)
describe(chn)

# Plot and save results
p = plot(chn)

