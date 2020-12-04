using System;
using System.IO;
using System.Linq;

namespace AdventOfCode.Classes
{
    internal class Day1_1
    {
        private string filePath = "../../../../../Recursos/day1-input.txt";

        public void Solve()
        {
            var expenses = ReadFile();

            for (int i = 0; i < expenses.Length; i++)
            {
                for (int j = i; j < expenses.Length; j++)
                {
                    if (expenses[i] + expenses[j] == 2020)
                    {
                        Console.WriteLine($"{expenses[i]} + {expenses[j]} = {expenses[i] + expenses[j]}");
                        Console.WriteLine($"{expenses[i]} * {expenses[j]} = {expenses[i] * expenses[j]}");
                    }
                }
            }
        }

        private int[] ReadFile()
        {
            return File.ReadAllLines(filePath).Select(int.Parse).ToArray();
        }
    }
}