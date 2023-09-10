import 'dart:async';

import 'package:currency_ui/init.dart';

class WalletFractal implements WalletFractalImpl {
  @override
  init() async => false;
}

FutureOr<bool> requestPayment(num val) async {
  return false;
}

FutureOr<String> requestAuth() async => '123456789';
