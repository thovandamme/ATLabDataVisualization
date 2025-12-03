function theme_talk()::Theme
    return merge(theme_latexfonts(), Theme(
        size = (1600, 900),
        fontsize = 32,
        figure_padding = 30,
        palette = (
            color = [:green, :dodgerblue, :seashell4, :firebrick1, :deepskyblue], 
            linestyle = [:dot, :solid],
            linewidth = [3, 5]
        ),
        Axis = (
            leftspinevisible = false,
            rightspinevisible = false,
            bottomspinevisible = false,
            topspinevisible = false,
            xminorticksvisible = false,
            yminorticksvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            xlabelpadding = 15,
            ylabelpadding = 15,
            titlefont = :bold,
        ),
        Legend = (
            framevisible = false,
            # padding = (0, 0, 0, 0),
        ),
        Axis3 = (
            xspinesvisible = false,
            yspinesvisible = false,
            zspinesvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            zticksvisible = false,
        ),
        Colorbar = (
            ticksvisible = false,
            spinewidth = 0,
            ticklabelpad = 5,
        ),
        Lines = (
           cycle = Cycle([:linewidth, :color], covary=true),
           alpha = 0.75
        ),
        # Contour = (
        #     linewidth = 5
        # ),
        Band = (
            alpha = 0.5,
        ),
    ))
end


function theme_article()::Theme
    return merge(theme_latexfonts(), Theme(
        size = (1000, 600),
        fontsize = 20,
        palette = (
            color = [:green, :dodgerblue, :seashell4, :firebrick1], 
            linestyle = [:dot, :solid],
            linewidth = [1, 3]
        ),
        Axis = (
            leftspinevisible = false,
            rightspinevisible = false,
            bottomspinevisible = false,
            topspinevisible = false,
            xminorticksvisible = false,
            yminorticksvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            xlabelpadding = 3,
            ylabelpadding = 3,
            titlefont = :bold
        ),
        Legend = (
            framevisible = false,
            padding = (0, 0, 0, 0),
            linestyle = :solid
        ),
        Axis3 = (
            xspinesvisible = false,
            yspinesvisible = false,
            zspinesvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            zticksvisible = false,
        ),
        Colorbar = (
            ticksvisible = false,
            spinewidth = 0,
            ticklabelpad = 5,
        ),
        Lines = (
            cycle = Cycle([:linewidth, :color], covary=true),
            alpha = 0.85,
        ),
        Band = (
            alpha = 0.5,
        ),
    ))
end