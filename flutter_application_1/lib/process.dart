import 'package:dio/dio.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ5NzQwYTcwYjA5NzJkY2NmNzVmYTg4YmM1MjliZDE2YTMwNTczYmQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5NzU3NDY5MzQ1NzY0MzUzNjYiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNwZWRyZXJvc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiItckVsTmw3RnN5bnpRc01SaG5SZWRBIiwibmFtZSI6IkNBTUlMTyBFU1RFQkFOIFBFRFJFUk9TIEpBUkEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSUNwU0o0UWk0WXBhTkctSWJYMWhzam95OEhsdmZZblJ2b3FCeFpxZlQzWHZkLWZqRT1zOTYtYyIsImdpdmVuX25hbWUiOiJDQU1JTE8gRVNURUJBTiIsImZhbWlseV9uYW1lIjoiUEVEUkVST1MgSkFSQSIsImlhdCI6MTczMjU4Mzc4MywiZXhwIjoxNzMyNTg3MzgzfQ.ntKqJNA6w9-06I5KUFnwRggv0s_e1GhNVekqFPGH2Za7xXGs7vOg8LvgmC7Fpg0ErmtmxKpS5kj5MtBTyUo5XPl4xAwCO13un58Iw4_6V9pdvv9znT9iFN8FuaNqBXGNNCfIhPpGhLkQG4bhEQ60aa8WYLT81fjsxGrCqwNRZ2Kmo7J4E981iv7q0SyzGjQjH8YGeyqxEDTlvYCSMZxTWeJq6_vQfP6dQS2qzoDcWvA6c29u8pUiB16POM4K5Dj5N8h-65boHjmPCc7tMCIiZub0paln0r2VBxZHvmzLb6FKZKA_2PmEX0KLhjKFNDpPrGAqq8keKHn1bjZll_wGcQ';

class Category {
  final String token;
  final String name;
  final String description;

  Category({required this.token, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      token: json['token'],
      name: json['name'],
      description: json['description'],
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

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  ),
);

Future<List<Category>?> fetchCategories() async {
  try{
    final response = await dio.get('/v1/info/categories');
    final List<dynamic> data = response.data;
    return data.map((json) => Category.fromJson(json)).toList();
  } on DioError catch (e) {
    print('Error: ${e.message}');
    print('Response data: ${e.response?.data}');
    print('Status code: ${e.response?.statusCode}');
    return null;
  }
}

Future<List<RequirementType>?> fetchRequirements() async {
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

Future<void> createTicket({
  required String categoryToken,
  required String type,
  required String subject,
  required String message,
}) async {
  try {

    final Map<String, dynamic> body = {
      "type": type,
      "subject": subject,
      "message": message,
    };

    final response = await dio.post(
      '/v1/icso/$categoryToken/ticket',
      data: body,
    );

    if (response.statusCode == 201) {
      print('Ticket creado exitosamente: ${response.data}');
    } else {
      print('Error al crear el ticket. Código: ${response.statusCode}');
    }
  } on DioError catch (e) {
    print('Error: ${e.message}');
    if (e.response != null) {
      print('Detalles: ${e.response?.data}');
      print('Código de estado: ${e.response?.statusCode}');
    }
  }
}


