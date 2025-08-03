import 'package:flutter/material.dart';
import 'package:currency_ui/web3_provider.dart';

class FCryptoAuth extends StatelessWidget {
  const FCryptoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FAuthButton(),
        ],
      ),
    );
  }
}
