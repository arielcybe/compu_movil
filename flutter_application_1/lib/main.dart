import 'package:flutter/material.dart';
import 'process.dart';

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
  var categories;
  var requirements;

  void initState() {
    super.initState();
    categoriesRequest();
    requerimentsRequest();

  }

  Future<void> categoriesRequest() async {
    categories = await fetchCategories();
    print(categories?[0]);
  }

  Future<void> requerimentsRequest() async {
    requirements = await fetchRequirements();
    print(requirements?[1].name);
  }

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
              labelText: 'Titulo',
              filled: true,
              labelStyle: const TextStyle(color:
              Colors.grey,
                fontSize: 16,
              ),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onChanged: (value) {
              setState(() {
                title = value;
              });
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: categories.contains(categoryDD) ? categoryDD : "", // Usa null si no coincide
            items: [
              const DropdownMenuItem<String>(
                value: "",
                child: Text(
                  'Categoría',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ...categories.map<DropdownMenuItem<String>>((Category category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: (String? newValue) {
              setState(() {
                categoryDD = newValue!;
                category = categories.firstWhere((cat) => cat.name == newValue).token;
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
              labelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Detalles',
              filled: true,
              labelStyle: const TextStyle(color:
              Colors.grey,
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
            onChanged: (value) {
              setState(() {
                details = value;
              });
            },
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
                duration: const Duration(milliseconds: 250),
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
                  value: requirementDD,
                  icon: const Icon(Icons.expand_more , color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // Handle the selected value here
                    setState(() {
                      requirementDD = newValue!;
                      showForm = true;
                      switch (requirementDD) {
                        case 'Solicitar informacion':
                          requirement = requirements?[2].name;
                          changeColors(const Color(0xFF00c4d5), const Color(0xFF00f56d));
                          break;
                        case 'Realizar sugerencia':
                          requirement = requirements?[1].name;
                          changeColors(const Color(0xFFcd00d8), const Color(0xFFf9ff00));
                          break;
                        case 'Enviar reclamo':
                          requirement = requirements?[0].name;
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
          color: Colors.transparent, // Evita el color por defecto de Material
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () async {
              await createTicket(
              categoryToken: category,
              type: requirement,
              subject: title,
              message: details,
              );
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
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
      ) : null,
    );
  }
  Material _headerDrawer(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6400ab),Color(0xFFbbd80d)],
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
              mainAxisAlignment:
              MainAxisAlignment.center, // Centra los elementos verticalmente
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
                    fontWeight: FontWeight.bold, // Añadido para mejor visibilidad
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
          onTap: () {},
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