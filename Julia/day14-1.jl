function initialization_program(file_path::AbstractString)
    memory = Dict{AbstractString,Integer}()
    mask = String[]

    re = r"(mask|mem\[(\d*)\]) = (\w*)"
    for line in eachline(file_path)
        matches = match(re, line)

        if matches.captures[1] == "mask"
            mask = split(matches.captures[3], "")
        else
            binary_string = bitstring(parse(Int, matches.captures[3]))
            binary_list = split(binary_string[end - 35:end], "")

            masked_binary = map((m, v) -> m == "X" ? v : m, mask, binary_list)
            masked_binary = join(masked_binary)

            memory[matches.captures[2]] = parse(Int, masked_binary, base=2)
        end
    end

    return memory
end


function main()
    memory = initialization_program("Recursos/day14-input.txt")

    return sum(values(memory))
end

main()
