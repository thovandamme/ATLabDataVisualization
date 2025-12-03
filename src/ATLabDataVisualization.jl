module ATLabDataVisualization

using GLMakie
using ATLabData
using NetCDF
using ImageFiltering
using ForwardDiff
using Interpolations

export visualize, animate
export theme_article, theme_talk

include("THEMES.jl")

include("Grid.jl")

include("Averages.jl")

include("2D.jl")

include("3D.jl")

end
