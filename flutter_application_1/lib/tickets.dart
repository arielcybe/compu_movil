import 'package:flutter/material.dart';
import 'services/process.dart'; // Asegúrate de importar process.dart correctamente.

class TicketScreen extends StatefulWidget {
  final String categoryToken;

  const TicketScreen({required this.categoryToken, super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchTicketsForCategory();
  }

  Future<void> fetchTicketsForCategory() async {
    final fetchedTickets = await fetchTicketsFromApi(widget.categoryToken);
    print('Tickets obtenidos: $fetchedTickets'); // Depuración
    setState(() {
      tickets = fetchedTickets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets', style: TextStyle(color: Colors.white)),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
              stops: [0.2, 0.9],
              begin: Alignment(-2.5, 1),
              end: Alignment(3, 1),
            ),
          ),
        ),
      ),
      body: tickets.isEmpty
          ? const Center(
        child: Text('No hay tickets disponibles para esta categoría'),
      )
          : ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return ListTile(
            title: Text(ticket['title'] ?? 'Título no disponible'),
            subtitle: Text('Estado: ${ticket['status'] ?? 'Sin estado'}'),
            onTap: () {
              // Acción al tocar un ticket.
            },
          );
        },
      ),
    );
  }
}
