import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/process.dart';
import 'package:flutter_application_1/tickets.dart';
import 'package:flutter_application_1/services/StorageService.dart';
import 'package:flutter_application_1/screens/Login.dart';
import 'package:flutter_application_1/screens/historial.dart'; // Importa la nueva pantalla

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
  List<Category> categories = [];
  List<String> requirements = ['Información', 'Sugerencia', 'Reclamo'];
  Color mainColor1 = const Color(0xFF6400ab);
  Color mainColor2 = const Color(0xFFbbd80d);

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await fetchCategoriesFromApi();
      if (fetchedCategories.isNotEmpty) {
        setState(() {
          categories = fetchedCategories;
        });
        print('Categorías obtenidas: $categories');
      } else {
        print('No se encontraron categorías.');
      }
    } catch (e) {
      print('Error al cargar categorías: $e');
    }
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
            value: categoryDD == 'Categoría' ? null : categoryDD,
            items: [
              const DropdownMenuItem(
                value: 'Categoría',
                child: Text('Categoría'),
              ),
              ...categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  categoryDD = newValue;
                  final selectedCategory = categories.firstWhere(
                        (cat) => cat.name == newValue,
                    orElse: () => Category(token: '', name: '', description: ''),
                  );
                  category = selectedCategory.token;
                });
              }
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
          children: [
            FutureBuilder(
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

                  return UserAccountsDrawerHeader(
                    accountName: Text(userName),
                    accountEmail: Text(userEmail),
                    currentAccountPicture: userImage.isNotEmpty
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(userImage),
                    )
                        : const CircleAvatar(child: Icon(Icons.person)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [mainColor1, mainColor2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  );
                }
                return const DrawerHeader(child: CircularProgressIndicator());
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial de Tickets'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HistorialScreen(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
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
                  await StorageService.clear();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  }
                }
              },
            ),
          ],
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
              child: DropdownButton<String>(
                value: requirementDD,
                onChanged: (String? newValue) {
                  setState(() {
                    requirementDD = newValue!;
                    showForm = true;
                    switch (requirementDD) {
                      case 'Información':
                        requirement = 'INFORMATION';
                        changeColors(const Color(0xFF00c4d5), const Color(0xFF00f56d));
                        break;
                      case 'Sugerencia':
                        requirement = 'SUGGESTION';
                        changeColors(const Color(0xFFcd00d8), const Color(0xFFf9ff00));
                        break;
                      case 'Reclamo':
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
                  'Seleccione una opción',
                  'Información',
                  'Sugerencia',
                  'Reclamo',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
      floatingActionButton: showForm
          ? FloatingActionButton.extended(
        onPressed: isSubmitting ? null : submitTicket,
        label: const Text('Enviar'),
        icon: const Icon(Icons.send),
        backgroundColor: mainColor1,
      )
          : null,
    );
  }
}
