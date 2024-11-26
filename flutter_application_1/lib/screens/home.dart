import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/StorageService.dart';
import 'package:logger/logger.dart';
import '../services/process.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String requirementDD = 'Seleccione una opcion';
  String categoryDD = 'Categoria';
  String requirement = '';
  String category = '';
  String title = '';
  String details = '';
  bool showForm = false;
  Color mainColor1 = const Color(0xFF6400ab);
  Color mainColor2 = const Color(0xFFbbd80d);
  List<String> categories = [];

  static final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    categoriesRequest();
  }

  Future<void> categoriesRequest() async {
    final fetchedCategories = await fetchCategories();
    if (fetchedCategories != null) {
      setState(() {
        categories = fetchedCategories.map((category) => category.name).toList();
      });
    } else {
      _logger.e("Error al obtener categorías");
    }
  }

  void changeColors(Color newColor1, Color newColor2) {
    setState(() {
      mainColor1 = newColor1;
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
          // Campo de texto para título
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onChanged: (value) => setState(() {
              title = value;
            }),
          ),
          const SizedBox(height: 10),
          // Dropdown de categorías
          DropdownButtonFormField<String>(
            value: categories.contains(categoryDD) ? categoryDD : null,
            items: [
              const DropdownMenuItem(
                value: "Categoria",
                child: Text("Categoria"),
              ),
              ...categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ],
            onChanged: (String? newValue) {
              setState(() {
                categoryDD = newValue!;
              });
            },
            decoration: InputDecoration(
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
          // Campo de texto para detalles
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              alignLabelWithHint: true,
            ),
            onChanged: (value) => setState(() {
              details = value;
            }),
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
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomDrawerHeader(mainColor1: mainColor1, mainColor2: mainColor2),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Mis tickets'),
              onTap: () {
                _logger.d('Mis tickets seleccionados');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                _logger.d('Cerrar sesión');
                // Lógica para cerrar sesión
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
              child: Text(
                "Buenas, bienvenido ¿qué deseas hacer?",
                style: TextStyle(fontSize: 15.0, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
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
                  borderRadius: BorderRadius.circular(30),
                ),
                child: DropdownButton<String>(
                  value: requirementDD,
                  onChanged: (String? newValue) {
                    setState(() {
                      requirementDD = newValue!;
                      showForm = true;
                      switch (requirementDD) {
                        case 'Solicitar informacion':
                          requirement = 'INFORMATION';
                          changeColors(const Color(0xFF00c4d5), const Color(0xFF00f56d));
                          break;
                        case 'Realizar sugerencia':
                          requirement = 'SUGGESTION';
                          changeColors(const Color(0xFFcd00d8), const Color(0xFFf9ff00));
                          break;
                        case 'Enviar reclamo':
                          requirement = 'CLAIM';
                          changeColors(const Color(0xFFff0000), const Color(0xFFb9d800));
                          break;
                        default:
                          showForm = false;
                          changeColors(const Color(0xFF6400ab), const Color(0xFFbbd80d));
                      }
                    });
                  },
                  items: <String>[
                    'Seleccione una opcion',
                    'Solicitar informacion',
                    'Realizar sugerencia',
                    'Enviar reclamo',
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
                padding: const EdgeInsets.only(top: 20.0),
                child: buildForm(),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawerHeader extends StatelessWidget {
  final Color mainColor1;
  final Color mainColor2;

  const CustomDrawerHeader({required this.mainColor1, required this.mainColor2});

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: FutureBuilder<String>(
        future: StorageService.getValue('name'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final String name = snapshot.data ?? 'Usuario';
            return Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            return const Text('Cargando...',
                style: TextStyle(color: Colors.white));
          }
        },
      ),
      accountEmail: FutureBuilder<String>(
        future: StorageService.getValue('email'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final String email = snapshot.data ?? 'correo@utem.cl';
            return Text(
              email,
              style: const TextStyle(color: Colors.white70),
            );
          } else {
            return const Text('Cargando...',
                style: TextStyle(color: Colors.white70));
          }
        },
      ),
      currentAccountPicture: CircleAvatar(
        child: ClipOval(
          child: FutureBuilder<String>(
            future: StorageService.getValue('image'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final String photoUrl = snapshot.data ?? '';
                if (photoUrl.isNotEmpty) {
                  return CachedNetworkImage(
                    imageUrl: photoUrl,
                    placeholder: (context, url) {
                      return const CircularProgressIndicator();
                    },
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.person, color: Colors.white);
                    },
                  );
                } else {
                  return const Icon(Icons.person, color: Colors.white);
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mainColor1, mainColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
