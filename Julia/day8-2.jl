using Base: @kwdef

abstract type Operation end

@kwdef mutable struct Accumulate <: Operation
    value::Integer
    used::Bool = false
end

@kwdef mutable struct Jump <: Operation
    value::Integer
    used::Bool = false
end

@kwdef mutable struct NoOperation <: Operation
    value::Integer
    used::Bool = false
end

swap(jump::Jump) = NoOperation(value=jump.value)
swap(nooperation::NoOperation) = Jump(value=nooperation.value)

use!(operation::Operation) = operation.used = true
isused(operation::Operation) = operation.used

function do_operation(jump::Jump)
    use!(jump)
    return (0, jump.value)
end

function do_operation(accumulate::Accumulate)
    use!(accumulate)
    return (accumulate.value, 1)
end

function do_operation(nooperation::NoOperation)
    use!(nooperation)
    return (0, 1)
end

process_operation(::Val{:acc}, argument::Integer) = Accumulate(value=argument)
process_operation(::Val{:jmp}, argument::Integer) = Jump(value=argument)
process_operation(::Val{:nop}, argument::Integer) = NoOperation(value=argument)

function process_operation(instruction::AbstractString, argument::Integer)
    return process_operation(Val(Symbol(instruction)), argument)
end

function process_line(line::AbstractString)
    re = r"^(\w*) (\W\d*)$"

    instruction, value = match(re, line).captures

    return process_operation(instruction, parse(Int, value))
end

function boot_fix(instructions::AbstractVector{Operation}, noporjmp::Integer)
    accumulator = 0
    index = 1
    noporjmp_count = 0

    while 0 < index ≤ length(instructions) && !isused(instructions[index])
        if (
            noporjmp_count ≤ noporjmp &&
            (instructions[index] isa NoOperation || instructions[index] isa Jump)
        )
            noporjmp_count += 1

            if noporjmp_count == noporjmp
                instructions[index] = swap(instructions[index])
            end
        end
        value, offset = do_operation(instructions[index])

        accumulator += value
        index += offset
    end

    return accumulator, index
end

function main()
    instructions = process_line.(readlines("Recursos/day8-input.txt"))

    noporjmp_total = count(o -> o isa NoOperation || o isa Jump, instructions)

    for i = 1:noporjmp_total
        sum, finalindex =  boot_fix(deepcopy(instructions), i)

        if finalindex == length(instructions) + 1
            return sum, finalindex
        end
    end
    return 0, 0
end

main()
