import 'package:fractal/index.dart';
import 'package:flutter/material.dart';
import 'platforms.dart';

class FBuy extends StatefulWidget {
  final WithPriceF f;
  const FBuy(this.f, {super.key});

  @override
  State<FBuy> createState() => FBuyState();
}

class FBuyState extends State<FBuy> {
  static const textStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  //late final nodeIn = FractalNodeIn.of(context)!;
  WithPriceF get f => widget.f; //nodeIn.node;
  double? get price => f.price;

  late final ctrl = TextEditingController(
    text: '${price ?? ''}',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 40,
      child: TextButton.icon(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Colors.orange,
          ),
          textStyle: WidgetStatePropertyAll(
            textStyle,
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.fromLTRB(8, 2, 4, 2),
          ),
        ),
        onPressed: payWithMetaMask,
        icon: const Text(
          'Ξ',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        label: f.own
            ? TextFormField(
                //inputFormatters: [TextInputFormatter.withFunction((t) =>'')],
                controller: ctrl,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0, 8, 2, 0),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                onFieldSubmitted: submit,
              )
            : Text(
                '${price ?? ''}',
                style: textStyle,
              ),
      ),
    );
  }

  submit(String text) {
    final dbl = double.tryParse(text);
    if (dbl != null) {
      f.updatePrice(dbl);
    } else {
      ctrl.text = '';
    }
  }
}
