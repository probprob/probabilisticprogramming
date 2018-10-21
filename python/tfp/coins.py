import tensorflow as tf
import tensorflow_probability as tfp

tf.enable_eager_execution()

tfd = tfp.distributions

fair=[0.5, 0.5]
coin=tfd.Categorical(probs=fair)
#Binomial wegen len(fair) == 2
twoCoins = tfd.Multinomial(probs=fair, total_count=2.)
threeCoins = tfd.Multinomial(probs=fair, total_count=3.)

mixture = tfd.Mixture(cat=coin, components=[twoCoins, threeCoins])

nrsamples=10000
stwo = twoCoins._sample_n(nrsamples)
sthree = threeCoins._sample_n(nrsamples)
smix = mixture._sample_n(nrsamples)

summary=tf.contrib.summary
writer = summary.create_file_writer("logevents")
with writer.as_default(), summary.always_record_summaries():
    summary.histogram(name="two coins", tensor=stwo)
    summary.histogram(name="three coins", tensor=sthree)
    summary.histogram(name="mixture", tensor=smix)
    summary.scalar("mean two", tf.reduce_mean(stwo))
    summary.scalar("mean three", tf.reduce_mean(sthree))
    summary.scalar("mean mix", tf.reduce_mean(smix))
    writer.flush()

#tensorboard --logdir logevents/
#http://localhost:6006/#histograms
