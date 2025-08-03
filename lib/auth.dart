export 'platform/base.dart'
    if (dart.library.ffi) 'platform/native.dart'
    if (dart.library.html) 'platform/web.dart';
