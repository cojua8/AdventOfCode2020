using DelimitedFiles

expenses = readdlm("Recursos/day1-input.txt", Int)

for i = 1:length(expenses)
    for j = i:length(expenses)
        for l = j:length(expenses)
            v1 = expenses[i]
            v2 = expenses[j]
            v3 = expenses[l]
            if v1 + v2 + v3 == 2020
                println("$v1 + $v2 + $v3 == $(v1 + v2 + v3)")
                println("$v1 * $v2 * $v3 == $(v1 * v2 * v3)")
                break
            end
        end
    end
end
