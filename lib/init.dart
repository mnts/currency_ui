export 'io.dart' if (dart.library.html) 'html.dart';

abstract class WalletFractalImpl {
  Future<bool> init();
}
