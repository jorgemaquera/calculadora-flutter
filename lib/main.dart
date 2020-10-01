import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

double add(double num1, double num2) {
  return num1 + num2;
}

double substract(double num1, double num2) {
  return num1 - num2;
}

double multiply(double num1, double num2) {
  return num1 * num2;
}

double divide(double num1, double num2) {
  return num2 == 0 ? null : num1 / num2;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Operaciones {
  Suma,
  Resta,
  Multiplicacion,
  Division,
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildOperationButton(String char, Operaciones operacion) {
    return IconButton(
      icon: Text(
        char,
        style: TextStyle(
          color: Colors.lightBlue,
          fontSize: 30,
        ),
      ),
      onPressed: () {
        if (numero.isEmpty) return;
        setState(() {
          numeros.add(double.parse(numero));
          numero = '';
          operaciones.add(operacion);
        });
      },
    );
  }

  String displayNumber(double numb) {
    if (numb == null) return null;

    return numb - numb.toInt() == 0 ? numb.toStringAsFixed(0) : numb.toString();
  }

  void calculate() {
    if (numero.contains('..')) return;
    if (numero.isEmpty) {
      print('Error: invalida operation');
      return;
    }
    numeros.add(double.parse(numero));
    final nums = [...numeros];
    for (int i = 0; nums.length > 1; i++) {
      switch (operaciones[i]) {
        case Operaciones.Suma:
          final rs = add(nums[0], nums[1]);
          nums.removeAt(0);
          nums[0] = rs;
          break;
        case Operaciones.Resta:
          final rs = substract(nums[0], nums[1]);
          nums.removeAt(0);
          nums[0] = rs;
          break;
        case Operaciones.Multiplicacion:
          final rs = multiply(nums[0], nums[1]);
          nums.removeAt(0);
          nums[0] = rs;
          break;
        case Operaciones.Division:
          final rs = divide(nums[0], nums[1]);
          nums.removeAt(0);
          nums[0] = rs;
          break;
      }
      if (nums[0] == null) break;
    }
    setState(() {
      numero = displayNumber(nums[0]);
      numeros = [];
      operaciones = [];
    });
  }

  Widget _buildNumber(String number) {
    return IconButton(
      icon: Text(
        number,
        style: TextStyle(fontSize: 40),
      ),
      iconSize: 43,
      onPressed: () {
        setState(() {
          numero = (numero == null ? number : numero + number);
        });
      },
    );
  }

  var numero = '';
  var numeros = <double>[];
  var operaciones = <Operaciones>[];

  String displayOperation() {
    var operacion = '';
    if (numeros.contains(null) || numero == null) return 'Error';
    var maxLenght = max(numeros.length, operaciones.length);
    for (int i = 0; i < maxLenght; i++) {
      final numb = i < numeros.length ? displayNumber(numeros[i]) : '';
      final op = i < operaciones.length ? operationToChar(operaciones[i]) : '';
      operacion = operacion + '$numb$op';
    }
    return operacion + numero;
  }

  void reset() {
    setState(() {
      numero = '';
      numeros = [];
      operaciones = [];
    });
  }

  void backSpace() {
    if (numero.isNotEmpty) {
      // numero = numero.length > 1 ? numero.substring(0, numero.length - 1) : '';
      numero = numero.substring(0, numero.length - 1);
    } else if ((operaciones.length == numeros.length) && numeros.length > 0) {
      operaciones.removeLast();
      numero = displayNumber(numeros.removeLast());
    } else {
      return;
    }
    setState(() {});
  }

  String operationToChar(Operaciones op) {
    switch (op) {
      case Operaciones.Suma:
        return '+';
        break;
      case Operaciones.Resta:
        return '-';
      case Operaciones.Multiplicacion:
        return 'x';
      case Operaciones.Division:
        return '/';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height - mediaQuery.padding.top;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: mediaQuery.padding.top),
            width: double.infinity,
            height: availableHeight * 0.15 + mediaQuery.padding.top,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightGreen[200], Colors.lightBlue[100]],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Text(
                displayOperation(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          Container(
            height: availableHeight * 0.12,
            decoration: BoxDecoration(color: Colors.lightGreen[50]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOperationButton('+', Operaciones.Suma),
                _buildOperationButton('-', Operaciones.Resta),
                _buildOperationButton('x', Operaciones.Multiplicacion),
                _buildOperationButton('/', Operaciones.Division),
              ],
            ),
          ),
          SizedBox(height: availableHeight * 0.04),
          Container(
            height: availableHeight * 0.14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumber('7'),
                _buildNumber('8'),
                _buildNumber('9'),
              ],
            ),
          ),
          Container(
            height: availableHeight * 0.14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumber('4'),
                _buildNumber('5'),
                _buildNumber('6'),
              ],
            ),
          ),
          Container(
            height: availableHeight * 0.14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumber('1'),
                _buildNumber('2'),
                _buildNumber('3'),
              ],
            ),
          ),
          Container(
            height: availableHeight * 0.14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumber('.'),
                _buildNumber('0'),
                IconButton(
                  icon: Icon(Icons.backspace),
                  onPressed: backSpace,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Text('ac', style: TextStyle(fontSize: 30)),
                    iconSize: 35.0,
                    onPressed: reset,
                  ),
                  IconButton(
                    icon: Text(
                      '=',
                      style: TextStyle(fontSize: 40, color: Colors.lightBlue),
                    ),
                    onPressed: calculate,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
