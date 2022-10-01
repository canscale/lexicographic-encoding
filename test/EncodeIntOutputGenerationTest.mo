import Float "mo:base/Float";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import E "../src/EncodeInt";
import Debug "mo:base/Debug";

// Meant for generating output to be caputured by stdout and read into an output file
// (and then compared against the `test-encodeint-output-against-reference.ts file)
//
// To run the full test run `npm run test`
//
// To generate the test output file run `npm run generate-motoko-test-output`


// Used to compare results around some specific and some random testInts
let testInts = [
  0,  // test 0 and 1
  1,
  250, // test around 256
  251,
  255,
  256,
  12309857, // random
  99120980123, // random
  17000000000000 // max guaranteed encoding value
];

for (int in testInts.vals()) {
  Debug.print(E.encodeInt(int));
};

let max = 17000000000000; // max guaranteed encoding value
for (i in Iter.range(Int.abs(max - 3000), max)) {
  Debug.print(E.encodeInt(i));
};

// Used to compare results around powers of 256
for (i in Iter.range(Int.abs(Int.pow(256, 2) - 5000), Int.pow(256, 2) + 5000)) { //10_000_000)) {
  Debug.print(E.encodeInt(i));
};

for (i in Iter.range(Int.abs(Int.pow(256, 3) - 5000), Int.pow(256, 3) + 5000)) { //10_000_000)) {
  Debug.print(E.encodeInt(i));
};

for (i in Iter.range(Int.abs(Int.pow(256, 4) - 5000), Int.pow(256, 4) + 5000)) { //10_000_000)) {
  Debug.print(E.encodeInt(i));
};

for (i in Iter.range(Int.abs(Int.pow(256, 5) - 5000), Int.pow(256, 5) + 5000)) { //10_000_000)) {
  Debug.print(E.encodeInt(i));
};