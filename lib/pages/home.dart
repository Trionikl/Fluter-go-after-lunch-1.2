import 'package:flutter/material.dart';
//подключение расчёта каллорий
import 'package:to_do_03/pages/android/lib/NumberStepsKilometers.dart';
//import 'android/lib/calories_kilometers.dart';

NumberStepsKilometers NumberStepsKilometersObj = new NumberStepsKilometers();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todoList = [];
  String _product = ""; //продукт для поиска
  String _kilometers = ""; //Километры которые нужно пройти
  String _calories = ""; //Количество полученных калорий
String text ="";
  String _textField = ""; //Количество полученных калорий

  final _controller = TextEditingController(); //это нужно чтобы получить текстовое значение из поля ввода

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoList.addAll(['Buy milk', 'Wash dishes', 'Купить картошку']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Сколько пройти после обеда?'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children:[
      Column(children: <Widget>[
    Row(
      //ROW 1
        mainAxisAlignment:MainAxisAlignment.center,
      children: [
      Container(
        width: 300,
      //  color: Colors.orange,

        child: TextField(
           // onSubmitted: (text){
           //   _submittedText(text);
         //   },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              helperText: "Введите название продукта",
            ),
            controller: _controller
        ),
      ),
      ],
    ),
        Row(//ROW 2,5 тут кнопка - показать результат
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(25.0),
                child: ElevatedButton (
                  onPressed: () => _submittedTextButton(),
                  child: Text('Посчитать',
                      style: TextStyle(fontSize: 15)),
                ),
              ),
            ]),
    Row(//ROW 2
        mainAxisAlignment:MainAxisAlignment.center,

        children: <Widget>[
          Expanded(
              child: Text(
                  "$_product",
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center, // выравнивание по центру
                  style: TextStyle(color: Colors.blueAccent, // зеленый цвет текста
                      fontSize: 26, // высота шрифта 26
                      backgroundColor: Colors.white, // черный цвет фона текста
                  )
              )
          )
        ]

    ),
        Row(//ROW 3 километры
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(25.0),
                child: Text("$_kilometers",
                    softWrap: true,
                    textDirection: TextDirection.ltr, // текст слева направо
                    textAlign: TextAlign.center, // выравнивание по центру
                    style: TextStyle(color: Colors.blueAccent, // зеленый цвет текста
                        fontSize: 26, // высота шрифта 26
                        backgroundColor: Colors.white // черный цвет фона текста
                    )
                ),
              ),
            ]),
        Row(//ROW 4 каллории
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(25.0),
                child: Text("$_calories",
                    softWrap: true,
                    textDirection: TextDirection.ltr, // текст слева направо
                    textAlign: TextAlign.center, // выравнивание по центру
                    style: TextStyle(color: Colors.blueAccent, // зеленый цвет текста
                        fontSize: 26, // высота шрифта 26
                        backgroundColor: Colors.white // черный цвет фона текста
                    )
                ),
              ),
            ]),
    ]
    ),
        ],
      ),
    );
  }

//ФУНКЦИИ, приватные
  //обработка конца ввода текста в поле
  _submittedText(String text) {
    _textField=text;
   //return textField;
  }

  //обработка нажатия на кнопку
  _submittedTextButton() async {
    //название еды. Приходит из поля ввода
    String food_name = _controller.text;
    //количество еды, приходит из поля ввода
    var amount_food = "want_more";

    NumberStepsKilometers NumberStepsKilometersObj = new NumberStepsKilometers();
    Map<String, dynamic> answer = await NumberStepsKilometersObj.tail_dactyl(food_name, amount_food);

    var str_steps = answer["steps"];
    var str_kilometers = answer["kilometers"];
    var str_calories = answer["calories"];

    //если что то найдено
    if (str_calories != null) {
      setState(() => _product = 'Нужно пройти $str_steps шагов');
      setState(() => _kilometers = "Это $str_kilometers километров");

      double str_calories_double = double.parse(str_calories);
      str_calories = str_calories_double.toStringAsFixed(2);
      setState(() => _calories = "Сожжется $str_calories ккал.");
    }
    else {
      setState(() => _product = 'Я такого не знаю!');
      setState(() => _kilometers = "");
      setState(() => _calories = "");
    }

  }


  //конец класса Home
}
