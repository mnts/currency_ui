export 'platform/base.dart'
    if (dart.library.ffi) 'platform/native.dart'
    if (dart.library.js_interop) 'platform/web.dart';
