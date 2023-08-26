import 'package:hive/hive.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._();
  DbHelper._();
  factory DbHelper() => _instance;
  static late Box _box;

  static void openBox() {
    _box = Hive.box('money');
  }

  static void addData(int amount, DateTime date, String type, String note) async {
    var value = {'amount': amount, 'date': date, 'type': type, 'note': note};
    _box.add(value);
  }

  static Future deleteData(
    int index,
  ) async {
    await _box.deleteAt(index);
  }

  static Future cleanData() async {
    await _box.clear();
  }
}
