var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = DateShifting","category":"page"},{"location":"#DateShifting","page":"Home","title":"DateShifting","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [DateShifting]","category":"page"},{"location":"#DateShifting.sequence_and_intervals-Tuple{Array{Dates.DateTime,1},Dates.Period}","page":"Home","title":"DateShifting.sequence_and_intervals","text":"sequence_and_intervals(input_datetime_list::Vector{Dates.DateTime},\n                       round_to::Dates.Period;\n                       time_zone::Dates.TimeZone = UTC)\n\nExamples\n\njulia> using Dates\n\njulia> using DateShifting\n\njulia> dates = [\n           DateTime(\"2000-01-01T00:00:00\"),\n           DateTime(\"2000-02-01T00:00:00\"),\n           DateTime(\"2000-01-05T00:00:00\"),\n           DateTime(\"2000-01-02T04:05:06\"),\n           DateTime(\"2000-01-02T01:02:03\"),\n       ]\n5-element Array{DateTime,1}:\n 2000-01-01T00:00:00\n 2000-02-01T00:00:00\n 2000-01-05T00:00:00\n 2000-01-02T04:05:06\n 2000-01-02T01:02:03\n\njulia> round_to = Day(1)\n1 day\n\njulia> sequence, intervals = sequence_and_intervals(dates, round_to)\n([1, 5, 4, 3, 2], Dates.Day[0 days, 31 days, 4 days, 1 day, 1 day])\n\njulia> sequence\n5-element Array{Int64,1}:\n 1\n 5\n 4\n 3\n 2\n\njulia> intervals\n5-element Array{Day,1}:\n 0 days\n 31 days\n 4 days\n 1 day\n 1 day\n\n\n\n\n\n","category":"method"},{"location":"#DateShifting.sequence_and_intervals-Tuple{Array{TimeZones.ZonedDateTime,1},Dates.Period}","page":"Home","title":"DateShifting.sequence_and_intervals","text":"sequence_and_intervals(input_zoned_datetime_list::Vector{TimeZones.ZonedDateTime},\n                       round_to::Dates.Period)\n\nExamples\n\njulia> using Dates\n\njulia> using DateShifting\n\njulia> using TimeZones\n\njulia> dates = [\n           ZonedDateTime(DateTime(\"2000-01-01T00:00:00\"), tz\"America/New_York\"),\n           ZonedDateTime(DateTime(\"2000-02-01T00:00:00\"), tz\"America/New_York\"),\n           ZonedDateTime(DateTime(\"2000-01-05T00:00:00\"), tz\"America/New_York\"),\n           ZonedDateTime(DateTime(\"2000-01-02T03:05:06\"), tz\"America/Chicago\"),\n           ZonedDateTime(DateTime(\"2000-01-02T01:02:03\"), tz\"America/New_York\"),\n       ]\n5-element Array{ZonedDateTime,1}:\n 2000-01-01T00:00:00-05:00\n 2000-02-01T00:00:00-05:00\n 2000-01-05T00:00:00-05:00\n 2000-01-02T03:05:06-06:00\n 2000-01-02T01:02:03-05:00\n\njulia> round_to = Day(1)\n1 day\n\njulia> sequence, intervals = sequence_and_intervals(dates, round_to)\n([1, 5, 4, 3, 2], Dates.Day[0 days, 31 days, 4 days, 1 day, 1 day])\n\njulia> sequence\n5-element Array{Int64,1}:\n 1\n 5\n 4\n 3\n 2\n\njulia> intervals\n5-element Array{Day,1}:\n 0 days\n 31 days\n 4 days\n 1 day\n 1 day\n\n\n\n\n\n","category":"method"}]
}