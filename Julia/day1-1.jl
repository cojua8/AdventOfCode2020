using DelimitedFiles

expenses = readdlm("Recursos/day1-input.txt", Int)

for i = 1:length(expenses)
    for j = i:length(expenses)
        if expenses[i] + expenses[j] == 2020
            println("$(expenses[i]) + $(expenses[j]) == $(expenses[i] + expenses[j])")
            println("$(expenses[i]) * $(expenses[j]) == $(expenses[i] * expenses[j])")
            break
        end
    end
end
