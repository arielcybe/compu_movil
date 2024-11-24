import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
              },
            );
          },
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
    );
  }
}
