import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ5NzQwYTcwYjA5NzJkY2NmNzVmYTg4YmM1MjliZDE2YTMwNTczYmQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5NzU3NDY5MzQ1NzY0MzUzNjYiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNwZWRyZXJvc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJaMXdYQ1RKdVhhMVRYaFh0R3pHQUlnIiwibmFtZSI6IkNBTUlMTyBFU1RFQkFOIFBFRFJFUk9TIEpBUkEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSUNwU0o0UWk0WXBhTkctSWJYMWhzam95OEhsdmZZblJ2b3FCeFpxZlQzWHZkLWZqRT1zOTYtYyIsImdpdmVuX25hbWUiOiJDQU1JTE8gRVNURUJBTiIsImZhbWlseV9uYW1lIjoiUEVEUkVST1MgSkFSQSIsImlhdCI6MTczMjIzOTY5MSwiZXhwIjoxNzMyMjQzMjkxfQ.mh1Se0dgBopgeEs4LWJv5MdVPVPsLN6V3BTv7iDS0rgo8RZzxn37KVrZAe8083Q_VGRsYaQC0oacTAPOZcuHSWePa23q7zoWW2_56dQY5hu3S84UrQC1TWEZW4KlBW4RvFX8iTUMObzIXjcsI8dkDOZyVcoC6zTDMUookjECIs2B56z9pG9ae6MaIbOfGTuAUIS2KFD7X99kZxCMpyjBCylz8EroazkF9EPyVCCOLLxbyvfLY9y8qJzYzlHVC1IGDM_T6lDui7i1-uRO8x4x2pV3qrvg8JoAO-12dGzuw7iYh_TGZsOPv50l86HvQ5rGi-m6jG9LGVnRcvBbhJMBOg';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  ),
);

Future<Response<dynamic>?> fetchData() async {
  try {
    final response = await dio.get('/v1/info/types');
    return response;
  } on DioError catch (e) {
    print('Error: ${e.message}');
    print('Response data: ${e.response?.data}');
    print('Status code: ${e.response?.statusCode}');
    return null;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _data = ''; // Variable to store the fetched data

  Future<void> _makeRequest() async {
    final response = await fetchData();
    if (response != null) {
      setState(() {
        _data = jsonDecode(response.data); // Decode JSON data
      });
    } else {
      print('Error fetching data');
      // Show a snackbar or other UI element to inform the user of the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Data from API:'),
            Text(_data), // Display the fetched data
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _makeRequest,
        tooltip: 'Fetch Data',
        child: const Icon(Icons.download),
      ),
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
      home: const MyHomePage(title: 'Flutter API Demo'),
    );
  }
}