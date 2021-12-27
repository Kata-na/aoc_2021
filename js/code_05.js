const fs = require('fs');
const input0 = fs.readFileSync('./data/dt_05.txt', 'utf8')
                 .split('\n').map(a => a.split(" -> ").map(a => a.split(",").map(Number)));

/* url https://adventofcode.com/2021/day/5/input
code can be executed in browser's console, just use code line provided below for data extraction/read (not lines above)
const input0 = document.querySelector("body > pre").innerText.split('\n').map(a => a.split(" -> ").map(a => a.split(",").map(Number)));
*/
const input = input0.slice(0, -1); /* Dropping 'NewLine' from the end*/
const maxVal = input.reduce((final, curr) => Math.max(final, Math.max(Math.max(...curr[0]), Math.max(...curr[1]))), 0);

/*Empty place holder arrays for movement mapping*/
const map1 = Array(maxVal + 1).fill().map(() => Array(maxVal + 1).fill(0));
const map2 = Array(maxVal + 1).fill().map(() => Array(maxVal + 1).fill(0));

for (const [c1, c2] of input){
    /*Looping through coordinates and mapping allowed moves*/
    dx  = Math.sign(c2[0] - c1[0])
    dy  = Math.sign(c2[1] - c1[1])
    len = Math.max(Math.abs(c1[0] - c2[0]), Math.abs(c1[1] - c2[1]))

    for (let i = 0; i <= len; i++) {
        map2[c1[0] + i * dx][c1[1] + i * dy] ++
        
        if (c1[0] == c2[0] || c1[1] == c2[1]) {
            map1[c1[0] + i * dx][c1[1] + i * dy] ++
        }
    }
};
/*Counting coordinates visited more than one time*/
const ans1 = map1.reduce((total, val)  => total += val.filter(x => x > 1).length, 0);
const ans2 = map2.reduce((total, val)  => total += val.filter(x => x > 1).length, 0);
console.log(ans1) ;
console.log(ans2);
