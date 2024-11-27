import 'package:flutter/material.dart';
import '../services/process.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  String selectedCategory = '';
  List<Category> categories = [];
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Cargar categorías al inicio
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await fetchCategoriesFromApi();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error al cargar categorías: $e');
    }
  }

  Future<void> fetchTickets() async {
    if (selectedCategory.isEmpty) {
      print('Error: No se seleccionó una categoría');
      return;
    }
    try {
      final fetchedTickets = await fetchTicketsFromApi(categoryToken: selectedCategory);
      setState(() {
        tickets = fetchedTickets;
      });
    } catch (e) {
      print('Error al cargar tickets: $e');
    }
  }

  void showTicketDetails(Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles del Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Asunto: ${ticket.subject}'),
            Text('Estado: ${ticket.status}'),
            Text('Detalles: ${ticket.message}'),
            Text('Fecha: ${ticket.created}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tickets', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color del ícono aquí
        ),
        flexibleSpace: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
              stops: [0.2, 0.9],
              begin: Alignment(-2.5, 1),
              end: Alignment(3, 1),
            ),
          ),
          width: 200,
          height: 200,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
                  stops: [0.2, 0.9],
                  begin: Alignment(-2.5, 1),
                  end: Alignment(3, 1),
                ),
                borderRadius: BorderRadius.circular(30), // Bordes redondeados
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory.isNotEmpty ? selectedCategory : "",
                  dropdownColor: Colors.grey,// Fondo blanco del menú desplegable
                  iconEnabledColor: Colors.white, // Ícono blanco
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: "", // Opción predeterminada
                      child: Text(
                        'Categoría',
                        style: TextStyle(
                          color: Colors.white, // Texto blanco para la opción predeterminada
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    ...categories.map<DropdownMenuItem<String>>((Category category) {
                      return DropdownMenuItem<String>(
                        value: category.token, // Asigna el token como valor
                        child: Text(
                          category.name, // Muestra el nombre de la categoría
                          style: const TextStyle(
                            color: Colors.white, // Texto blanco en las opciones desplegadas
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue ?? '';
                      fetchTickets(); // Actualizar tickets al cambiar la categoría
                    });
                  },
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none, // Sin borde
                    focusedBorder: InputBorder.none, // Sin borde al enfocar
                    filled: true,
                    fillColor: Colors.transparent, // Fondo transparente para mostrar el gradiente
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: tickets.isEmpty
                  ? const Center(
                child: Text('No hay tickets para mostrar.'),
              )
                  : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return GestureDetector(
                    onTap: () => showTicketDetails(ticket),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8), // Espaciado entre tarjetas
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
                          stops: [0.2, 0.9],
                          begin: Alignment(-2.5, 1),
                          end: Alignment(3, 1),
                        ),
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Sombra hacia abajo
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Margen interno de la tarjeta
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Título: ${ticket.subject}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Estado: ${ticket.status}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}