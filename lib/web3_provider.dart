import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/material.dart';
import 'package:fractal/models/network.dart';
import 'package:http/http.dart' as http;

class FAuthButton extends StatelessWidget {
  const FAuthButton({super.key});

  static String addr = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: FilledButton(
        onPressed: () async {
          if (addr.isNotEmpty) return; //onComplete(addr);

          final ethereum = globalContext.getProperty<JSObject?>(
            'ethereum'.toJS,
          );

          if (ethereum == null) {
            print('Ethereum provider not available');
            return;
          }

          // Request accounts
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
            print('No account connected');
            return;
          }
          String address = accounts[0];

          final net = NetworkFractal.out;
          if (net == null) throw 'Not online';

          String nonce = (await net.rx({
            'cmd': 'web3nonce',
            'address': address,
          }))['nonce'];

          final message = 'Authenticate Fractal by $nonce';

          // Personal sign
          final signArgs = JSObject();
          signArgs['method'] = 'personal_sign'.toJS;
          final params = JSArray<JSString>();
          params.add(message.toJS);
          params.add(address.toJS);
          signArgs['params'] = params;
          final signPromise = ethereum.callMethod<JSPromise>(
            'request'.toJS,
            signArgs,
          );
          final signatureResult = await signPromise.toDart;
          String signature = (signatureResult as JSString).toDart;

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
        },
        child: const Text('MetaMask'),
      ),
    );
  }

  /*   Uint8List keccak(dynamic a, {int bits: 256}) {
    a = bytes.toBuffer(a);
    Digest sha3 = new Digest("SHA-3/${bits}");
    return sha3.process(a);
  }
 */
  req(Map<String, String> g) async {
    final uri = Uri.parse('/auth/providers/web3');

    var res = await http.get(uri.replace(queryParameters: g));

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
