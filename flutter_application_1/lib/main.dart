import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'home.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ5NzQwYTcwYjA5NzJkY2NmNzVmYTg4YmM1MjliZDE2YTMwNTczYmQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5NzU3NDY5MzQ1NzY0MzUzNjYiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNwZWRyZXJvc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJfMENPQ1BaQTR4QWlHQUJFTlllcS13IiwibmFtZSI6IkNBTUlMTyBFU1RFQkFOIFBFRFJFUk9TIEpBUkEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSUNwU0o0UWk0WXBhTkctSWJYMWhzam95OEhsdmZZblJ2b3FCeFpxZlQzWHZkLWZqRT1zOTYtYyIsImdpdmVuX25hbWUiOiJDQU1JTE8gRVNURUJBTiIsImZhbWlseV9uYW1lIjoiUEVEUkVST1MgSkFSQSIsImlhdCI6MTczMjI1MTY2MywiZXhwIjoxNzMyMjU1MjYzfQ.V_dIxPRYi-SAKRgv9wSztgUKnivbUEPrYJkyThz0cIf6c9i-XNvoTtyRoCxoD6O_wFoGTdtd9bMroZGYblDvOFg1VAJadd1j4OsuCnDDJyhlVRM6KTdsOi3IZITFCSMedb-3qeNDo9jtevsbI-k_OPauMf1L5p8PiHf0rWLpBVYMfFEU9gO4pCtrJq_DHVTXGSTe_w7scQwGu3L_3Z51gdbIAR9FchkSHru44gQvg_8EyomZNEVgX7sx0fl-4W0v8LsTS7K34Bypkdm8HHl2rF4KelQX2bKE1P_IDjtH5tmyJNnHzQdr6_k3ugTZTV_g00lqkejjriH_26sKZKZtvA';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $accessToken',
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
        // Si response.data es una lista o un mapa, conviértelo a String
        _data = response.data is String
            ? response.data
            : jsonEncode(response.data); // Convierte objetos a JSON String
      });
    } else {
      print('Error fetching data');
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
            const Text('Data from API:'),
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
      // home: const MyHomePage(title: 'Flutter API Demo'),
      home: HomePage(),
    );
  }
}