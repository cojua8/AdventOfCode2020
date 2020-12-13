mutable struct Waypoint
    x::Float64
    y::Float64
    Waypoint(x, y) = new(x, y)
end

mutable struct Ship
    x::Float64
    y::Float64
    waypoint::Waypoint
    Ship(x, y, waypoint) = new(x, y, waypoint)
end

move!(ship::Ship, dir::AbstractString, n::Integer) = move!(ship, Val(Symbol(dir)), n)
move!(ship::Ship, ::Val{:N}, n::Integer) = ship.waypoint.y += n
move!(ship::Ship, ::Val{:S}, n::Integer) = ship.waypoint.y -= n
move!(ship::Ship, ::Val{:E}, n::Integer) = ship.waypoint.x += n
move!(ship::Ship, ::Val{:W}, n::Integer) = ship.waypoint.x -= n

move!(ship::Ship, ::Val{:L}, n::Integer) = rotate!(ship, n)
move!(ship::Ship, ::Val{:R}, n::Integer) = rotate!(ship, -n)
function move!(ship::Ship, ::Val{:F}, n::Integer)
    ship.x += ship.waypoint.x * n
    ship.y += ship.waypoint.y * n
end

function rotate!(ship::Ship, θ_deg::Integer)
    θ = deg2rad(θ_deg)
    rotation = [cos(θ) -sin(θ); sin(θ) cos(θ)]

    rotated_coordinates = rotation * [ship.waypoint.x, ship.waypoint.y]

    ship.waypoint.x, ship.waypoint.y = rotated_coordinates
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
    waypoint = Waypoint(10, 1)
    ship = Ship(0, 0, waypoint)

    instructions = eachline("Recursos/day12-input.txt")

    follow_instructions!(ship, instructions)

    @show manhattan_distance(ship)
end
main()
