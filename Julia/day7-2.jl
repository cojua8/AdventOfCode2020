struct Bags
    colors_dict::Dict{AbstractString,Dict{AbstractString,Integer}}
end
Bags() = Bags(Dict{String,Dict{AbstractString,Integer}}())

function add_bag_color!(b::Bags, color::AbstractString,
    contained_colors::Dict{String,Integer})
    b.colors_dict[color] = contained_colors
end

function contains_color_count(b::Bags, color::AbstractString)
    has_color_dict = Dict{AbstractString,Bool}()

    count = 0

    for (bag_color, bag_content) in b.colors_dict
        if !haskey(has_color_dict, bag_color)
            has_color_dict[bag_color] = contains_color(bag_content, color, has_color_dict, b)
        end
        count += has_color_dict[bag_color]
    end

    return count
end

function contains_color(bag::Dict{AbstractString,Integer},
    color::AbstractString, has_color_dict::Dict{AbstractString,Bool}, b::Bags)
    if length(bag) == 0 # contains nothing
        return false
    elseif haskey(bag, color) # contains searched color
        return true
    else
        for bag_color in keys(bag)
            if !haskey(has_color_dict, bag_color)
                has_color_dict[bag_color] = contains_color(b.colors_dict[bag_color], color, has_color_dict, b)
            end

            if has_color_dict[bag_color]
                return true
            end
        end
        return false
    end
end

function total_contained(bags::Bags, color::AbstractString)
    total_contained_dict = Dict{AbstractString,Integer}()

    total_contained_dict[color] = contained(bags.colors_dict[color], total_contained_dict, bags)

    return total_contained_dict[color] - 1
end

function contained(bag::Dict{AbstractString,Integer},
    total_contained_dict::Dict{AbstractString,Integer}, bags::Bags)
    if length(bag) == 0
        return 1
    else
        count = 1 # the bag itself
        for bag_color in keys(bag)
            if !haskey(total_contained_dict, bag_color)
                total_contained_dict[bag_color] = contained(bags.colors_dict[bag_color], total_contained_dict, bags)
            end

            count += bag[bag_color] * total_contained_dict[bag_color]
        end
        return count
    end
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

    return total_contained(bags, "shiny gold")
end

@btime main()
