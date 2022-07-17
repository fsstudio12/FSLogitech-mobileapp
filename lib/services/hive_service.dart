import 'package:hive_flutter/hive_flutter.dart';

import '../models/nova_model.dart';

class HiveService {
  Future<Box> initHive() async {
    if (!Hive.isBoxOpen('novaBox')) {
      await Hive.initFlutter();
      registerTypeAdapters();

      Box NovaBox = await Hive.openBox('novaBox',
          compactionStrategy: (contents, modifiedContents) {
        return modifiedContents > 20;
      });
      return NovaBox;
    } else {
      return getNovaBox();
    }
  }

  void registerTypeAdapters() {
    Hive.registerAdapter(UserDataAdapter());
  }

  Box getNovaBox() {
    return Hive.box('novaBox');
  }

  void clearBox() {
    Box _box = getNovaBox();
    _box.clear();
  }

  void saveIsLoggedIn(String isLoggedIn) {
    Box _box = HiveService().getNovaBox();
    _box.put("isLoggedIn", isLoggedIn);
  }

  getIsLoggedIn() {
    Box _box = HiveService().getNovaBox();
    dynamic isLoggedIn = _box.get("isLoggedIn");
    return isLoggedIn;
  }

  saveDriverDetail(UserData driverDetail) {
    Box _box = HiveService().getNovaBox();
    _box.put("driverDetail", driverDetail);
  }

  getDriverDetail() {
    Box _box = HiveService().getNovaBox();
    UserData? driverDetail = _box.get("driverDetail");
    return driverDetail;
  }
}
