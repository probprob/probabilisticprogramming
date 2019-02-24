
using Turing, MCMCChain
using Random, Distributions
using StatsPlots

HN=20
data = repeat([1,2], HN)
N = 2 * HN

@model machine(y) = begin
    
    # schwacher Prior 
    hidden ~ Beta(2, 2)
    sizes = [2, 3]

    # The number of observations.
    N = length(y)
    k = TArray{Int}(undef, N)
    for n in 1:N
        # Mixture 
        k[n] ~ Categorical([hidden, 1-hidden])
        y[n] ~ Binomial(sizes[k[n]])
    end
    return k
end;

iterations = 200

# Start sampling.

machinedata = machine(data)
chain = sample(machinedata, PG(iterations,100))

hiddensamples=chain[:hidden]
p_summary = Chains(hiddensamples)
plot(p_summary, seriestype = :histogram)

