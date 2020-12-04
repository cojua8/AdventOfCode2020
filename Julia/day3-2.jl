struct Slope
    right::Integer
    down::Integer
end

mutable struct RouteOption
    slope::Slope
    tree_count::Integer
    position::Integer
end

move_right!(ro::RouteOption) = ro.position += ro.slope.right

istree(line, position) = line[mod1(position, length(line))] == '#'

slopes = [Slope(1, 1),Slope(3, 1),Slope(5, 1),Slope(7, 1),Slope(1, 2)]
route_options = [RouteOption(slope, 0, 1) for slope in slopes]

open("Recursos/day3-input.txt") do io
    readline(io) # drop first line

    for (line_number, line) in enumerate(eachline(io))
        for (option_number, option) in enumerate(route_options)
            if (line_number % option.slope.down == 0)
                move_right!(option)

                option.tree_count += istree(line, option.position)
            end
        end
    end
end

println(reduce(*, [r.tree_count for r in route_options]))
