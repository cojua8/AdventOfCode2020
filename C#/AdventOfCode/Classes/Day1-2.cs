using System;
using System.IO;
using System.Linq;

namespace AdventOfCode.Classes
{
    internal class Day1_2
    {
        private string filePath = "../../../../../Recursos/day1-input.txt";

        public void Solve()
        {
            var expenses = ReadFile();

            for (int i = 0; i < expenses.Length; i++)
            {
                for (int j = i; j < expenses.Length; j++)
                {
                    for (int l = j; l < expenses.Length; l++)
                    {
                        var v1 = expenses[i];
                        var v2 = expenses[j];
                        var v3 = expenses[l];
                        if (v1 + v2 +v3== 2020)
                        {
                            Console.WriteLine($"{v1} + {v2} + {v3} = {v1 + v2 + v3}");
                            Console.WriteLine($"{v1} * {v2} * {v3} = {v1 * v2 * v3}");
                            break;
                        }
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