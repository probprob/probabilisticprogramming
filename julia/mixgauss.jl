#https://github.com/TuringLang/TuringTutorials/blob/master/1_GaussianMixtureModel.ipynb

using Turing, Distributions, StatsPlots, Random

# Set a random seed.
Random.seed!(3)

N = 30

# Parameters for each cluster, we assume that each cluster is Gaussian distributed in the example.
μs = [-3.5, 0.0]

# Construct the data points.
x = mapreduce(c -> rand(MvNormal([μs[c], μs[c]], 1.), N), hcat, 1:2)

# Visualization.
#scatter(x[1,:], x[2,:], legend = false, title = "Synthetic Dataset")


@model GaussianMixtureModel(x) = begin
    
    D, N = size(x)

    # Draw the paramters for cluster 1.
    mm1 ~ Normal()
    
    # Draw the paramters for cluster 2.
    mm2 ~ Normal()
    
    μ = [mm1, mm2]
    
    
    α = 1.0
    w ~ Dirichlet(2, α)
    
    
    # Draw assignments for each datum and generate it from a multivariate normal.
    k = Vector{Int}(undef, N)
    for i in 1:N
        k[i] ~ Categorical(w)
        x[:,i] ~ MvNormal([μ[k[i]], μ[k[i]]], 1.)
    end
    return k
end

Turing.setadbackend(:forward_diff)

gmm_model = GaussianMixtureModel(x);
gmm_sampler = Gibbs(100, PG(100, 1, :k), HMC(1, 0.05, 10, :mm1, :mm2, :w))
tchain = sample(gmm_model, gmm_sampler);

ids = findall(map(name -> occursin("mm", name) || occursin("w", name), tchain.names));
plot(Chains(tchain.value[:,ids,:], names = tchain.names[ids]), colordim = :parameter, legend = true)

