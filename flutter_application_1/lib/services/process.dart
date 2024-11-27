import 'package:dio/dio.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjM2MjgyNTg2MDExMTNlNjU3NmE0NTMzNzM2NWZlOGI4OTczZDE2NzEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTE0OTE0MTI3MjE4MjU0MzI1MDciLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNyaXN0b2JhbC5hbGVncmlhc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJLVDZTel9JNUZWbGlXaUlIM2pwdkxnIiwibmFtZSI6IkNyaXN0b2JhbCBBbGVncmlhIFNhbiBNYXJ0aW4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jTDJGNlIyZWVEMlE1QmpDSlp2M1plQms2aHYwQ2ZpbDVaeTlpc1RFcE9Qc0hpT3ZnPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkNyaXN0b2JhbCIsImZhbWlseV9uYW1lIjoiQWxlZ3JpYSBTYW4gTWFydGluIiwiaWF0IjoxNzMyNjc2NjUwLCJleHAiOjE3MzI2ODAyNTB9.OD86bq0YBaQ5hsJGLh_9zo4JNVrHKD5s3lz0COxhhbcaMYcXlFF82zHsL-8fdNVVY0qCegoPjV2_QEFP7V-ua75VLQYYr6QA15jbnJKsnbuC9AqcmvChqQQDuDvVbMtoxml7-540B41lb3iIZOszlSiqezNafiOF2SN_YedY1rsMHWM-B5hkhzQrFES_tfgphiszJ8mKGkd7NfAZsMnJ17rYvr45EwEQCXs9WMeVjBjFyVcukGVUQj9GxRdwUn6xDWH2pVIFuDe11UL9qnSxljdpjQcW6t7cVJbkMPgQvVIXgMguPlU91bpNKWexB90wPUnCxvh9QPdv-BpkP7pLuQ';

// Clase Category
class Category {
  final String token;
  final String name;
  final String description;

  Category({
    required this.token,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      token: json['token'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

// Clase Ticket
class Ticket {
  final String type;
  final String subject;
  final String message;
  final String status;
  final String created;

  Ticket({
    required this.type,
    required this.subject,
    required this.message,
    required this.status,
    required this.created,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      type: json['type'] ?? 'Desconocido',
      subject: json['subject'] ?? 'Sin asunto',
      message: json['message'] ?? 'Sin detalles',
      status: json['status'] ?? 'Desconocido',
      created: json['created'] ?? 'Sin fecha',
    );
  }
}

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  ),
);

// Obtener tickets
Future<List<Ticket>> fetchTicketsFromApi({
  required String categoryToken,
  String type = 'ALL',
  String status = '',
}) async {
  try {
    print(
        'Solicitando tickets para categoría: $categoryToken, tipo: $type, estado: $status');

    final response = await dio.get(
      '/v1/icso/$categoryToken/tickets',
      queryParameters: {
        'type': type,
        'status': status,
      },
    );

    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> data = response.data;
      return data.map((json) => Ticket.fromJson(json)).toList();
    }
    print(
        'Respuesta inesperada: ${response.statusCode}, ${response.data}');
    return [];
  } catch (e) {
    print('Error al obtener tickets: $e');
    return [];
  }
}

// Obtener categorías
Future<List<Category>> fetchCategoriesFromApi() async {
  try {
    final response = await dio.get('/v1/info/categories');
    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    }
    return [];
  } catch (e) {
    print('Error al obtener categorías: $e');
    return [];
  }
}

// Crear ticket
Future<void> createTicket({
  required String categoryToken,
  required String type,
  required String subject,
  required String message,
}) async {
  try {
    final response = await dio.post(
      '/v1/icso/$categoryToken/ticket',
      data: {
        'type': type,
        'subject': subject,
        'message': message,
      },
    );
    if (response.statusCode == 201) {
      print('Ticket creado con éxito');
    }
  } catch (e) {
    print('Error al crear ticket: $e');
  }
}
