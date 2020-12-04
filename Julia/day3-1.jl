struct Slope
    right::Integer
    down::Integer
end

istree(line, position) = line[mod1(position, length(line))] == '#'

slope = Slope(3, 1)
current_position = 1
tree_count = 0
open("Recursos/day3-input.txt") do io
    length(readline(io))
    for line in eachline(io)
        global current_position += slope.right
        global tree_count += istree(line, current_position)
    end
end
print(tree_count)
