import Dates
import DateShifting
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

    Test.@testset "sequence_and_intervals.jl" begin
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
                observed_sequence, observed_intervals = DateShifting.sequence_and_intervals(input, round_to_period)
                Test.@test observed_sequence == expected_sequence
                Test.@test observed_intervals == expected_intervals_round_to[round_to_period]
            end
        end
    end
end
