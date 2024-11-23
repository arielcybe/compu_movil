import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'Seleccione una opcion';
  bool showForm = false;
  Color mainColor1 = Color(0xFF6400ab);
  Color mainColor2 = Color(0xFFbbd80d);

  Widget buildForm() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Add form fields for "Solicitar informacion" here
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ingrese su nombre',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ingrese su correo electrónico',
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Escriba su solicitud de información',
              hintMaxLines: 5,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle form submission for "Solicitar informacion"
              print('Solicitud de información enviada!');
            },
            child: const Text('Enviar solicitud'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainColor1, mainColor2],
              stops: const [0.2, 0.9],
              begin: const Alignment(-2.5, 1),
              end: const Alignment(3, 1),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        // Aquí va el contenido de tu drawer
        child: ListView(
          // ...
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0), // Add padding here
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor1, mainColor2],
                    stops: const [0.2, 0.9],
                    begin: const Alignment(-2.5, 1),
                    end: const Alignment(3, 1),
                  ),
                  borderRadius: BorderRadius.circular(30), // Hacer el contenedor redondo
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.deepPurpleAccent,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // Handle the selected value here
                    setState(() {
                      dropdownValue = newValue!;
                      showForm = true;
                      switch (dropdownValue) {
                        case 'Solicitar informacion':
                          mainColor1 = const Color(0xFF00f56d);
                          mainColor2 = const Color(0xFF00c4d5);
                          break;
                        case 'Realizar sugerencia':
                          mainColor1 = const Color(0xFFcd00d8);
                          mainColor2 = const Color(0xFFf9ff00);
                          break;
                        case 'Enviar reclamo':
                          mainColor1 = const Color(0xFFb9d800);
                          mainColor2 = const Color(0xFFff0000);
                          break;
                        default:
                          showForm = false;
                          mainColor1 = const Color(0xFF6400ab);
                          mainColor2 = const Color(0xFFbbd80d);
                      }
                    });
                  },
                  items: <String>['Seleccione una opcion', 'Solicitar informacion', 'Realizar sugerencia', 'Enviar reclamo']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (showForm) buildForm(),
          ],
        ),
      ),
    );
  }
}
