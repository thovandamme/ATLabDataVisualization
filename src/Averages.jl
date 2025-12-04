function visualize(data::AveragesData, T::Float64=2π)
    GLMakie.activate!()
    set_theme!(theme_talk())

    σ = collect(range(start=0, stop=10, length=101)).*T
    gaussvar = imfilter(data.field, Kernel.gaussian((0, σ[end])))

    # ------------------------------------------------------------------------------

    fig = Figure()
    sg = SliderGrid(
        fig[1, 1],
        (label=L"i_z", range=1:length(data.grid.z), startvalue=1410, linewidth=15),
        (label="σ", range=1:length(σ), startvalue=1, linewidth=15),
        (label=L"i_t", range=1:(length(data.time)), startvalue=100, linewidth=15)
    )
    z_slider = sg.sliders[1]
    σ_slider = sg.sliders[2]
    t_slider = sg.sliders[3]
    ax1 = Axis(fig[2,1], xlabel="t", ylabel=data.name)
    ax2 = Axis(fig[3,1], xlabel=data.name, ylabel="z")

    # ------------------------------------------------------------------------------

    ln1 = Vector{Lines}(undef, 2)
    ln2 = Vector{Lines}(undef, 2)

    ln1[1] = lines!(ax1, data.time, view(data.field, length(data.grid.z)÷2, :), linewidth=2)
    ln1[2] = lines!(ax1, data.time, view(gaussvar, length(data.grid.z)÷2, :), linewidth=4)
    ln1_v = vlines!(ax1, data.time[length(data.time)÷2], color=:black)

    ln2[1] = lines!(ax2, view(data.field, :, length(data.time)÷2), data.grid.z, linewidth=2)
    ln2[2] = lines!(ax2, view(gaussvar, :, length(data.time)÷2), data.grid.z, linewidth=4)
    ln2_h = hlines!(ax2, data.grid.z[length(data.grid.z)÷2], color=:black)

    # Initial profile; Interesting for comparing to initial conditions
    lines!(ax2, view(data.field, :, 1), data.grid.z, linewidth=2, linestyle=:dot)

    buffer = zeros(eltype(data.field), size(data.field))
    lift(σ_slider.value) do j
        s = σ[j] * length(data.time) / data.time[end]
        imfilter!(buffer, view(data.field, :, :), Kernel.gaussian( (0,s) ))
        
        lift(z_slider.value) do i
            ln1[1][2] = view(data.field, i, :)
            ln1[2][2] = view(buffer, i, :)
            ln2_h[1] = data.grid.z[i]

            lift(t_slider.value) do it
                ln1_v[1] = data.time[it]
                ln2[1][1] = view(data.field, :, it)
                ln2[2][1] = view(buffer, :, it)
                ax1.title = "t = $(data.time[it]) ; z = $(data.grid.z[i]) ; σ = $(σ[j])"
            end
        end
    end
    display(fig)
end