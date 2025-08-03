import 'dart:math';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:fractal/index.dart';
import 'package:flutter/material.dart';
import 'button.dart';

extension FBuyExt on FBuyState {
  Future payWithMetaMask() async {
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

    String error = '';

    try {
      String toAddress = '';
      if (f case NodeFractal node) {
        if (node.owner case UserFractal user) {
          toAddress = user.eth ?? '';
        }
      }

      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) {
        setState(() {
          final account = accs.first;
        });

        final valueInWei = BigInt.from(
          price! * pow(10, 18),
        );

        // Create and send the transaction
        final tx = await provider!.getSigner().sendTransaction(
              TransactionRequest(
                to: toAddress,
                value: valueInWei,
              ),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction sent! Hash: ${tx.hash}')),
        );

        print('Transaction hash: ${tx.hash}');
      } else {
        error = 'No account found. Please connect your wallet.';
      }
    } on EthereumException catch (e) {
      error = 'Error: ${e.message}';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    }

    if (error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}
