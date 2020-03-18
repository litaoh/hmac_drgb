dart implementation of [HMAC DRBG](http://csrc.nist.gov/groups/ST/toolkit/documents/rng/HashBlockCipherDRBG.pdf)

## Usage

```dart
import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:hmac_drgb/hmac_drgb.dart';

void main() {
  var drbg = HmacDRBG(
    hash: SHA256(),
    entropy: Uint8List.fromList('entropy'.codeUnits),
    nonce: Uint8List.fromList('nonce'.codeUnits),
    pers: Uint8List.fromList('pers'.codeUnits)
  );

  print(drbg.generate(32));
  /// => [223, 110, 210, 86, 254, 183, 196, 138, 190, 248, 92, 76, 228, 11, 114, 177, 107, 85, 190, 86, 194, 225, 228, 39, 255, 18, 133, 161, 7, 16, 254, 192]
}

```
