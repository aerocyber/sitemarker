import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:universal_io/io.dart';

DatabaseConnection connect() {
    return DatabaseConnection.delayed(Future(() async {
        if (Platform.isAndroid) {
            await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

            final cachedir = (await getTemporaryDirectory()).path;

            sqlite3.tempDirectory = cachedir;
            
        }
    
        return NativeDatabase.createBackgroundConnection(
            File(await getDatabaseFile()),
        );
    }));
}


Future<String> getDatabaseFile() async {
    if (Platform.environment["XDG_DATA_HOME"] != null) {
    return File("${Platform.environment['XDG_DATA_HOME']}/sitemarker.db").path;
    }else if (Platform.environment["SNAP_USER_COMMON"] != null) {
        return File("${Platform.environment['SNAP_USER_COMMON']}/sitemarker.db").path;
    } else {
        return File(
            "${(await getApplicationSupportDirectory()).path}/sitemarker.db")
            .path;
    }
}
