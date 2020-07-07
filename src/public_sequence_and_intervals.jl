import Dates
import TimeZones

"""
    sequence_and_intervals(input_dt_list::Vector{Dates.DateTime};
                           round_to::Dates.Period)

## Arguments
- `input_dt_list::Vector{Dates.DateTime}`: A vector of `DateTime`s.

## Keyword Arguments
- `round_to::Dates.Period`: Resolution to which all intervals should be rounded.

## Example

```jldoctest
julia> using Dates

julia> using DateShifting

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

julia> sequence, intervals = sequence_and_intervals(dates; round_to = Day(1))
([1, 5, 4, 3, 2], [Day(0), Day(31), Day(4), Day(1), Day(1)])

julia> sequence
5-element Array{Int64,1}:
 1
 5
 4
 3
 2

julia> intervals
5-element Array{Day,1}:
 0 days
 31 days
 4 days
 1 day
 1 day
```
"""
function sequence_and_intervals(input_dt_list::Vector{Dates.DateTime};
                                round_to::Dates.Period)
    input_zdt_list = [TimeZones.ZonedDateTime(x, Dates.TimeZone("UTC")) for x in input_dt_list]
    return sequence_and_intervals(input_zdt_list; round_to = round_to)
end

"""
    sequence_and_intervals(input_zdt_list::Vector{TimeZones.ZonedDateTime},
                           round_to::Dates.Period)

## Arguments
- `input_zdt_list::Vector{TimeZones.ZonedDateTime}`: A vector of `ZonedDateTime`s.

## Keyword Arguments
- `round_to::Dates.Period`: Resolution to which all intervals should be rounded.


## Example

```jldoctest
julia> using Dates

julia> using DateShifting

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

julia> sequence, intervals = sequence_and_intervals(dates; round_to = Day(1))
([1, 5, 4, 3, 2], [Day(0), Day(31), Day(4), Day(1), Day(1)])

julia> sequence
5-element Array{Int64,1}:
 1
 5
 4
 3
 2

julia> intervals
5-element Array{Day,1}:
 0 days
 31 days
 4 days
 1 day
 1 day
```
"""
function sequence_and_intervals(input_zdt_list::Vector{TimeZones.ZonedDateTime};
                                round_to::Dates.Period)
    sequence = sortperm(input_zdt_list)

    value, index_of_input_start_zoned_datetime = findmin(sequence)
    always_assert(value == 1)
    input_start_zoned_datetime = input_zdt_list[index_of_input_start_zoned_datetime]

    intervals_nonrounded = [_compute_interval_nonrounded(input_start_zoned_datetime, x) for x in input_zdt_list]
    intervals = [round(interval, round_to) for interval in intervals_nonrounded]

    return sequence, intervals
end
