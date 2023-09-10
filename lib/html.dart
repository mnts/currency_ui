import 'dart:async';

import 'package:currency_ui/init.dart';
import 'package:flutter_web3/flutter_web3.dart';

class WalletFractal implements WalletFractalImpl {
  @override
  init() async {
    //final net = await provider!.ready;
    if (ethereum == null) return false;
    ethereum!.onAccountsChanged((accounts) {
      print('Ethereum ready');
      print(accounts); // ['0xbar']
    });
    return true;
  }
}

FutureOr<bool> requestPayment(num val) async {
  // Send 1000000000 wei to `0xcorge`
  final tx = await provider!.getSigner().sendTransaction(
        TransactionRequest(
          to: '0x960aDc277576910dA05511C316C26AC148345b85',
          value: BigInt.from(val),
        ),
      );

  tx.hash; // 0xplugh

  await tx.wait();

  return true;
}

FutureOr<String> requestAuth() async {
  if (ethereum != null) {
    try {
      final accs = await ethereum!.requestAccount();
      return accs.isNotEmpty ? accs[0] : '';
    } on EthereumUserRejected {
      return '';
    }
  }
  return '';
}
