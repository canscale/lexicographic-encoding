
import { pack } from "../reference/lexicographic-integer-encoding";

import { readFileSync } from "fs";

let testInts = [
  0, 
  1,
  250,
  251,
  255,
  256,
  12309857, // random
  99120980123, // random
  17000000000000 // max guaranteed encoding value
];

test("Javascript reference implementation reliably works up to 1.7 * 10^13 (no duplicates)", () => {
  const start = 17000000000000;
  const end = start - 3000;
  let prev: string | null = null;
  for (let i=start; i>end; i-=1) {
    let result = pack(start - i, "hex") as string;
    expect(prev).not.toEqual(result);
    prev = result;
  }
});

// ordering of these tests matters because of the line reader
// i in each of the tests is the line index from the motoko test output file
describe("test output file", () => {
  const lines = readFileSync("output.txt", 'utf-8').split("\n");
  console.log("first 15", lines.slice(0, 15));
  console.log("lines[3]", lines[3]);
  console.log("lines[4]", lines[4]);
  console.log("lines[5]", lines[5]);
  console.log("lines[6]", lines[6]);

  // line index = 0
  test("test zero", async () => {
    let i = 0
    const expectedResult = pack(testInts[i], "hex") as string;
    expect(lines[i]).toEqual(expectedResult)
  })

  // line index = 1
  test("test one", async () => {
    let i = 1;
    const expectedResult = pack(testInts[i], "hex") as string;
    expect(lines[i]).toEqual(expectedResult)
    i += 1;
  })

  // from line index = 2 -> 5
  test("test around 256", async () => {
    let i = 2;
    while (i < 6) {
      const expectedResult = pack(testInts[i], "hex") as string;
      expect(lines[i]).toEqual(expectedResult)
      i += 1;
    }
  })

  // from line index = 6 -> 7
  test("test random", async () => {
    let i = 6;
    while (i < 8) {
      const expectedResult = pack(testInts[i], "hex") as string;
      expect(lines[i]).toEqual(expectedResult)
      i += 1;
    }
  })

  // line index = 8
  test("test max guaranteed encoding value", async () => {
    let i = 8;
    const expectedResult = pack(testInts[i], "hex") as string;
    expect(lines[i]).toEqual(expectedResult)
    i += 1;
  })

  // from line index = 9 -> 3009
  test("test values around max guaranteed match", async () => {
    let i = 9;
    const max = 17000000000000; // max guaranteed encoding value
    let start = max - 3000;

    for (let int=start; int<max+1; int+=1) {
      const expectedResult = pack(int, "hex") as string;
      expect(lines[i]).toEqual(expectedResult)
      i += 1;
    }
  })


  // from line = 3010 -> 43013 
  test("compare results around powers of 256", async () => {
    let i = 3010;
    const rowsPerRange = 10001
    let range = 2;

    let expectedResults: string[] = []
    for (let r=range; r<6; r+=1) {
      const base = Math.pow(256, r);
      for (let j=0; j<rowsPerRange; j+=1) {
        const int = base + j - 5000;
        const expectedResult = pack(int, "hex") as string; 
        expect(lines[i]).toEqual(expectedResult)
        i += 1;
      }
    };
  })
})