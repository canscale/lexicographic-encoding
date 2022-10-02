# lexicographic-encoding 

A library for lexicographically encoding Integers

## Usage

```
import E "mo:encode/EncodeInt";

let x: Int = 256;
let encoded = E.encodeInt(x);
```

## Limitations

Currently this library is only able to reliably encode integers from **0** up to ~**1.7 * 10^13**, while maintaining equivalence with the JavaScript reference implementation in `reference/lexicographic-encoding.ts`

## Motivation

When converting numbers to strings, the same sort order is preserved. Lexicographic encodings of numbers preserve their sort order.

Additionally, this allows one to preserve sort order when associating number ids with strings, such as a user with id=256 becoming "user-fb05"

