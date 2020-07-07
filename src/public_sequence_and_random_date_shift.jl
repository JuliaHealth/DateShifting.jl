import Dates
import Distributions
import Random
import TimeZones

const _kwargs_docstring_for_sequence_and_random_date_shift = """
## Keyword Arguments
- `round_to::Dates.Period`: Resolution to which all intervals should be rounded.
- `time_zone::Dates.TimeZone`: Time zone to which all output dates should be converted.
- `day::::Union{Distributions.Sampleable, Nothing}`: Probability distribution from which the `Day` shift amount will be sampled.
- `hour::::Union{Distributions.Sampleable, Nothing}`: Probability distribution from which the `Hour` shift amount will be sampled.
- `minute::::Union{Distributions.Sampleable, Nothing}`: Probability distribution from which the `Minute` shift amount will be sampled.
- `second::::Union{Distributions.Sampleable, Nothing}`: Probability distribution from which the `Second` shift amount will be sampled.
- `millisecond::::Union{Distributions.Sampleable, Nothing}`: Probability distribution from which the `Millisecond` shift amount will be sampled.
- `microsecond::::Union{Distributions.Sampleable, Nothing}`: Probability distribution from which the `Microsecond` shift amount will be sampled.
- `nanosecond::::Union{Distributions.Sampleable, Nothing}`: Probability distribution from which the `Nanosecond` shift amount will be sampled.
"""

"""
    sequence_and_random_date_shift(rng::Random.AbstractRNG,
                                   input_dt_list::Vector{Dates.DateTime};
                                   round_to::Dates.Period)

## Arguments
- `input_dt_list::Vector{Dates.DateTime}`: A vector of `DateTime`s.

$(_kwargs_docstring_for_sequence_and_random_date_shift)

## Example

```jldoctest; setup = :(import Random; Random.seed!(123))
julia> using Dates

julia> using DateShifting

julia> using Distributions

julia> using Random

julia> using TimeZones

julia> dates = [
           DateTime("2000-01-01T00:00:00"),
           DateTime("2000-02-01T00:00:00"),
           DateTime("2000-01-05T00:00:00"),
           DateTime("2000-01-02T04:05:06"),
           DateTime("2000-01-02T01:02:03"),
       ]
5-element Array{DateTime,1}:
 2000-01-01T00:00:00
 2000-02-01T00:00:00
 2000-01-05T00:00:00
 2000-01-02T04:05:06
 2000-01-02T01:02:03

julia> sequence, shifted_dates = sequence_and_random_date_shift(
           Random.GLOBAL_RNG,
           dates;
           round_to = Day(1),
           time_zone = TimeZone("America/New_York"),
           day = DiscreteUniform(-31, 31),
           hour = DiscreteUniform(-24, 24),
           minute = DiscreteUniform(-60, 60),
           second = DiscreteUniform(-60, 60),
           millisecond = DiscreteUniform(-1000, 1000),
           microsecond = DiscreteUniform(-1000, 1000),
           nanosecond = DiscreteUniform(-1000, 1000),
       )
([1, 5, 4, 3, 2], [ZonedDateTime(2000, 1, 16, tz"America/New_York"), ZonedDateTime(2000, 2, 16, tz"America/New_York"), ZonedDateTime(2000, 1, 20, tz"America/New_York"), ZonedDateTime(2000, 1, 18, tz"America/New_York"), ZonedDateTime(2000, 1, 18, tz"America/New_York")])

julia> sequence
5-element Array{Int64,1}:
 1
 5
 4
 3
 2

julia> shifted_dates
5-element Array{ZonedDateTime,1}:
 2000-01-16T00:00:00-05:00
 2000-02-16T00:00:00-05:00
 2000-01-20T00:00:00-05:00
 2000-01-18T00:00:00-05:00
 2000-01-18T00:00:00-05:00
```
"""
function sequence_and_random_date_shift(rng::Random.AbstractRNG,
                                        input_dt_list::Vector{Dates.DateTime};
                                        time_zone::Dates.TimeZone,
                                        kwargs...)
    input_zdt_list = [TimeZones.ZonedDateTime(x, time_zone) for x in input_dt_list]
    return sequence_and_random_date_shift(rng, input_zdt_list; time_zone = time_zone, kwargs...)
end

"""
    sequence_and_random_date_shift(rng::Random.AbstractRNG,
                                   input_zdt_list::Vector{TimeZones.ZonedDateTime},
                                   round_to::Dates.Period)

## Arguments
- `input_zdt_list::Vector{TimeZones.ZonedDateTime}`: A vector of `ZonedDateTime`s.

$(_kwargs_docstring_for_sequence_and_random_date_shift)

## Example

```jldoctest; setup = :(import Random; Random.seed!(123))
julia> using Dates

julia> using DateShifting

julia> using Distributions

julia> using Random

julia> using TimeZones

julia> dates = [
           ZonedDateTime(DateTime("2000-01-01T00:00:00"), tz"America/New_York"),
           ZonedDateTime(DateTime("2000-02-01T00:00:00"), tz"America/New_York"),
           ZonedDateTime(DateTime("2000-01-05T00:00:00"), tz"America/New_York"),
           ZonedDateTime(DateTime("2000-01-02T03:05:06"), tz"America/Chicago"),
           ZonedDateTime(DateTime("2000-01-02T01:02:03"), tz"America/New_York"),
       ]
5-element Array{ZonedDateTime,1}:
 2000-01-01T00:00:00-05:00
 2000-02-01T00:00:00-05:00
 2000-01-05T00:00:00-05:00
 2000-01-02T03:05:06-06:00
 2000-01-02T01:02:03-05:00

julia> sequence, shifted_dates = sequence_and_random_date_shift(
           Random.GLOBAL_RNG,
           dates;
           round_to = Day(1),
           time_zone = TimeZone("America/New_York"),
           day = DiscreteUniform(-31, 31),
           hour = DiscreteUniform(-24, 24),
           minute = DiscreteUniform(-60, 60),
           second = DiscreteUniform(-60, 60),
           millisecond = DiscreteUniform(-1000, 1000),
           microsecond = DiscreteUniform(-1000, 1000),
           nanosecond = DiscreteUniform(-1000, 1000),
       )
([1, 5, 4, 3, 2], [ZonedDateTime(2000, 1, 16, tz"America/New_York"), ZonedDateTime(2000, 2, 16, tz"America/New_York"), ZonedDateTime(2000, 1, 20, tz"America/New_York"), ZonedDateTime(2000, 1, 18, tz"America/New_York"), ZonedDateTime(2000, 1, 18, tz"America/New_York")])

julia> sequence
5-element Array{Int64,1}:
 1
 5
 4
 3
 2

julia> shifted_dates
5-element Array{ZonedDateTime,1}:
 2000-01-16T00:00:00-05:00
 2000-02-16T00:00:00-05:00
 2000-01-20T00:00:00-05:00
 2000-01-18T00:00:00-05:00
 2000-01-18T00:00:00-05:00
```
"""
function sequence_and_random_date_shift(rng::Random.AbstractRNG,
                                        input_zdt_list::Vector{TimeZones.ZonedDateTime};
                                        round_to::Dates.Period,
                                        time_zone::Dates.TimeZone,
                                        day::Union{Distributions.Sampleable, Nothing},
                                        hour::Union{Distributions.Sampleable, Nothing},
                                        minute::Union{Distributions.Sampleable, Nothing},
                                        second::Union{Distributions.Sampleable, Nothing},
                                        millisecond::Union{Distributions.Sampleable, Nothing},
                                        microsecond::Union{Distributions.Sampleable, Nothing},
                                        nanosecond::Union{Distributions.Sampleable, Nothing})
    sequence = sortperm(input_zdt_list)

    input_zdt_list_sametimezone = [TimeZones.astimezone(x, time_zone) for x in input_zdt_list]
    always_assert(sortperm(input_zdt_list_sametimezone) == sequence)

    day_shift_amount = _draw_sample(rng, Dates.Day, day)
    hour_shift_amount = _draw_sample(rng, Dates.Hour, hour)
    minute_shift_amount = _draw_sample(rng, Dates.Minute, minute)
    second_shift_amount = _draw_sample(rng, Dates.Second, second)
    millisecond_shift_amount = _draw_sample(rng, Dates.Millisecond, millisecond)
    microsecond_shift_amount = _draw_sample(rng, Dates.Microsecond, microsecond)
    nanosecond_shift_amount = _draw_sample(rng, Dates.Nanosecond, nanosecond)

    total_shift_amount = day_shift_amount + hour_shift_amount +
                                            minute_shift_amount +
                                            second_shift_amount +
                                            millisecond_shift_amount +
                                            microsecond_shift_amount +
                                            nanosecond_shift_amount

    shifted_dates_nonrounded = [x + total_shift_amount for x in input_zdt_list_sametimezone]
    shifted_dates = [round(x, round_to) for x in shifted_dates_nonrounded]

    always_assert(all(TimeZones.timezone.(shifted_dates_nonrounded) .== time_zone))
    always_assert(all(TimeZones.timezone.(shifted_dates) .== time_zone))

    return sequence, shifted_dates
end
