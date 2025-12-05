function visualize(data::ScalarData; slice::Int=1)
    fig, ax, hm = heatmap(data, slice=slice)
    display(fig)
end


function heatmap(
        data::ScalarData;
        slice::Int = 1, 
        sizex::Int = 1000,
        colormap=:RdGy,
        colorrange_max = maximum(data.field),
        colorrange_min = minimum(data.field),
        colorrange=(minimum(data.field),maximum(data.field)),
        colorscale = identity,
        colorbarticks = [
            round(colorrange_min, digits=2), 
            round((colorrange_max+colorrange_min)/2, digits=2), 
            round(colorrange_max, digits=2)
        ],
        label=" ",
        xlabel = "x",
        ylabel = "z",
        xtickstep = 10, #round(data.grid.scalex/8),
        ytickstep = 10, #round(data.grid.scaley/4),
        title::String = data.name*"  ;  t = "*string(data.time)
    )::Tuple{Figure, Axis, Heatmap}
    println("Visualizing ...")
    printstyled("   $(data.name) \n", color=:cyan)
    sizez = round(Int32, data.grid.scalez/data.grid.scalex*sizex)    
    printstyled("   Backend: GLMakie \n", color=:light_black)
    
    fig = Figure(size=(sizex, sizez))
    ax = Axis(
        fig[1,1], 
        xlabel=xlabel, ylabel=ylabel,
        xticks=data.grid.x[1]:xtickstep:data.grid.x[end],
        yticks=round(data.grid.z[1]):ytickstep:round(data.grid.z[end]),
        title=title
    )
    resize_to_layout!(fig)
    hm = heatmap!(
        ax,
        view(data.grid.x, :), 
        view(data.grid.z, :),
        view(data.field, :, slice, :),
        colormap=colormap,
        colorrange=colorrange,
        colorscale=colorscale
    )
    Colorbar(
        fig[1,2], 
        hm,
        label=label,
        ticks=colorbarticks
    )
    return fig, ax, hm
end


function animate(
        dir::String, 
        field::String;
        fps::Int=2,
        loader::Function=load,
        visualizer::Function=visualize,
        live::Bool=true,
        outfile::String=joinpath(dir, "video/$(field).mp4"),
        slice::Int=1
    )
    println("Animating:")
    printstyled("   $(dir)", color=:cyan)
    filenames = filter(x -> startswith(x, field), readdir(dir, join=false))
    file = joinpath(dir, filenames[1])
    data = loader(file)
    fig, ax, hm = visualizer(data)
    if live
        # Live in GLWindow using GLMakie
        display(fig)
        for i ∈ eachindex(filenames)
            file = joinpath(dir, filenames[i])
            data = loader(file)
            hm[3] = view(data.field, :, slice, :)
            ax.title = "$(field) ; t = $(data.time)"
            sleep(1/fps)
        end
    else
        # Save as .mp4 file with CairoMakie
        if ! ispath(dirname(outfile))
            mkpath(dirname(outfile))
        end
        record(fig, outfile, 1:length(filenames), framerate=fps) do i
            file = joinpath(dir, filenames[i])
            data = loader(file)
            hm[3] = view(data.field, :, slice, :)
            ax.title = "$(field) ; t = $(data.time)"
        end
    end
end