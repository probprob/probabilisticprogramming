using Turing, Distributions, StatsPlots, Random

Random.seed!(3)

#Mixture univariater Gauss Verteilungen

N = 30
x1 = rand(Normal(10), N)
x2 = rand(Normal(-10), N)



@model GaussianMixtureModel(x1, x2) = begin
    

    # Prior mean cluster 1.
    mm1 ~ Normal()
    
    # Prior mean cluster 2.
    mm2 ~ Normal()
    
    μ = [mm1, mm2]
    
    
    α = 1.0
    #schwacher Prior
    w ~ Dirichlet(2, 5)
    
    
    k = Vector{Int}(undef, N)
    for i in 1:N
        k[i] ~ Categorical(w)
        x1[i] ~ Normal(μ[k[i]], 1.)
        x2[i] ~ Normal(μ[k[i]], 1.)
    end 
    return k
end

Turing.setadbackend(:forward_diff)

gmm_model = GaussianMixtureModel(x1, x2);
gmm_sampler = Gibbs(40, PG(100, 1, :k), HMC(100, 0.05, 10, :mm1, :mm2, :w))
tchain = sample(gmm_model, gmm_sampler);

ids = findall(map(name -> occursin("mm", name) || occursin("w", name), tchain.names));
plot(Chains(tchain.value[:,ids,:], names = tchain.names[ids]), colordim = :parameter, legend = true)

