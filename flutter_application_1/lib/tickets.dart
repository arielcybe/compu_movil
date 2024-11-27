import 'package:flutter/material.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets', style: TextStyle(color: Colors.white)),
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
      body: Column(
        children: [
          Expanded(child: _ticketList()),
        ],
      ),
    );
  }

  Widget _ticketList() {
    int a = 29;
    return ListView(
      children: [
        for (int i = 1; i < a; i++)
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  stops: [0.2, 0.9],
                  begin: Alignment(-2.5, 1),
                  end: Alignment(3, 1),
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título del ticket $i',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Estado: Cualquiera',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Fecha: 2024-11-26',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Detalles del Ticket'),
                    content: const Text(
                      'Detalles completos del ticket seleccionado.\n'
                      'Estado: Cualquiera\nFecha: 2024-11-26',
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Color de fondo
                          foregroundColor: const Color.fromARGB(
                              255, 0, 0, 0), // Color del texto
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                        child: const Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
