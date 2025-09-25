@JS('MetaMaskSDK')
library metamask;

import 'dart:convert';
import 'package:convert/convert.dart' show hex;
import 'dart:js_interop';
import 'dart:async';

// MetaMask SDK instance
@JS()
class MetaMaskSDK {
  external MetaMaskSDK(dynamic options);
  external dynamic getProvider();
}

// Ethereum provider
@JS()
class Ethereum {
  external Future<dynamic> request(dynamic args);
}

// Initialize MetaMask SDK
@JS()
external MetaMaskSDK initMetaMaskSDK(dynamic options);

// Dart wrapper for MetaMask SDK
class MetaMask {
  static MetaMaskSDK? _sdk;
  static Ethereum? _provider;

  static Future<void> initialize() async {
    if (_sdk == null) {
      _sdk = initMetaMaskSDK({
        'dappMetadata': {
          'name': 'Fractal MetaMask UI',
        },
      });
      _provider = _sdk!.getProvider();
    }
  }

  static Future<List<String>> requestAccounts() async {
    if (_provider == null) await initialize();
    final accounts = await _provider!.request({
      'method': 'eth_requestAccounts',
      'params': [],
    });
    return List<String>.from(accounts);
  }

  static Future<String> personalSign(String message, String address) async {
    if (_provider == null) await initialize();
    // Convert message to hex
    final hexMessage =
        '0x${bytesToHex(utf8.encode(message), include0x: false)}';
    final signature = await _provider!.request({
      'method': 'personal_sign',
      'params': [hexMessage, address],
    });
    return signature as String;
  }
}

String bytesToHex(
  List<int> bytes, {
  bool include0x = false,
  int? forcePadLength,
  bool padToEvenLength = false,
}) {
  var encoded = hex.encode(bytes);

  if (forcePadLength != null) {
    assert(forcePadLength >= encoded.length);

    final padding = forcePadLength - encoded.length;
    encoded = ('0' * padding) + encoded;
  }

  if (padToEvenLength && encoded.length % 2 != 0) {
    encoded = '0$encoded';
  }

  return (include0x ? '0x' : '') + encoded;
}
