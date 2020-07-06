module RemoveDateInformation

export sequence_and_intervals

include("types.jl")

include("default_values.jl")

include("public.jl")
include("public_sequence_and_intervals.jl")

include("assert.jl")
include("compute_interval_nonrounded.jl")

end
