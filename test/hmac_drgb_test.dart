import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:hmac_drgb/hmac_drgb.dart';
import 'package:test/test.dart';

String encodeHEX(List<int> bytes) {
  var str = '';
  for (var i = 0; i < bytes.length; i++) {
    var s = bytes[i].toRadixString(16);

    str += s.padLeft(2, '0');
  }
  return str;
}

void main() {
  group('Hmac_DRBG', () {
    test('should support hmac-drbg-sha256', () {
      var drbg = HmacDRBG(
        hash: SHA256(),
        entropy: Uint8List.fromList('entropy'.codeUnits),
        nonce: Uint8List.fromList('nonce'.codeUnits),
        pers: Uint8List.fromList('pers'.codeUnits),
      );

      expect('df6ed256feb7c48abef85c4ce40b72b16b55be56c2e1e427ff1285a10710fec0',
          encodeHEX(drbg.generate(32)));
    });
  });
}
