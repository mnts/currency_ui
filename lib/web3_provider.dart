import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:fractal/models/network.dart';
import 'package:http/http.dart' as http;

class FAuthButton extends StatelessWidget {
  const FAuthButton({super.key});

  static String addr = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: FilledButton(
        onPressed: () async {
          if (addr.isNotEmpty) return; //onComplete(addr);
          if (ethereum != null) {
            final eth = ethereum!;

            var accounts = await eth.request('eth_requestAccounts');
            if (accounts[0] == null) return print('No account connected');
            String address = accounts[0];

            final net = NetworkFractal.out;
            if (net == null) throw 'Not online';

            String nonce = (await net.rx({
              'cmd': 'web3nonce',
              'address': address,
            }))['nonce'];

            final message = 'Authenticate Fractal by $nonce';
            String signature = await eth.request(
              'personal_sign',
              [message, address],
            );

            final status = (await net.rx({
              'cmd': 'web3verify',
              'address': address,
              'message': message,
              'signature': signature,
            }))['status'];

            print(status);

            /*
            final auth = AuthMMFractal(
              address,
              message,
              signature,
            );
            */
          }
        },
        child: const Text('MetaMask'),
      ),
    );
  }

  Map<String, dynamic> msg(String nonce) => {
        'nonce': nonce,
        'domain': {
          // Defining the chain aka Rinkeby testnet or Ethereum Main Net
          'chainId': 1,
          'verifyingContract': '0xCefb4EeE91a3ce1F3843F79450b13CfaFd09f749',
          'name': 'Fractal',
          'version': '1',
        },
        'message': {
          'contents': 'Initial phase of the Fractal protocol',
        },
        'primaryType': 'Fractal',
        'types': {
          'EIP712Domain': [
            {'name': 'name', 'type': 'string'},
            {'name': 'version', 'type': 'string'},
            {'name': 'chainId', 'type': 'uint256'},
          ],
          // Not an EIP712Domain definition
          'Group': [
            {'name': 'name', 'type': 'string'},
            {'name': 'members', 'type': 'Person[]'},
          ],
          'Fractal': [
            {'name': 'contents', 'type': 'string'},
          ],
        },
      };

/*   Uint8List keccak(dynamic a, {int bits: 256}) {
    a = bytes.toBuffer(a);
    Digest sha3 = new Digest("SHA-3/${bits}");
    return sha3.process(a);
  }
 */
  req(Map<String, String> g) async {
    final uri = Uri.parse('/auth/providers/web3');

    var res = await http.get(
      uri.replace(
        queryParameters: g,
      ),
    );

    final r = jsonDecode(res.body);
    r['acc']['user']['email'] = '';
    r['session']['user'] = r['acc']['user'];
    activate(r['session']);
  }

  activate(Map<String, dynamic> a) {
    //final ses = Session.fromJson(a);
    //acc.nhost.auth.completeOAuthProviderLogin(redirectUrl)
    //Acc.nhost.auth.setSession(ses);
    // Acc.sattleAuth();
    //acc.activate();
  }
}
