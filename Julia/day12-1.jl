mutable struct Ship
    x::Float64
    y::Float64
    direction::Float64
    Ship(x, y, direction) = new(x, y, direction)
end

move!(ship::Ship, dir::AbstractString, n::Integer) = move!(ship, Val(Symbol(dir)), n)
move!(ship::Ship, ::Val{:N}, n::Integer) = ship.y += n
move!(ship::Ship, ::Val{:S}, n::Integer) = ship.y -= n
move!(ship::Ship, ::Val{:E}, n::Integer) = ship.x += n
move!(ship::Ship, ::Val{:W}, n::Integer) = ship.x -= n
move!(ship::Ship, ::Val{:L}, n::Integer) = ship.direction += n
move!(ship::Ship, ::Val{:R}, n::Integer) = ship.direction -= n
function move!(ship::Ship, ::Val{:F}, n::Integer)
    angle = deg2rad(ship.direction)
    ship.x += n * cos(angle)
    ship.y += n * sin(angle)
end

manhattan_distance(ship::Ship) = abs(ship.x) + abs(ship.y)

function follow_instructions!(ship::Ship, instructions::Base.EachLine)
    re = r"(\w)(\d*)"
    for instrution in instructions
        dir, n = match(re, instrution).captures

        move!(ship, dir, parse(Int, n))
    end
end


function main()
    ship = Ship(0, 0, 0)

    instructions = eachline("Recursos/day12-input.txt")

    follow_instructions!(ship, instructions)

    manhattan_distance(ship)
end
main()
