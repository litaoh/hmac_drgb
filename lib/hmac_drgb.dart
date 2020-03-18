/// Support for doing something awesome.
///
/// More dartdocs go here.
library hmac_drgb;

import 'dart:typed_data';

import 'package:hash/hash.dart' as h;

class HmacDRBG {
  h.BlockHash hash;
  bool predResist;
  int outSize;
  int minEntropy;
  Uint8List K;
  Uint8List V;
  HmacDRBG(
      {this.hash,
      this.predResist,
      int outLen,
      int minEntropy,
      Uint8List entropy,
      Uint8List nonce,
      Uint8List pers}) {
    outSize = outLen ?? hash.outSize;
    this.minEntropy = minEntropy ?? hash.hmacStrength;
    _init(entropy, nonce, pers);
  }
  void _init(Uint8List entropy, Uint8List nonce, Uint8List pers) {
    var seed = Uint8List(entropy.length + nonce.length + pers.length);
    var offset = 0;
    var end = entropy.length;
    seed.setRange(offset, end, entropy);
    offset = end;
    end += nonce.length;
    seed.setRange(offset, end, nonce);
    offset = end;
    end += pers.length;
    seed.setRange(offset, end, pers);

    K = Uint8List(outSize ~/ 8);
    V = Uint8List(outSize ~/ 8);
    for (var i = 0; i < V.length; i++) {
      K[i] = 0x00;
      V[i] = 0x01;
    }

    _update(seed);
  }

  h.Hmac _hmac() {
    return h.Hmac(hash, K);
  }

  void _update(Uint8List seed) {
    var kmac = _hmac().update(V).update([0x00]);
    if (seed != null) {
      kmac = kmac.update(seed);
    }
    K = kmac.digest();
    V = _hmac().update(V).digest();
    if (seed == null) {
      return;
    }

    K = _hmac().update(V).update([0x01]).update(seed).digest();
    V = _hmac().update(V).digest();
  }

  Uint8List generate(int len, [Uint8List add]) {
    // Optional additional data
    if (add != null) {
      _update(add);
    }

    var temp = <int>[];
    while (temp.length < len) {
      V = _hmac().update(V).digest();
      temp.addAll(V);
    }

    var res = temp.sublist(0, len);

    return Uint8List.fromList(res);
  }
}
// TODO: Export any libraries intended for clients of this package.
