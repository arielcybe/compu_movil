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
        title: const Text('Historial de Tickets'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCategory.isNotEmpty ? selectedCategory : null,
              decoration: const InputDecoration(
                labelText: 'Selecciona una categoría',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map((category) => DropdownMenuItem(
                value: category.token,
                child: Text(category.name),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue ?? '';
                  fetchTickets(); // Actualizar tickets al cambiar la categoría
                });
              },
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
                    child: Card(
                      color: Colors.green,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Título del ticket: ${ticket.subject}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Estado: ${ticket.status}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Fecha: ${ticket.created}',
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
