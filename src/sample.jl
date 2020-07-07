import Distributions
import Random

function _draw_sample(rng::Random.AbstractRNG,
                      T::Type,
                      distribution::Nothing)
    return zero(T)
end

function _draw_sample(rng::Random.AbstractRNG,
                      T::Type,
                      distribution::Distributions.Sampleable)
    numerical_value = rand(rng, distribution)
    return T(numerical_value)
end
