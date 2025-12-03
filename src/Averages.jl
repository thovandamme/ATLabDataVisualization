function visualize(
        avgfile::String, variable::String, ω::Float64, κ::Float64
    )::Tuple{Figure, Axis, Lines}
    GLMakie.activate!()
    set_theme!(theme_talk())
    T = 2*π/ω

    var = ncread(avgfile, variable)
    time = ncread(avgfile, "t")
    z = ncread(avgfile, "z")
    σ = collect(range(start=0, stop=10, length=101)).*T
    gaussvar = imfilter(var, Kernel.gaussian((0, σ[end])))

    # ------------------------------------------------------------------------------

    fig = Figure()
    sg = SliderGrid(
        fig[1, 1],
        (label=L"i_z", range=1:length(z), startvalue=1410, linewidth=15),
        (label="σ", range=1:length(σ), startvalue=1, linewidth=15),
        (label=L"i_t", range=1:(length(time)), startvalue=100, linewidth=15)
    )
    z_slider = sg.sliders[1]
    σ_slider = sg.sliders[2]
    t_slider = sg.sliders[3]
    ax1 = Axis(fig[2,1], xlabel="t", ylabel=variable)
    ax2 = Axis(fig[3,1], xlabel=variable, ylabel="z")

    # ------------------------------------------------------------------------------

    ln1 = Vector{Lines}(undef, 2)
    ln2 = Vector{Lines}(undef, 2)

    ln1[1] = lines!(ax1, time, view(var, length(z)÷2, :), linewidth=2)
    ln1[2] = lines!(ax1, time, view(gaussvar, length(z)÷2, :), linewidth=4)
    ln1_v = vlines!(ax1, time[length(time)÷2], color=:black)

    ln2[1] = lines!(ax2, view(var, :, length(time)÷2), z, linewidth=2)
    ln2[2] = lines!(ax2, view(gaussvar, :, length(time)÷2), z, linewidth=4)
    ln2_h = hlines!(ax2, z[length(z)÷2], color=:black)

    # Initial profile; Interesting for comparing to initial conditions
    lines!(ax2, view(var, :, 1), z, linewidth=2, linestyle=:dot)

    buffer = zeros(eltype(var), size(var))
    lift(σ_slider.value) do j
        s = σ[j] * length(time) / time[end]
        imfilter!(buffer, view(var, :, :), Kernel.gaussian( (0,s) ))
        
        lift(z_slider.value) do i
            ln1[1][2] = view(var, i, :)
            ln1[2][2] = view(buffer, i, :)
            ln2_h[1] = z[i]

            lift(t_slider.value) do it
                ln1_v[1] = time[it]
                ln2[1][1] = view(var, :, it)
                ln2[2][1] = view(buffer, :, it)
                ax1.title = "t = $(time[it]) ; z = $(z[i]) ; σ = $(σ[j])"
            end
        end
    end
    display(fig)
end