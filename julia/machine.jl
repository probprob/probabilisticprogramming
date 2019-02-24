
using Turing, MCMCChain
using Random, Distributions
using StatsPlots

HN=120
#firstn = length(ARGS) > 0 ? ARGS[1] : 3
#secondn = length(ARGS) > 1 ? ARGS[2] : 3
#data = repeat([firstn,secondn], HN)
N = 2 * HN
data = rand(MixtureModel([Binomial(2), Binomial(3)], [0.5, 0.5]), N)
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
#savefig("machine_$firstn" * "_$secondn.png")
savefig("machine_fair_mixture.png")