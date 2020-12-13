function available_buses(buses::AbstractString)
    re = r"(\d+)"
    return [parse(Int, match.captures[1]) for match in eachmatch(re, buses)]
end

function main()
    earliest, buses = readlines("Recursos/day13-input.txt")

    earliest = parse(Int, earliest)

    buses = available_buses(buses)

    wait, i = findmin(buses .- earliest .% buses)

    return buses[i] * wait
end

main()
