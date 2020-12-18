function process_file(file::AbstractString)
    io = eachline(file)

    # rules
    ticket_rules_list = String[]

    while !eof(io.stream)
        line = iterate(io)[1]
        if line == ""
            break
        end
        push!(ticket_rules_list, line)
    end

    # own ticket
    own_ticket = ""
    while true
        if iterate(io)[1] == "your ticket:"
            own_ticket = parse.(Int, split(iterate(io)[1], ','))
            break
        end
    end

    # nearby tickets
    while iterate(io)[1] != "nearby tickets:"
    end

    nearby_tickets = [parse.(Int, split(line, ',')) for line in io]

    return ticket_rules_list, own_ticket, nearby_tickets
end

function ticket_rules(rule_list::AbstractVector{T}) where T <: AbstractString
    rules = Dict{T,Function}()

    re = r"(.+): (\d+-\d+) or (\d+-\d+)"
    for rule in rule_list
        name, range1, range2 = match(re, rule).captures
        range1 = eval(Meta.parse(replace(range1, "-" => ":")))
        range2 = eval(Meta.parse(replace(range2, "-" => ":")))

        rules[name] = (n::Integer) -> n in range1 || n in range2
    end

    rules
end

function check_valid_tickets(rules::Dict{<:AbstractString,Function},
    tickets::Vector{<:Vector{<:Integer}})

    invalid_numbers = 0
    for ticket in tickets
        for number in ticket
            if !any(f -> f(number), values(rules))
                invalid_numbers += number
            end
        end
    end
    return invalid_numbers
end

function main()
    ticket_rules_list, own_ticket, nearby_tickets = process_file("Recursos/day16-input.txt")

    rules = ticket_rules(ticket_rules_list)

    check_valid_tickets(rules, nearby_tickets)
end
main()
