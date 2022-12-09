import 'dart:convert';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:currency_fractal/wallets/eth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/widgets/listen.dart';

class FractalEth extends StatelessWidget {
  final void Function(String)? onTap;
  late WalletEth wallet;
  FractalEth({
    String? matrixId,
    String? address,
    this.onTap,
    Key? key,
  })  : assert(
          matrixId != null || address != null,
          'Either Matrix ID or ETH address must be provided',
        ),
        super(key: key) {
    if (matrixId != null) {
      wallet = WalletEth.fromMatrixId(matrixId);
    } else {
      wallet = WalletEth(address!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Column(children: [
        ListTile(
          title: Listen(
            wallet.value,
            (ctx, child) => Text(
              wallet.value.value,
            ),
          ),
          subtitle: Listen(
            wallet.amount,
            (ctx, child) => Text(
              '${wallet.amount.value.toStringAsFixed(8)} ETH',
            ),
          ),
          trailing: const Icon(CryptoFontIcons.ETH),
          onTap: () {
            onTap?.call(wallet.address.value);
          },
        ),
        Listen(
          wallet.address,
          (ctx, child) => Text(
            wallet.address.value,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ]),
    );
  }
}
