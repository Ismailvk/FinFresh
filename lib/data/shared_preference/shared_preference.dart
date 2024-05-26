import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._();
  static final _instance = SharedPref._();
  static SharedPref get instance => _instance;

  static const String imagePathKey = 'imagePath';

  late SharedPreferences sharedPref;

  Future<void> initStorage() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  Future<void> storeNameAndImagePath(String imagePath) async {
    await sharedPref.setString(imagePathKey, imagePath);
  }

  Map<String, String?> getNameAndImagePath() {
    final imagePath = sharedPref.getString(imagePathKey);
    return {
      imagePathKey: imagePath,
    };
  }
}
