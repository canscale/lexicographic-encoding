import { unlinkSync } from "fs";

try {
  unlinkSync('output.txt');
  console.log("successfully deleted the output test file");
} catch (err) {
  console.error("error deleted the reference output file", err)
}