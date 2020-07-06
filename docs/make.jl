using RemoveDateInformation
using Documenter

makedocs(;
    modules=[RemoveDateInformation],
    authors="Dilum Aluthge, contributors",
    repo="https://github.com/JuliaHealth/RemoveDateInformation.jl/blob/{commit}{path}#L{line}",
    sitename="RemoveDateInformation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaHealth.github.io/RemoveDateInformation.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
    strict = true,
)

deploydocs(;
    repo="github.com/JuliaHealth/RemoveDateInformation.jl",
)
