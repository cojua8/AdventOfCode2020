using Base: @kwdef

abstract type Operation end

@kwdef mutable struct Accumulate <: Operation
    value::Integer
    offset::Integer
    used::Bool = false
end

@kwdef mutable struct Jump <: Operation
    value::Integer
    offset::Integer
    used::Bool = false
end

@kwdef mutable struct NoOperation <: Operation
    value::Integer
    offset::Integer
    used::Bool = false
end

function do_operation(op::Operation)
    op.used = true
    return (op.value, op.offset)
end

isused(op::Operation) = op.used

process_operation(::Val{:acc}, value::Integer) = Accumulate(value=value, offset=1)
process_operation(::Val{:jmp}, offset::Integer) = Jump(value=0, offset=offset)
process_operation(::Val{:nop}, ::Integer) = NoOperation(value=0, offset=1)
function process_operation(instruction::AbstractString, argument::Integer)
    return process_operation(Val(Symbol(instruction)), argument)
end

function process_line(line::AbstractString)
    re = r"^(\w*) (\W\d*)$"

    instruction, value = match(re, line).captures

    return process_operation(instruction, parse(Int, value))
end

function boot(instructions::AbstractVector{Operation})
    accumulator = 0
    index = 1
    while !isused(instructions[index])
        value, offset = do_operation(instructions[index])

        accumulator += value
        index += offset
    end

    return accumulator, index
end

function main()
    instructions = process_line.(readlines("Recursos/day8-input.txt"))

    boot(instructions)
end

main()
