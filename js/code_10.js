const fs = require("fs");
const input = fs.readFileSync('./data/dt_10.txt', {encoding: 'utf-8'})
                .trim()
                .replace(/\r/g, "")
                .split('\n')

/* url https://adventofcode.com/2021/day/10/input
code can be executed in browser's console, just use code line provided below for data extraction/read (not lines above)
const input = document.querySelector("body > pre").innerText.trim().split('\n'); */

function remove_complete_pairs(x) {
    const points = {
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137,
    };
    let y = x.replace(/\(\)|\[\]|\{\}|<>/, '');
    //Checks
    if (x != y) {
        // If pair was removewed recurse further
        return remove_complete_pairs(y);
    } else if (y.match(/\)|\]|\}|>/) == null) {
        // If there are no more pairs and closing brackets =>
        // we have an incomplete string
        return y
    } else {
        // If there are no more pairs, however closing brackets are still present =>
        // corrupted line => return points for corrupted element 
        y = y.match(/(?:^.*?)(\}|\)|\]|>).*?$/)[1];
        return points[[y]];
    };
};

// aux f-tion for part2 => incomplete line score
function string_completion_score(line) {
    const points = {
        "(": 1,
        "[": 2,
        "{": 3,
        "<": 4,
    };
    p = 0;
    for (let i = 0; i < line.length; i++) {
        p += (5 ** i) * points[[line[i]]] 
    };
    return p
};

// F-tion to find median value in array of numbers
function median(values){
    if(values.length === 0) throw new Error("No inputs");

    values.sort((a, b) => a - b);

    let half = Math.floor(values.length / 2);
    if (values.length % 2) {
        return values[half];
    } else {
        return (values[half - 1] + values[half]) / 2.0;
    };
 };

// PART 1
let arr = []
for (let line of input) {
    arr.push(remove_complete_pairs(line))
};
console.log('Answer 1: ', arr.filter(a => !isNaN(a)).reduce((a, b) => a + b, 0));

// PART 2
let score = []
let arr2 = arr.filter(a => isNaN(a))

for (x of arr2) {
    score.push(string_completion_score(x));
};
console.log('Answer 2: ', median(score));
