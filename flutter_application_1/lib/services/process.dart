import 'package:dio/dio.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjM2MjgyNTg2MDExMTNlNjU3NmE0NTMzNzM2NWZlOGI4OTczZDE2NzEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTE0OTE0MTI3MjE4MjU0MzI1MDciLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNyaXN0b2JhbC5hbGVncmlhc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJGeERjU295cFF1ZVR3NVJEdFc3Yi1nIiwibmFtZSI6IkNyaXN0b2JhbCBBbGVncmlhIFNhbiBNYXJ0aW4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jTDJGNlIyZWVEMlE1QmpDSlp2M1plQms2aHYwQ2ZpbDVaeTlpc1RFcE9Qc0hpT3ZnPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkNyaXN0b2JhbCIsImZhbWlseV9uYW1lIjoiQWxlZ3JpYSBTYW4gTWFydGluIiwiaWF0IjoxNzMyNjYxNzY5LCJleHAiOjE3MzI2NjUzNjl9.dggP_v3hSQzjTZ8w1CvWOXHr1ims929irOZvWlltU3V6XvnYH3iAk_guwR3qJSyi-E4H0w0juX5WIFpIVf7KkRs1xfg7VnPQAN2CCMqkDmmlwa4HP2BhFX1GyyLFWTql1y8GKMu_1WzJz46pT-M7KNh9IM9rJ4MzDrQOihL_8KhdRfEDJs5IkTuYNe2xK5GbXg7nNxL_Gkx0bRq06HTLfTbKv7H9EZTve5Btk771fL1dvFh6lCEShEoAApGOLF9hGWoB6gx7EbkpzUHPQWQx2q4dSBVojzFxsA5HRPYA2LXRavka_vu9Ku1s8i9wrSiB9kFMDFijAwfiKcYHPLdYyw';
class Category {
  final String token;
  final String name;
  final String description;

  Category({required this.token, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      token: json['token'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Ticket {
  final String token;
  final String type;
  final String subject;
  final String status;

  Ticket({
    required this.token,
    required this.type,
    required this.subject,
    required this.status,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      token: json['token'] ?? '',
      type: json['type'] ?? '',
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
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

Future<List<Ticket>> fetchTicketsFromApi(String categoryToken) async {
  try {
    final response = await dio.get('/v1/icso/$categoryToken/tickets');
    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> data = response.data;
      return data.map((json) => Ticket.fromJson(json)).toList();
    }
    return [];
  } catch (e) {
    print('Error al obtener tickets: $e');
    return [];
  }
}

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
