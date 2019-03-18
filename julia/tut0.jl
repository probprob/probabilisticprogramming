# https://github.com/TuringLang/TuringTutorials/blob/master/markdown/0_Introduction.md

# Load Turing and MCMCChain.
using Turing, MCMCChain
# Load the distributions library.
using Random, Distributions

# Load stats plots for density plots.
using StatsPlots

# Set the true probability of heads in a coin.
p_true = 0.5

# Iterate from having seen 0 observations to 100 observations.
Ns = 0:100;

Random.seed!(12)
data = rand(Bernoulli(p_true), last(Ns))


@model coinflip(y) = begin
    
    # Our prior belief about the probability of heads in a coin.
    p ~ Beta(10, 10)
    
    # The number of observations.
    N = length(y)
    for n in 1:N
        # Heads or tails of a coin are drawn from a Bernoulli distribution.
        y[n] ~ Bernoulli(p)
    end
end;


# Start sampling.
chain = sample(coinflip(data), HMC(1000, 0.05, 10));
describe(chain)
p_summary = Chains(chain[:p])
plot(p_summary, seriestype = :histogram)


