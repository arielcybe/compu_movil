import 'package:dio/dio.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjM2MjgyNTg2MDExMTNlNjU3NmE0NTMzNzM2NWZlOGI4OTczZDE2NzEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5NzU3NDY5MzQ1NzY0MzUzNjYiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNwZWRyZXJvc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJzREhsZzhOZjlMdUNKNkhobWdUTktnIiwibmFtZSI6IkNBTUlMTyBFU1RFQkFOIFBFRFJFUk9TIEpBUkEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSUNwU0o0UWk0WXBhTkctSWJYMWhzam95OEhsdmZZblJ2b3FCeFpxZlQzWHZkLWZqRT1zOTYtYyIsImdpdmVuX25hbWUiOiJDQU1JTE8gRVNURUJBTiIsImZhbWlseV9uYW1lIjoiUEVEUkVST1MgSkFSQSIsImlhdCI6MTczMjk4NTI3NiwiZXhwIjoxNzMyOTg4ODc2fQ.jMzfrj-Km64A_-NGKkqZc6E8Da1VS2Une1cpTqQ_-Fd7RLsgPF1znp6XhDxOExeDsJKosjgrX4aXDCrCvBPpMaqokihk4z6tWsjMjYIJ6ZW3QrcEODopL2AnXGLrPxH0HTBoG52Y6ys8YmZDMajDir8LeDgP7dH5l7VSit-EY1PABFIVDu2tzQM-8P10edktxO_ZXwd3PZkjCcv9gUOLgN56zpaFhdODKzLaEwiRDhQtsRX4g-Wr6r5VadGbe3nL6zrawCS5evFLtUm0E-T1ICgp-e44hfeCB3dMbBe49CWYzS1NXjU6Cvg7utFzZoETXXgNnpet6uu0QnMQ2yYgFw';

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
