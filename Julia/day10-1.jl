function adapter_chain_differences(adapters)
    differences = [0,0,0]

    last_adapter = 0

    for adapter in adapters
        differences[adapter - last_adapter] += 1

        last_adapter = adapter
    end

    return differences
end



function main()
    adapters = parse.(Int, readlines("Recursos/day10-input.txt"))

    sort!(adapters)

    push!(adapters, adapters[end] + 3)

    differences = adapter_chain_differences(adapters)

    return differences[3] * differences[1]
end

main()
