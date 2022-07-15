import 'dart:ffi';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:enough_convert/enough_convert.dart';
import 'package:windows1251/windows1251.dart';
//import 'package:dart_application_1/dart_application_1.dart' as dart_application_1;

//ОПИСАНИЕ КЛАССА
//определение шагов и километров в зависимости от съеденной еды и её количества
class NumberStepsKilometers {
  //название еды
  //var food = "Жаренная картошка";
  // var key_eaten = "want_more"; //количество потреблённой еды
  //количество калорий сжигаемых за 1 шаг
  double number_calories_burned_per_step = 0.05686546463;

  //количество километров в одном шаге
  double number_kilometers_one_step = 0.00071197411;

//Количество съеденной еды (задавать кратно 100)
  var amount_food_eaten = {
    "slight_feeling_hunger": "300", //легкое чувство голода
    "want_more": "700", //хочется ещё
    "wont_fit_anymore": "1400" //больше не влезет
  };

//название продукта, количество шагов, количество километров
  var return_value = {
    "food": "", //еда
    "key_eaten": "", //Количество съеденной еды
    "steps": "", //шаги
    "kilometers": "" //километры
  };

  Future<Map<String, dynamic>> tail_dactyl(var food, var key_eaten) async {
    List list = food.split(" ");
    var website = "https://www.google.ru/search?q=";
    var website_address = null;
    var food_eaten = null; // количество съеденной еды

    for (int i = 0; i < list.length; i++) {
      website = '$website ${list[i]} +';
    }
    website = '$website калорийность';
    website_address = website.replaceAll(" ", "");

    // print("запрос: $website_address");

    var url = Uri.parse(website_address);
    var response = await http.get(url);
    final codec = const Windows1252Codec(allowInvalid: false);

    //print(response.body);
//обработка ошибок
    try {
      var document = parse(response.body);
      var input = document.getElementsByClassName("s3v9rd");
      var text = input[1].text;

      var encoded = codec.encode(text);
      dynamic calories = windows1251.decode(encoded);

      List list_calories = calories.split(" ");
      calories = list_calories[0];

      String temp_calories = calories;
      var is_number = _isNumeric(temp_calories);

//если строка не является числом, поиск первого вхождения числа (жареная картошка)
      if (is_number == false) {
        for (int i = 0; i < list_calories.length; i++) {
          is_number = _isNumeric(list_calories[i]);
          if (is_number == true) {
            if (list_calories[i + 1] == "ккал") {
              calories = list_calories[i];
              calories = calories.toString();
              break;
            }
          }
        }
      } else {
        calories = calories.toString();
      }

      if (_isNumeric(calories) == false) {
        calories = 0.0; //не нашёл калории для продукта
      }

      // String strCalories = calories;
      //calories = double.parse(strCalories);

//response.body
      // print('Response status: ${response.statusCode}');
      //  print('Response body: $calories');

      // print('Еда: $food');

      RegExp exp = RegExp(r"[^0-9-.]+");
      String str = calories;
      String res = str.replaceAll(exp, '');
      double calories_double = double.parse(res);

      print('Количество килокалорий на 100 грамм продукта: $calories_double');
      //print('Response body: ${response.body}');

      //print(await http.read(Uri.parse('https://example.com/foobar.txt')));

//определение количества потреблённой еды
      if (key_eaten == "slight_feeling_hunger") {
        food_eaten = amount_food_eaten[key_eaten];
      } else if (key_eaten == "want_more") {
        food_eaten = amount_food_eaten[key_eaten];
      } else if (key_eaten == "wont_fit_anymore") {
        food_eaten = amount_food_eaten[key_eaten];
      }

      double food_eaten_double = double.parse(food_eaten);

      //  print('food_eaten_double: $food_eaten_double');

      //определение количества полученных каллорий
      var calories_received = calories_double * (food_eaten_double / 100);

      //количество шагов
      var number_steps = calories_received / number_calories_burned_per_step;
      int number_steps_int = number_steps.toInt();

      //количество километров
      double number_kilometers = number_kilometers_one_step * number_steps;
      var number_kilometers_str = number_kilometers.toStringAsFixed(2);

      // print('Количество калорий: $calories_received');
      // print('Количество шагов: $number_steps_int');
      //  print('Количество километров: $number_kilometers_str');

      return_value["food"] = food;
      return_value["key_eaten"] = key_eaten;
      return_value["steps"] = number_steps_int.toString();
      return_value["kilometers"] = number_kilometers_str;
      return_value["calories"] = calories_received.toString();

      //  print('$return_value');
    } catch (e, s) {
      // print("Обработка исключения $e");
      // print("Стек $s");
      dynamic calories = 0;
    }
    return return_value;
  }

//определение - является ли строка числом
  bool _isNumeric(String str) {
    try {
      var value = double.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }

//конец класса
}
