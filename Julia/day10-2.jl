function adapter_chain_differences(adapters)
    differences = [0,0,0]

    last_adapter = 0

    for adapter in adapters
        differences[adapter - last_adapter] += 1

        last_adapter = adapter
    end

    return differences
end

# every group of 1s gives n(n-1/2)+1  combinations
function arrangement_ways(adapters)
    total_ways = 1

    last_adapter = 0

    ones_count = 0
    for adapter in adapters
        ones_count += (adapter - last_adapter) == 1

        if (adapter - last_adapter) == 3
            total_ways *= ones_count * (ones_count - 1) ÷ 2 + 1
            ones_count = 0
        end
        last_adapter = adapter
    end

    return total_ways
end



function main()
    adapters = parse.(Int, readlines("Recursos/day10-input.txt"))

    sort!(adapters)

    push!(adapters, adapters[end] + 3)

    arrangement_ways(adapters)
end

@btime main()
