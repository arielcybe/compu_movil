import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/process.dart';
import 'package:flutter_application_1/tickets.dart';
import 'package:flutter_application_1/services/StorageService.dart';
import 'package:flutter_application_1/screens/Login.dart';
import 'package:flutter_application_1/screens/historial.dart';

import '../services/google_services.dart'; // Importa la nueva pantalla

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String requirementDD = 'Seleccione una opción';
  String categoryDD = 'Categoría';
  String requirement = '';
  String category = '';
  String title = '';
  String details = '';
  bool showForm = false;
  bool isSubmitting = false;
  var categories;
  var requirements;
  Color mainColor1 = const Color(0xFF6400ab);
  Color mainColor2 = const Color(0xFFbbd80d);

  @override
  void initState() {
    super.initState();
    categoriesRequest();
    requerimentsRequest();
  }

  Future<void> categoriesRequest() async {
    categories = await fetchCategoriesFromApi();
    print(categories?[0]);
  }

  Future<void> requerimentsRequest() async {
    requirements = await fetchRequirementsFromApi();
    print(requirements?[1].name);
  }

  void changeColors(Color newColor1, Color newColor2) {
    setState(() {
      mainColor1 = newColor1;
      mainColor2 = newColor2;
    });
  }

  Future<void> submitTicket() async {
    if (category.isEmpty || requirement.isEmpty || title.isEmpty || details.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor completa todos los campos antes de enviar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await createTicket(
        categoryToken: category,
        type: requirement,
        subject: title,
        message: details,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Éxito'),
          content: const Text('¡Ticket enviado con éxito!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetForm();
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error al enviar ticket: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Hubo un problema al enviar el ticket. Inténtalo de nuevo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void resetForm() {
    setState(() {
      requirementDD = 'Seleccione una opción';
      categoryDD = 'Categoría';
      requirement = '';
      category = '';
      title = '';
      details = '';
      showForm = false;
      changeColors(const Color(0xFF6400ab), const Color(0xFFbbd80d));
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
              labelText: 'Título',
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
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Buenas, bienvenido ¿qué deseas hacer?",
                style: TextStyle(fontSize: 16.0, color: Colors.black),
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
                  borderRadius: BorderRadius.circular(30), // Hacer el contenedor redondo
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButton<String>(
                  value: requirementDD.isNotEmpty && ['Seleccione una opcion', 'Solicitar informacion', 'Realizar sugerencia', 'Enviar reclamo'].contains(requirementDD)
                      ? requirementDD
                      : 'Seleccione una opcion', // Usa un valor válido si el actual no está en la lista
                  icon: const Icon(Icons.expand_more, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey,
                  underline: Container(),
                  onChanged: (String? newValue) {
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
            onTap: () {
              submitTicket();
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
            colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
            stops: [0.2, 0.9],
            begin: Alignment(-2.5, 1),
            end: Alignment(3, 1),
          ),
        ),
        child: FutureBuilder(
          future: Future.wait([
            StorageService.getValue('name'),
            StorageService.getValue('email'),
            StorageService.getValue('image'),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final userData = snapshot.data ?? ['', '', ''];
              final userName = userData[0] ?? 'Usuario';
              final userEmail = userData[1] ?? 'Correo no disponible';
              final userImage = userData[2] ?? '';

              return Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16, // Espaciado dinámico
                  bottom: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.orange,
                      backgroundImage: userImage.isNotEmpty
                          ? NetworkImage(userImage)
                          : null, // Usa la imagen del usuario si está disponible
                      child: userImage.isEmpty
                          ? const Icon(Icons.person, color: Colors.white, size: 35)
                          : null, // Icono por defecto si no hay imagen
                    ),
                    const SizedBox(height: 12), // Espaciado
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const DrawerHeader(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
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
              builder: (context) => const HistorialScreen(),
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
          onTap: () async {
            // Mostrar un diálogo de confirmación
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar cierre de sesión'),
                content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Cerrar sesión'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              // Limpia el almacenamiento y cierra sesión en Google
              await GoogleService.logOut();
              await StorageService.clear();
              // Redirige al usuario a la pantalla de inicio de sesión
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false, // Eliminar todas las rutas previas
                );
              }
            }
          },
        ),
      ],
    );
  }
}
