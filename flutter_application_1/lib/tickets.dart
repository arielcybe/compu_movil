import 'package:flutter/material.dart';

class ticketScreen extends StatefulWidget {
  const ticketScreen({super.key});

  @override
  State<ticketScreen> createState() => _ticketScreenState();
}

class _ticketScreenState extends State<ticketScreen> {
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
    // Lista de tickets
    int a = 29;
    return ListView(
      children: [
        for (int i = 1; i < a; i++)
          ListTile(
            title: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6400ab), Color(0xFFbbd80d)],
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
                    offset: const Offset(0, 3), // sombra hacia abajo
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Text(
                    'Título ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold, // Añadido para mejor visibilidad
                    ),
                  ),
                  Text(
                    'Estado: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70, // Usar un blanco más tenue
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
          )
      ],
    );
  }
}
