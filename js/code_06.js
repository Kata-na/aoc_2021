const fs = require('fs')
const input = fs.readFileSync('./data/dt_06.txt', 'utf8').split(',').map(Number)

/* console
url https://adventofcode.com/2021/day/6/input
const input = document.querySelector("body > pre").innerText.split(',').map(Number)  
*/

function fish_spawn (input, days) {
    //placeholder for fish count by days till spawn
    let placeholder = Array(9).fill(0); 

    //populating days till spawn placeholder with fish count
    input.map(x => {
        const prior = placeholder[x]
        placeholder.splice(x, 1, prior + 1)// replaces 1 element at index x with proir +1
    })
    for (let i = 1; i <= days; i++) {
        // The shift() method removes the first element from 
        // an array and returns that removed element
        let spawn = placeholder.shift() 
        placeholder.push(spawn) //adding new generation of fishes
        // adding count of fishes which have spawn to 7 days till spawn
        placeholder.splice(6, 1, placeholder[6] + spawn) 
    }
    return placeholder.reduce((i, j) => i + j)
}
  
const ans1 = fish_spawn(input, 80)
const ans2 = fish_spawn(input, 256)
console.log(ans1)
console.log(ans2)