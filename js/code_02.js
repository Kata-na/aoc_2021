const fs = require('fs');
const text = fs.readFileSync('./data/dt_02.txt').toString('utf-8');
const data = text.split('\n').map(comm => comm.split(' ')).map(comm => [comm[0], +comm[1]]);

/* url https://adventofcode.com/2021/day/2/input
code can be executed in browser's console, just use code line provided below for data extraction/read (not lines above)
const data = document.querySelector("body > pre").innerText.split('\n').map(comm => comm.split(' ')).map(comm => [comm[0], +comm[1]]);
*/

/*PART 1*/
const position = {horiz: 0, depth: 0};
for (const [comm, val] of data){
    if (!isNaN(val)) {
        if (comm === 'forward'){
            position.horiz += val
        } else if (comm == 'up'){
            position.depth -= val
        } else {
            position.depth += val
        }
    }
};
const ans1 = position.horiz * position.depth;
console.log(`PART 1: ${ans1}`);

/*PART 2*/
const positionSub = {horiz: 0, depth: 0, aim: 0};
for (const [comm, val] of data){
    if (comm === 'forward'){
        positionSub.horiz += val
        positionSub.depth += positionSub.aim * val
    } else if (comm == 'up'){
        positionSub.aim -= val
    } else {
        positionSub.aim += val
    }
};
const ans2 = positionSub.horiz * positionSub.depth
console.log(`PART 2: ${ans2}`);