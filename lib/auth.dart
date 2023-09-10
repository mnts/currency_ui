import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

class CryptoAuth extends StatefulWidget {
  const CryptoAuth({super.key});

  @override
  State<CryptoAuth> createState() => _CryptoAuthState();
}

class _CryptoAuthState extends State<CryptoAuth> {
  String address = '';

  @override
  Widget build(BuildContext context) {
    return address.isEmpty
        ? IconButton(
            icon: Icon(Icons.lock_person_rounded),
            onPressed: () async {
              if (ethereum != null) {
                try {
                  // Prompt user to connect to the provider, i.e. confirm the connection modal
                  final accs = await ethereum!
                      .requestAccount(); // Get all accounts in node disposal
                  accs; // [foo,bar]
                  setState(() {
                    address = accs[0] ?? '';
                  });
                } on EthereumUserRejected {
                  print('User rejected the modal');
                }
              }
            },
          )
        : Container(
            padding: EdgeInsets.all(18),
            child: Text(
              address,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          );
  }
}
