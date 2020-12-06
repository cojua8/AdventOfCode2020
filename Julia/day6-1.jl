function read_group_answers(lines)
    group_answers = ""

    for line in lines
        if isempty(strip(line))
            break
        end
        group_answers *= line * " "
    end

   return group_answers
end

function process_group_answers(answers::AbstractString)
    spaces_removed = replace(answers, " " => "")

    unique_answers = length(unique(split(spaces_removed, "")))

    return unique_answers
end

open("Recursos/day6-input.txt") do io
    sum_yes = 0
    lines = eachline(io)

    while !eof(io)
        group_answers = read_group_answers(lines)

        sum_yes += process_group_answers(group_answers)
    end
    return sum_yes
end
