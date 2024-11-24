import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/tickets.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ5NzQwYTcwYjA5NzJkY2NmNzVmYTg4YmM1MjliZDE2YTMwNTczYmQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5NzU3NDY5MzQ1NzY0MzUzNjYiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNwZWRyZXJvc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJfMENPQ1BaQTR4QWlHQUJFTlllcS13IiwibmFtZSI6IkNBTUlMTyBFU1RFQkFOIFBFRFJFUk9TIEpBUkEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSUNwU0o0UWk0WXBhTkctSWJYMWhzam95OEhsdmZZblJ2b3FCeFpxZlQzWHZkLWZqRT1zOTYtYyIsImdpdmVuX25hbWUiOiJDQU1JTE8gRVNURUJBTiIsImZhbWlseV9uYW1lIjoiUEVEUkVST1MgSkFSQSIsImlhdCI6MTczMjI1MTY2MywiZXhwIjoxNzMyMjU1MjYzfQ.V_dIxPRYi-SAKRgv9wSztgUKnivbUEPrYJkyThz0cIf6c9i-XNvoTtyRoCxoD6O_wFoGTdtd9bMroZGYblDvOFg1VAJadd1j4OsuCnDDJyhlVRM6KTdsOi3IZITFCSMedb-3qeNDo9jtevsbI-k_OPauMf1L5p8PiHf0rWLpBVYMfFEU9gO4pCtrJq_DHVTXGSTe_w7scQwGu3L_3Z51gdbIAR9FchkSHru44gQvg_8EyomZNEVgX7sx0fl-4W0v8LsTS7K34Bypkdm8HHl2rF4KelQX2bKE1P_IDjtH5tmyJNnHzQdr6_k3ugTZTV_g00lqkejjriH_26sKZKZtvA';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  ),
);

Future<Response<dynamic>?> fetchData() async {
  try {
    final response = await dio.get('/v1/info/types');
    return response;
  } on DioError catch (e) {
    print('Error: ${e.message}');
    print('Response data: ${e.response?.data}');
    print('Status code: ${e.response?.statusCode}');
    return null;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String requirementValue = 'Seleccione una opcion';
  String careerValue = 'Seleccione una carrera';
  String categoryValue = 'Categoria';
  bool showForm = false;
  Color mainColor1 = const Color(0xFF6400ab);
  Color mainColor2 = const Color(0xFFbbd80d);

  void changeColors(newColor1, newColor2) {
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
              labelText: 'Titulo',
              filled: true,
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: categoryValue,
            items: <String>[
              'Categoria',
              'Categoria 1',
              'Categoria 2',
              'Categoria 3'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.grey, // Adjust color as needed
                    fontSize: 16, // Adjust font size as needed
                    fontWeight:
                        FontWeight.normal, // Adjust font weight as needed
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                categoryValue = newValue!;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              labelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Detalles',
              filled: true,
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              alignLabelWithHint: true,
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
        title: const Text('Inicio', style: TextStyle(color: Colors.white)),
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
          duration: const Duration(milliseconds: 250),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _headerDrawer(context),
              _menuDrawer(context),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 20.0, left: 20.0), // Add padding here
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
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor1, mainColor2],
                    stops: const [0.2, 0.9],
                    begin: const Alignment(-2.5, 1),
                    end: const Alignment(3, 1),
                  ),
                  borderRadius:
                      BorderRadius.circular(30), // Hacer el contenedor redondo
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButton<String>(
                  value: requirementValue,
                  icon: const Icon(Icons.expand_more, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // Handle the selected value here
                    setState(() {
                      requirementValue = newValue!;
                      showForm = true;
                      switch (requirementValue) {
                        case 'Solicitar informacion':
                          changeColors(
                              const Color(0xFF00c4d5), const Color(0xFF00f56d));
                          break;
                        case 'Realizar sugerencia':
                          changeColors(
                              const Color(0xFFcd00d8), const Color(0xFFf9ff00));
                          break;
                        case 'Enviar reclamo':
                          changeColors(
                              const Color(0xFFff0000), const Color(0xFFb9d800));
                          break;
                        default:
                          showForm = false;
                          changeColors(
                              const Color(0xFF6400ab), const Color(0xFFbbd80d));
                      }
                    });
                  },
                  items: <String>[
                    'Seleccione una opcion',
                    'Solicitar informacion',
                    'Realizar sugerencia',
                    'Enviar reclamo'
                  ].map<DropdownMenuItem<String>>((String value) {
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
                padding: const EdgeInsets.only(
                    top: 20.0), // Adjust the padding as needed
                child: buildForm(),
              )
          ],
        ),
      ),
      floatingActionButton: showForm
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 150, // Ancho personalizado
              height: 50, // Altura personalizada
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [mainColor1, mainColor2], // Gradiente dinámico
                  stops: const [0.2, 0.9],
                  begin: const Alignment(-2.5, 1),
                  end: const Alignment(3, 1),
                ),
                borderRadius: BorderRadius.circular(30), // Bordes redondeados
              ),
              child: Material(
                color: Colors
                    .transparent, // Evita el color por defecto de Material
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    // Acción del botón
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enviar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8), // Espaciado entre texto e ícono
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Material _headerDrawer(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
            stops: [0.2, 0.9],
            begin: Alignment(-2.5, 1),
            end: Alignment(3, 1),
          ),
        ),
        child: InkWell(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top +
                  16, // Espaciado superior dinámico
              bottom: 24,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centra los elementos verticalmente
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors
                      .orange, // Color de fondo por si no se encuentra la imagen
                ),
                SizedBox(
                  height: 12, // Espaciado entre la imagen y el texto
                ),
                Text(
                  'Nombre Apellido',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold, // Añadido para mejor visibilidad
                  ),
                ),
                Text(
                  'correo@utem.cl',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70, // Usar un blanco más tenue
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuDrawer(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Mis tickets'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const TicketScreen(),
            ));
          },
        ),
        const SizedBox(height: 400),
        const Divider(
          color: Colors.red,
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Cerrar sesión'),
          onTap: () {},
        ),
      ],
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _data = ''; // Variable to store the fetched data
//
//   Future<void> _makeRequest() async {
//     final response = await fetchData();
//     if (response != null) {
//       setState(() {
//         // Si response.data es una lista o un mapa, conviértelo a String
//         _data = response.data is String
//             ? response.data
//             : jsonEncode(response.data); // Convierte objetos a JSON String
//       });
//     } else {
//       print('Error fetching data');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('Data from API:'),
//             Text(_data), // Display the fetched data
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _makeRequest,
//         tooltip: 'Fetch Data',
//         child: const Icon(Icons.download),
//       ),
//     );
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
