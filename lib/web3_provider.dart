import 'dart:convert';
//import 'package:acc_fractal/auth/metamask.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:fractals/models/account.dart';
import 'package:http/http.dart';

import 'package:js/js.dart';
import 'package:velocity_x/velocity_x.dart';

@JS('web3.eth.accounts.hashMessage') // This marks the annotated function as a call to `console.log`
external String hashMessage(String name);

@JS('web3.eth.personal.sign') // This marks the annotated function as a call to `console.log`
external String signMessage(String data, String address, String password);

class SlyAuthButton extends StatelessWidget {
  final Function(String) onComplete;
  SlyAuthButton({Key? key, required this.onComplete});

  static String addr = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ElevatedButton(
        child: HStack([
          Image.asset(
            'assets/metamask.png',
            height: 64,
          ),
          Text("Enter")
        ]),
        onPressed: () async {
          if (addr.length > 0) return onComplete(addr);
          if (ethereum != null) {
            final eth = ethereum!;
            print('START ETH');

            var accounts = await eth.request('eth_requestAccounts');
            if (accounts[0] == null) return print('No account connected');
            String address = accounts[0];

            print(address);

            //final signed = hashMessage(msg);
            //String sign = await eth.request('eth_sign', [address, signed]);

            //final web3 = Web3Provider.fromEthereum(eth);

            final message = jsonEncode(msg);

            String signature = EthSigUtil.signTypedData(
                privateKey: address,
                jsonData: message,
                version: TypedDataVersion.V4);

            onComplete(address);

            /*
            final auth = AuthMMFractal(
              address,
              message,
              signature,
            );
            */
          }
        },
      ),
    );
  }

  final msg = {
    'domain': {
      // Defining the chain aka Rinkeby testnet or Ethereum Main Net
      'chainId': 1,
      'verifyingContract': '0xCefb4EeE91a3ce1F3843F79450b13CfaFd09f749',
      'name': 'Slyverse',
      'version': '1',
    },
    'message': {
      'contents':
          'Welcome to the beta testing phase of the Slyverse. Please sign in to continue.',
    },
    'primaryType': 'Sly',
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
      'Sly': [
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
    final uri = Uri.parse(Acc.base + '/auth/providers/web3');

    var request = Request(
      'GET',
      uri.replace(
        queryParameters: g,
      ),
    );

    final res = await request.send();

    Map<String, dynamic> r = jsonDecode(await res.stream.bytesToString());
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
