import 'package:flutter/material.dart';

class CryptoPay extends StatefulWidget {
  const CryptoPay({super.key});

  @override
  State<CryptoPay> createState() => _CryptoPayState();
}

class _CryptoPayState extends State<CryptoPay> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/metamask.png'),
      onPressed: () async {},
    );
  }
}
