export 'unsupported_db.dart'
    if (dart.library.js_interop) 'web_db.dart'
    if (dart.library.html) 'web_db.dart'
    if (dart.library.ffi) 'native_db.dart';
