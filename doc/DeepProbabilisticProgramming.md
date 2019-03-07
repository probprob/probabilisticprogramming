# Deep Probabilistic Programming #

* Deep Generative Model  

* Deep Probabilistic Model  

* Deep Probabilistic Program  


# Variational Autoencoder #

* Prototypisches Deep Generative Model (2013)
* Encoder Network und Decoder Network
* bzw.: Inference Network und Generative Network 
* Probabilistiche Neuronale Netze
* Und trotzdem differenzierbar (sog. Reparametrisierungstrick)
* Stochastic Gradient Descent Training 
* liefert Posterior
* "Auto-Encoding Variational Bayes" 

# Tensorflow <-> Tensorflow Probability

* [VAE in Tensorflow](https://www.tensorflow.org/alpha/tutorials/generative/cvae)

* direkte Verwendung von Normalverteilungen  
*  


* [VAE in TF Probability](https://github.com/tensorflow/probability/blob/master/tensorflow_probability/examples/vae.py)
* Verwendung von Random Functions
* Random Functions enthalten die Netzwerke

# Probabilistic Layers #
* Layers for combining `tfp.distributions` and `tf.keras
* DistributionLambda
* class VariationalGaussianProcess(DistributionLambda)
* [Implementierung](https://github.com/tensorflow/probability/blob/73e457f2ca24ff961e69bc94f90a7a45f86d2253/tensorflow_probability/python/layers/distribution_layer.py)








