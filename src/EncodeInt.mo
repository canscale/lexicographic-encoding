/// Lexicographical encoding of integers

import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Float "mo:base/Float";
import Int "mo:base/Int";
import List "mo:base/List";
import Nat8 "mo:base/Nat8";
import Hex "mo:hex/Hex";


module {

  /// Lexicographically encodes integers
  /// Note: Currently this library is only able to reliably encode integers from 0 up to ~1.7 * 10^13
  public func encodeInt(n: Int): Text {
    Hex.encode(pack(n), #lower);
  };

  func byte(int: Int): Nat8 { Nat8.fromIntWrap(int) };

  func pack(n: Int): [Nat8] {
    if (n < 0) {
      /* TODO: need Motoko equivalent of JavaScript's unsigned right bit shift
       * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Unsigned_right_shift
       */
      Debug.trap("lexicographically encoding negative integers not yet supported");
      return []
    };

    // TODO: encode integers larger than 1.7 * 10^13 without duplication
    if (n > 17000000000000) {
      Debug.trap("currently cannot encode integers larger than 17 trillion");
      return []
    };

    let x = n - 251;

    let res: [Nat8] = do {
      // 1 byte
      if (n < 251) {
        [ byte(n) ]

      // 1 byte (251 <= x < 256)
      } else if (x < 256) {
        [ 
          251,
          byte(x)
        ];

      // 2 bytes
      } else if (x < 256 * 256) {
        [ 
          252, 
          byte(Int.div(x, 256)),
          byte(Int.rem(x, 256))
        ]

      // 3 bytes
      } else if (x < 256 * 256 * 256) {
        [
          253,
          byte(Int.div(x, 256 * 256)),
          byte(Int.rem(Int.div(x, 256), 256)),
          byte(Int.rem(x, 256))
        ]

      // 4 bytes
      } else if (x < 256 * 256 * 256 * 256) {
        [
          254,
          byte(Int.div(x, 256 * 256 * 256)),
          byte(Int.rem(Int.div(x, 256 * 256), 256)),
          byte(Int.rem(Int.div(x, 256), 256)),
          byte(Int.rem(x, 256))
        ]
  
      // 4.2 billion - 17 trillion (if statement above), then...BigInt?
      } else {
        let exp = Float.toInt(Float.floor(
          Float.div(
            Float.log(Float.fromInt(x)),
            Float.log(2.0),
          )
        )) - 32;
        var bytes = Array.flatten<Nat8>([[255], pack(exp)]);
        let power = exp - 11;
        // TODO: find out what this arg represents and rename this variable
        let bytesOfArg = do {
          if (power >= 0) { x / Int.pow(2, power) } 
          else { 
            let absPower = Int.abs(power);
            let powerResult =  Float.pow(0.5, Float.fromInt(absPower));

            Float.toInt(Float.fromInt(x) / Float.pow(0.5, Float.fromInt(absPower)))
          }
        };
        bytes := Array.flatten<Nat8>([bytes, bytesOf(bytesOfArg)]);

        bytes
      }
    };

    res;
  };

  func bytesOf(n: Int): [Nat8] {
    var i = 0;
    var d = 1;
    var bytes = List.nil<Nat8>();
    while (i < 6) {
      let res = Int.div(n, d);
      bytes := List.push<Nat8>(
        byte(Int.rem(Int.div(n, d), 256)),
        bytes
      );

      i += 1;
      d *= 256;
    };

    List.toArray<Nat8>(bytes);
  };

}