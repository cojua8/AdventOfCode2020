struct Bags
    colors_dict::Dict{String,Dict{String,Integer}}
end
Bags() = Bags(Dict{String,Dict{String,Integer}}())

function add_bag_color!(b::Bags, color::AbstractString,
    contained_colors::Dict{String,Integer})
    b.colors_dict[color] = contained_colors
end

function contains_color_count(color::AbstractString, b::Bags)
    count = 0

    for (k, v) in b.colors_dict
        count += bag_contains_color(color, v, b)
    end

    return count
end

# naive solution: recursively look for color
function bag_contains_color(color::AbstractString, bag::Dict{String,Integer},
    bags::Bags)
    return any
end


function process_line(line::AbstractString)
    container_re = r"^(\D*) bags contain (.*|no other bags).$"
    container_bag, contained_bags = match(container_re, line).captures

    contained_bags_dict = Dict{String,Integer}()
    if contained_bags != "no other bags"
        contained_re = r"(\d*) (\D*) (?:bags|bag)"

        contained_bags_list = eachmatch(contained_re, contained_bags)

        map(x -> contained_bags_dict[x[2]] = parse(Int, x[1]),
            [bag.captures for bag in contained_bags_list])
    end

    return container_bag, contained_bags_dict
end

function main()
    bags = open("Recursos/day7-input.txt") do io
        bags = Bags()
        for line in eachline(io)
            container, contained = process_line(line)

            add_bag_color!(bags, container, contained)
        end
        return bags
    end
end

main()
