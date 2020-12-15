function memory_game(starter_numbers::Vector{<:Integer}, final_turn::Integer)
    memory = Dict(0 => (0, 0))
    push!(memory, Dict(number => (i, 0)
        for (i, number) in enumerate(starter_numbers))...)

    last_spoken = starter_numbers[end]

    for i = (length(starter_numbers) + 1):final_turn
        if memory[last_spoken][2] == 0
            last_spoken = 0
            memory[0] = (i, memory[0][1])
        else
            last_spoken = memory[last_spoken][1] - memory[last_spoken][2]
            if haskey(memory, last_spoken)
                memory[last_spoken] = (i, memory[last_spoken][1])
            else
                memory[last_spoken] = (i, 0)
            end
        end
    end
    return last_spoken
end


function main()
    starter_string = read("Recursos/day15-input.txt", String)

    starter_numbers = parse.(Int, split(starter_string, ","))

    memory_game(starter_numbers, 30000000)
end

main()
