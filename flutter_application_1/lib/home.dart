import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String ticketValue = 'Seleccione una opcion';
  String carreraValue = 'Seleccione una carrera';
  bool showForm = false;
  Color mainColor1 = Color(0xFF6400ab);
  Color mainColor2 = Color(0xFFbbd80d);

  void changeColors(newColor1,newColor2) {
    setState(() {
      mainColor1 = mainColor1 == mainColor1 ? newColor1 : newColor1;
      mainColor1 = newColor1;
      mainColor2 = mainColor2 == mainColor2 ? newColor2 : newColor2;
      mainColor2 = newColor2;
    });
  }

  Widget buildForm() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xFFd3d3d3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Ingrese su correo electrónico',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
          const SizedBox(height: 10), // Add space between text fields
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Ingrese su correo electrónico',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: carreraValue,
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.white),
            dropdownColor: Colors.grey,
            underline: Container(),
            onChanged: (String? newValue) {
              setState(() {
                carreraValue = newValue!;
              });
            },
            items: <String>['Seleccione una carrera', 'Carrera 1', 'Carrera 2', 'Carrera 3']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Escriba su solicitud de información',
              hintMaxLines: 5,
            ),
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
        flexibleSpace: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainColor1, mainColor2],
              stops: const [0.2, 0.9],
              begin: const Alignment(-2.5, 1),
              end: const Alignment(3, 1),
            ),
          ),
          width: 200,
          height: 200,
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
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0), // Add padding here
              child: Text(
                "Buenas, bienvenido ¿que deseas hacer?",
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                textAlign: TextAlign.start, // Alineación a la izquierda
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0), // Add padding here
              child: AnimatedContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                duration: const Duration(milliseconds: 500),
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
                  value: ticketValue,
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // Handle the selected value here
                    setState(() {
                      ticketValue = newValue!;
                      showForm = true;
                      switch (ticketValue) {
                        case 'Solicitar informacion':
                          changeColors(const Color(0xFF00f56d), const Color(0xFF00c4d5));
                          break;
                        case 'Realizar sugerencia':
                          changeColors(const Color(0xFFcd00d8), const Color(0xFFf9ff00));
                          break;
                        case 'Enviar reclamo':
                          changeColors(const Color(0xFFff0000), const Color(0xFFb9d800));
                          break;
                        default:
                          showForm = false;
                          changeColors(const Color(0xFF6400ab), const Color(0xFFbbd80d));
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
            if (showForm)
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Adjust the padding as needed
                child: buildForm(),
              )
          ],
        ),
      ),
    );
  }
}

