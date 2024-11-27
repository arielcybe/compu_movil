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
  bool isLoadingCategories = false; // Indicador de carga para categorías
  bool isLoadingTickets = false; // Indicador de carga para tickets

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Cargar categorías al inicio
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoadingCategories = true;
    });
    try {
      final fetchedCategories = await fetchCategoriesFromApi();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error al cargar categorías: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar las categorías.')),
      );
    } finally {
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> fetchTickets() async {
    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una categoría.')),
      );
      return;
    }
    setState(() {
      isLoadingTickets = true;
    });
    try {
      final fetchedTickets = await fetchTicketsFromApi(
        categoryToken: selectedCategory,
        type: 'ALL', // Puedes ajustar esto según la lógica de tu aplicación
        status: '',  // Puedes especificar un estado si es necesario
      );
      setState(() {
        tickets = fetchedTickets;
      });
    } catch (e) {
      print('Error al cargar tickets: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los tickets.')),
      );
    } finally {
      setState(() {
        isLoadingTickets = false;
      });
    }
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
            if (isLoadingCategories)
              const Center(child: CircularProgressIndicator())
            else
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
                  });
                  fetchTickets(); // Actualizar tickets al cambiar la categoría
                },
              ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoadingTickets
                  ? const Center(child: CircularProgressIndicator())
                  : tickets.isEmpty
                  ? const Center(
                child: Text('No hay tickets para mostrar.'),
              )
                  : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(ticket.subject ?? 'Sin asunto'),
                      subtitle: Text('Estado: ${ticket.status ?? 'Desconocido'}'),
                      onTap: () {
                        // Manejar el toque del ticket si es necesario
                      },
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