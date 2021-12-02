const fs = require('fs');
const text = fs.readFileSync('./data/dt_01.txt').toString('utf-8');
const data = text.split('\n');

/* url https://adventofcode.com/2021/day/1/input
code can be executed in browser's consolebjust use code line provided below for data extraction/read not lines above
const data = document.querySelector("body > pre").innerText.split('\n')
*/

/*PART 1*/
function check_num_change (dt, d) {
    return dt.filter((_, i, arr) => arr[i] - arr[i-d] > 0).length
};
const ans1 = check_num_change(data, 1);
console.log(`PART 1: ${ans1}`);

/*PART 2*/
const ans2 = check_num_change (data, 3)
console.log('PART 2: ' + ans2);

/*PART 2 - longer/dumber way*/
/*const n = data.length;
const window_sum = data.slice(0, n - 2).map(function (x, i){
    return parseInt(x, 10) + parseInt(data.slice(1, n - 1)[i], 10) +
    parseInt(data.slice(2, n)[i], 10)
});
const ans2 = check_num_change(window_sum, 1);
console.log('PART 2: ' + ans2);
*/