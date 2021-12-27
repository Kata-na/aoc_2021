const fs = require('fs')
const [input1, input2] = fs
                .readFileSync('./data/dt_13.txt', 'utf8')
                .trim()
                .replace(/\r/g, "") //windows specific
                .split("\n\n");

/* url https://adventofcode.com/2021/day/13/input
code can be executed in browser's console, just use code line provided below for data extraction/read (not lines above)
const [input1, input2] = document.querySelector("body > pre").innerText.trim().split('\n\n'); */

//dot coordinates
const idx = input1.trim().split('\n').map((x) => {
    return x.split(',').map(Number);
});

const foldInfo = input2.trim().split('\n').map((x) => x
                       .match(/fold along (?<axis>[xy])=(?<position>\d+)/).groups)
                       .map((x) => [x.axis, Number(x.position)]);

const maxX = Math.max(...idx.map((p) => p[0])) + 1;
const maxY = Math.max(...idx.map((p) => p[1])) + 2;
let paper = [...Array(maxY)].map(a => Array(maxX).fill(' '));

//populating sheet of paper with dots
for (ix of idx) {
    paper[ix[1]][ix[0]] = '#';
};

//Folding sheet of paper
for (fold of foldInfo){

    if (fold[0] === 'x'){

        const firstHalf  = paper.map(a => a.slice(0, fold[1]));
		const secondHalf = paper.map(a => a.slice(-fold[1]));
        for (let y in secondHalf) {
            for (let x in secondHalf[y]) {
                let deltaX = fold[1] - parseInt(x) -1 ;
                firstHalf[y][x] = (firstHalf[y][x]!='#')?secondHalf[y][deltaX]:'#';
            };
        };
        paper = firstHalf;

    } else if (fold[0] === 'y') {

        const firstHalf  = paper.slice(0, fold[1]);
		const secondHalf = paper.slice(-fold[1]);
		for (let y in secondHalf) {
			for (let x in secondHalf[y]) {
				let deltaY = fold[1] - parseInt(y) - 1;
				firstHalf[y][x] = (firstHalf[y][x]!='#')?secondHalf[deltaY][x]:'#';
			};
		};
        paper = firstHalf;
    }
    if (fold[0] === foldInfo[0][0] && fold[1] === foldInfo[0][1]) {
        console.log('Answer 1: ', paper.flat().filter(a => a === '#').length);
    };
};

console.log('\nAnswer 2: \n');
console.log(paper.map(a => a.join("")).join('\n'));