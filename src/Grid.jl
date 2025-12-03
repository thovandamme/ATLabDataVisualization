"""
    visualize(grid)
Displays spacing and stretching of _grid_ as scatter plots over the vertical 
axis.
"""
function visualize(grid::Grid)
    s = collect(1:grid.nz)
    fig = Figure()

    # Plot the spacing as multiple of Δx
    ax = Axis(fig[1,1], xlabel="z", ylabel="Δz/Δx")
    itp = linear_interpolation(s, grid.z, extrapolation_bc = Line())
    spacing = ForwardDiff.derivative.(Ref(itp), s)
    scatter!(ax, grid.z, spacing ./ (grid.scalex/grid.nx))

    # PLot the stretching
    ax2 = Axis(fig[2,1], xlabel="z", ylabel="stretching in %")
    itp = linear_interpolation(s, spacing, extrapolation_bc = Line())
    stretching = ForwardDiff.derivative.(Ref(itp), s) ./ spacing .* 100
    scatter!(ax2, grid.z, stretching)

    println("Vertical stepsize:")
    println(grid.z[end - round(Int, grid.nz/2)-10] - grid.z[end - round(Int, grid.nz/2) - 11])
    println("Horiz. stepsize:")
    println(grid.x[end]/grid.nx)
    println("Maximum stretching in %:")
    println(maximum(stretching))

    display(fig)
end