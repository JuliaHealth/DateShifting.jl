import Dates
import DateShifting
import Distributions
import Random
import TimeZones
import Test

Test.@testset "DateShifting.jl" begin
    Test.@testset "assert.jl" begin
        Test.@test nothing == Test.@test_nowarn DateShifting.always_assert(1 == 1)
        Test.@test_throws DateShifting.AlwaysAssertionError DateShifting.always_assert(1 == 2)
    end

    Test.@testset "compute_interval_nonrounded.jl" begin
        Test.@test DateShifting._compute_interval_nonrounded(Dates.DateTime("2000-01-01"), Dates.DateTime("2000-01-02")) == Dates.Day(1)
        Test.@test_throws ArgumentError DateShifting._compute_interval_nonrounded(Dates.DateTime("2000-01-02"), Dates.DateTime("2000-01-01"))
    end

    Test.@testset "sample.jl" begin
        Test.@test DateShifting._draw_sample(Random.GLOBAL_RNG, Dates.Day, nothing) == Dates.Day(0)
    end

    Test.@testset "public_sequence_and_intervals.jl" begin
        datetime_list = [
            Dates.DateTime("1900-01-01T00:00:00"),
            Dates.DateTime("1901-01-01T00:00:00"),
            Dates.DateTime("1900-02-01T00:00:00"),
            Dates.DateTime("1900-01-01T00:00:00"),
            Dates.DateTime("1900-01-03T00:00:00"),
            Dates.DateTime("1900-01-05T00:00:00"),
            Dates.DateTime("1900-01-02T00:00:00"),
            Dates.DateTime("1900-01-01T00:00:00.001"),
            Dates.DateTime("1900-01-01T00:20:00"),
            Dates.DateTime("1900-01-01T00:30:00"),
        ]

        zoneddatetime_list = [TimeZones.ZonedDateTime(x, TimeZones.tz"America/New_York") for x in datetime_list]

        expected_sequence = [1, 4, 8, 9, 10, 7, 5, 6, 3, 2]

        expected_intervals_round_to = Dict()
        expected_intervals_round_to[Dates.Day(1)] = [Dates.Day(0), Dates.Day(365), Dates.Day(31), Dates.Day(0), Dates.Day(2), Dates.Day(4), Dates.Day(1), Dates.Day(0), Dates.Day(0), Dates.Day(0)]
        expected_intervals_round_to[Dates.Day(2)] = [Dates.Day(0), Dates.Day(366), Dates.Day(32), Dates.Day(0), Dates.Day(2), Dates.Day(4), Dates.Day(2), Dates.Day(0), Dates.Day(0), Dates.Day(0)]
        expected_intervals_round_to[Dates.Hour(1)] = [Dates.Hour(0), Dates.Hour(8760), Dates.Hour(744), Dates.Hour(0), Dates.Hour(48), Dates.Hour(96), Dates.Hour(24), Dates.Hour(0), Dates.Hour(0), Dates.Hour(1)]
        expected_intervals_round_to[Dates.Hour(2)] = [Dates.Hour(0), Dates.Hour(8760), Dates.Hour(744), Dates.Hour(0), Dates.Hour(48), Dates.Hour(96), Dates.Hour(24), Dates.Hour(0), Dates.Hour(0), Dates.Hour(0)]
        expected_intervals_round_to[Dates.Minute(1)] = [Dates.Minute(0), Dates.Minute(525600), Dates.Minute(44640), Dates.Minute(0), Dates.Minute(2880), Dates.Minute(5760), Dates.Minute(1440), Dates.Minute(0), Dates.Minute(20), Dates.Minute(30)]
        expected_intervals_round_to[Dates.Minute(2)] = [Dates.Minute(0), Dates.Minute(525600), Dates.Minute(44640), Dates.Minute(0), Dates.Minute(2880), Dates.Minute(5760), Dates.Minute(1440), Dates.Minute(0), Dates.Minute(20), Dates.Minute(30)]
        expected_intervals_round_to[Dates.Second(1)] = [Dates.Second(0), Dates.Second(31536000), Dates.Second(2678400), Dates.Second(0), Dates.Second(172800), Dates.Second(345600), Dates.Second(86400), Dates.Second(0), Dates.Second(1200), Dates.Second(1800)]
        expected_intervals_round_to[Dates.Second(2)] = [Dates.Second(0), Dates.Second(31536000), Dates.Second(2678400), Dates.Second(0), Dates.Second(172800), Dates.Second(345600), Dates.Second(86400), Dates.Second(0), Dates.Second(1200), Dates.Second(1800)]

        for round_to_period in keys(expected_intervals_round_to)
            for input in Any[datetime_list, zoneddatetime_list]
                observed_sequence, observed_intervals = DateShifting.sequence_and_intervals(input;
                                                                                            round_to = round_to_period)
                Test.@test observed_sequence == expected_sequence
                Test.@test observed_intervals == expected_intervals_round_to[round_to_period]
            end
        end
    end

    Test.@testset "public_sequence_and_random_date_shift.jl" begin
        datetime_list = [
            Dates.DateTime("1900-01-01T00:00:00"),
            Dates.DateTime("1901-01-01T00:00:00"),
            Dates.DateTime("1900-02-01T00:00:00"),
            Dates.DateTime("1900-01-01T00:00:00"),
            Dates.DateTime("1900-01-03T00:00:00"),
            Dates.DateTime("1900-01-05T00:00:00"),
            Dates.DateTime("1900-01-02T00:00:00"),
            Dates.DateTime("1900-01-01T00:20:00"),
            Dates.DateTime("1900-01-01T00:30:00"),
        ]

        zoneddatetime_list = [TimeZones.ZonedDateTime(x, TimeZones.tz"America/Los_Angeles") for x in datetime_list]

        expected_sequence = [1, 4, 8, 9, 7, 5, 6, 3, 2]

        round_to_periods = Dates.Period[
            Dates.Second(1),
            Dates.Second(2),
            Dates.Second(3),
            Dates.Second(5),
            Dates.Second(10),
            Dates.Millisecond(1),
            Dates.Millisecond(2),
            Dates.Millisecond(3),
            Dates.Millisecond(5),
            Dates.Millisecond(10),
            Dates.Millisecond(100),
            Dates.Millisecond(500),
            Dates.Millisecond(1000),
        ]

        for round_to_period in round_to_periods
            for input in Any[datetime_list, zoneddatetime_list]
                observed_sequence, observed_shifted_dates = DateShifting.sequence_and_random_date_shift(
                    Random.GLOBAL_RNG,
                    input;
                    round_to = round_to_period,
                    time_zone = TimeZones.TimeZone("America/Chicago"),
                    day = Distributions.DiscreteUniform(-31, 31),
                    hour = Distributions.DiscreteUniform(-24, 24),
                    minute = Distributions.DiscreteUniform(-60, 60),
                    second = Distributions.DiscreteUniform(-60, 60),
                    millisecond = Distributions.DiscreteUniform(-1000, 1000),
                    microsecond = Distributions.DiscreteUniform(-1000, 1000),
                    nanosecond = nothing,
                )
                Test.@test observed_sequence == expected_sequence
                Test.@test sortperm(input) == observed_sequence
                Test.@test sortperm(input) == expected_sequence
                Test.@test sortperm(observed_shifted_dates) == observed_sequence
                Test.@test sortperm(observed_shifted_dates) == expected_sequence
            end
        end
    end
end
