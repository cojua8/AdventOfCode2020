function initialization_program(file_path::AbstractString)
    memory = Dict{AbstractString,Integer}()
    mask = String[]

    re = r"(mask|mem\[(\d*)\]) = (\w*)"
    for line in eachline(file_path)
        matches = match(re, line)

        if matches.captures[1] == "mask"
            mask = split(matches.captures[3], "")
        else
            memory_string = bitstring(parse(Int, matches.captures[2]))
            memory_list = split(memory_string[end - 35:end], "")

            masked_binary = map((m, v) -> m == "X" ? m : m == "1" ? m : v,
                mask, memory_list)
        end
    end

    return memory
end


function main()
    memory = initialization_program("Recursos/day14-input.txt")

    return sum(values(memory))
end

main()
