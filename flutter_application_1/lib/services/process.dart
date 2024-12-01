import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:mime/mime.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
String accessToken = '';

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

class RequirementType {
  final String name;

  RequirementType({required this.name});

  factory RequirementType.fromJson(String json) {
    return RequirementType(name: json);
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

Future<List<RequirementType>?> fetchRequirementsFromApi() async {
  try {
    final response = await dio.get('/v1/info/types');
    final List<dynamic> data = response.data;
    return data.map((json) => RequirementType.fromJson(json)).toList();
  } on DioError catch (e) {
    print('Error: ${e.message}');
    print('Response data: ${e.response?.data}');
    print('Status code: ${e.response?.statusCode}');
    return null;
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
Future<String?> createTicket({
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
      var ticketToken = response.data['token'];
      print('Ticket creado con éxito. Token: $ticketToken');
      return ticketToken;
    } else {
      print('Error al crear ticket. Código de estado: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error al crear ticket: $e');
  }
  return null;
}

Future<void> attachFile({
  required String ticketToken,
  required File file,
}) async {
  try {
    String fileName = file.uri.pathSegments.last;
    String? mimeType = lookupMimeType(fileName);
    if (mimeType == null) {
      print('No se pudo obtener el tipo MIME para el archivo.');
      return;
    }
    List<int> fileBytes = await file.readAsBytes();
    String fileData = base64Encode(fileBytes);
    final response = await dio.post(
      '/v1/attachments/$ticketToken/upload',
      data: {
        'name': fileName,
        'mime': mimeType,
        'data': fileData,
      },
    );
    if (response.statusCode == 200) {
      var attToken = response.data['token'];
      print('Archivo adjuntado con éxito: Token: $attToken');
    }
  } catch (e) {
    print('Error al adjuntar el archivo: $e');
  }
}

Future<bool> credentialIsReal({required String credential}) async {
  try {
    accessToken = credential;
    final response = await dio.get('/v1/info/types');
    final List<dynamic> data = response.data;
    if (data != null && data.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on DioError catch (e) {
    print('Error: ${e.message}');
    print('Response data: ${e.response?.data}');
    print('Status code: ${e.response?.statusCode}');
    return false; // En caso de error, retornamos false
  }
}