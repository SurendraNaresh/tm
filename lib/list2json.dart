
import 'dart:convert';
import 'dart:math';

main() {
  List<String> colors = ['Blue', 'Red', 'Black', 'Yellow', 'White', 'Pink'];

  Map<String, Map<String, int>> data = {};

  data['datarow1']  = {};
  for (String color in colors) {
    //print("Generating values of Color:${color}\n");
    data['datarow1'][color] = _generateRandomRGB();
  }

  String jsonColors = jsonEncode(data);
  print(jsonColors);
}

int _generateRandomRGB() {
  Random random = Random();
  return random.nextInt(256); // generates a random number between 0 and 255
}
