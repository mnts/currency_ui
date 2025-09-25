import 'dart:math';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
//import 'package:flutter_web3/flutter_web3.dart';
import 'package:fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_layout/scaffold.dart';
import 'button.dart';

extension FBuyExt on FBuyState {
  JSObject get ethereum {
    final eth = globalContext.getProperty<JSObject?>('ethereum'.toJS);
    if (eth == null) throw "Ethereum provider not available";
    return eth;
  }

  Future<String> get ethAccount async {
    final requestAccountsArgs = JSObject();
    requestAccountsArgs['method'] = 'eth_requestAccounts'.toJS;
    final accountsPromise = ethereum.callMethod<JSPromise>(
      'request'.toJS,
      requestAccountsArgs,
    );
    final accountsResult = await accountsPromise.toDart;
    final accounts = (accountsResult as JSArray<JSString>).toDart
        .map((e) => e.toDart)
        .toList();
    if (accounts.isEmpty) {
      throw 'No account connected';
    }
    return accounts[0];
  }

  String ethToHexWei(double eth) {
    final BigInt wei = BigInt.from((eth * 1e18).round());
    return '0x${wei.toRadixString(16)}';
  }

  Future payWithMetaMask() async {
    /*
    if (ethereum == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'MetaMask is not installed. Please install it to use this feature',
          ),
        ),
      );
      return;
    }
    */

    String error = '';

    try {
      String toAddress = '';
      if (f case NodeFractal node) {
        if (node.owner case UserFractal user) {
          toAddress = user.eth ?? '';
        }
      }

      print('to: $toAddress');

      final account = await ethAccount;

      print('acc: $account');

      // convert BigInt to hex string with 0x prefix
      final String valueHex = ethToHexWei(price!);

      print('val: $valueHex');

      // build transaction object expected by MetaMask / ethereum.request
      final txObject = JSObject();
      txObject['from'] = account.toJS; // required
      txObject['to'] = toAddress.toJS;
      txObject['value'] = valueHex.toJS;
      // optional: txObject['gas'] = '0x5208'.toJS; // 21000 gas in hex (if you want to set)
      // optional: txObject['gasPrice'] = gasPriceHex.toJS;
      // optional: txObject['nonce'] = nonceHex.toJS;

      final params = JSArray<JSObject>();
      params.add(txObject);

      print(params);

      final req = JSObject();
      req['method'] = 'eth_sendTransaction'.toJS;
      req['params'] = params;

      // ask MetaMask to send the transaction (this will open the wallet confirmation)
      final sendPromise = ethereum.callMethod<JSPromise>('request'.toJS, req);
      final sendResult = await sendPromise.toDart;

      // sendResult should be the transaction hash (a JSString)
      final txHash = (sendResult as JSString).toDart;

      // send hash to backend for validation
      final net = NetworkFractal.out!;
      final r = await net.rx({'cmd': 'web3tx', 'tx': txHash, 'hash': f.hash});

      if (r['error'] case String err) {
        throw err;
      } else {
        ScaffoldMessenger.of(FractalScaffoldState.active.context).showSnackBar(
          SnackBar(
            content: Text('Transaction sent! Hash: ${r['blockNumber']}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(FractalScaffoldState.active.context).showSnackBar(
        SnackBar(
          content: Text('$e', style: const .new(color: Colors.red)),
        ),
      );
    }
  }
}
