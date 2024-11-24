import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DropdownExample(),
    );
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? selectedOption;

  final List<String> options = [
    'Solicitar Información',
    'Realizar Sugerencia',
    'Enviar Reclamo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.purpleAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedOption,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              iconSize: 30,
              hint: Text(
                'Selecciona Una Opción',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedOption = value;
                });
              },
              dropdownColor: Colors.transparent, // Elimina el fondo estándar del Dropdown
              style: TextStyle(fontSize: 16),
              menuMaxHeight: 200, // Altura máxima del menú desplegable
            ),
          ),
        ),
      ),
    );
  }
}
