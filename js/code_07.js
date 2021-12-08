const { match } = require('assert')
const fs = require('fs')
const input = fs.readFileSync('./data/dt_07.txt', 'utf8').split(',').map(Number)

/* console
url https://adventofcode.com/2021/day/7/input
const input = document.querySelector("body > pre").innerText.split(',').map(Number)  
*/

const fuel_expenses = (from, to) => {
    const dist = Math.abs(from - to)
    return (dist * (dist + 1) / 2)
}

let min_fuel_expenses1 = Number.MAX_SAFE_INTEGER
let min_fuel_expenses2 = Number.MAX_SAFE_INTEGER

for (let pos1 = 1; pos1 <= Math.max(...input); pos1++){
    let total_fuel_expenses1 = 0
    let total_fuel_expenses2 = 0
    for (let pos2 of input) {
        total_fuel_expenses1 += Math.abs(pos1 - pos2)
        total_fuel_expenses2 += fuel_expenses(pos1, pos2)
    }
    if (total_fuel_expenses1 < min_fuel_expenses1) {
        min_fuel_expenses1 = total_fuel_expenses1;
    }
    
    if (total_fuel_expenses2 < min_fuel_expenses2) {
        min_fuel_expenses2 = total_fuel_expenses2;
    }
}
console.log('PART 1: ' + min_fuel_expenses1)
console.log('PART 2: ' + min_fuel_expenses2)

// MATHEMATICAL SOLUTION
const part1 = (() => {
    const sorted = [...input].sort((a, b) => a - b);
    const median = sorted[Math.floor(sorted.length / 2)]
    return sorted.reduce((sum, n) => sum + Math.abs(n - median), 0);
})()

const part2 = (() => {
    const mean = Math.floor(input.reduce((sum, n) => sum + n) / input.length);
    const potential_mean = [mean - 1, mean, mean + 1];
    const calcDistance = n => (n * (n + 1)) / 2;
    const total_fuel_expenses = potential_mean.map(m => {
      return input.reduce((sum, x) => sum + calcDistance(Math.abs(x - m)), 0)
    })
    return Math.min(...total_fuel_expenses);
})()
console.log(part1);
console.log(part2);