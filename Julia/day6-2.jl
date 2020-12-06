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
    n_people = length(split(answers))

    answer_count_dict = Dict(c => 0 for c in 'a':'z')

    foreach(c -> answer_count_dict[c] += 1, replace(answers, " " => ""))

    return count(c -> c == n_people, values(answer_count_dict))
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
