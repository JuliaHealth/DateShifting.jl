using DateShifting
using Documenter

makedocs(;
    modules=[DateShifting],
    authors="Dilum Aluthge, contributors",
    repo="https://github.com/JuliaHealth/DateShifting.jl/blob/{commit}{path}#L{line}",
    sitename="DateShifting.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaHealth.github.io/DateShifting.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
    strict = true,
)

deploydocs(;
    repo="github.com/JuliaHealth/DateShifting.jl",
)
