import 'package:dio/dio.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ5NzQwYTcwYjA5NzJkY2NmNzVmYTg4YmM1MjliZDE2YTMwNTczYmQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTE0OTE0MTI3MjE4MjU0MzI1MDciLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNyaXN0b2JhbC5hbGVncmlhc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJydWljVFlJSkxWbDBWSGZpdVZsVjNBIiwibmFtZSI6IkNyaXN0b2JhbCBBbGVncmlhIFNhbiBNYXJ0aW4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jTDJGNlIyZWVEMlE1QmpDSlp2M1plQms2aHYwQ2ZpbDVaeTlpc1RFcE9Qc0hpT3ZnPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkNyaXN0b2JhbCIsImZhbWlseV9uYW1lIjoiQWxlZ3JpYSBTYW4gTWFydGluIiwiaWF0IjoxNzMyNTE4Mjg5LCJleHAiOjE3MzI1MjE4ODl9.i_OyVgz3BORVtVKdLM15gkGt1X4YECRcAwkuQ-JUgu5UaFdxl9zwrJkXLjh_L5-QTeeFTqS2SEcioKWvTiSfzyTY659JDFepngzMMhF40CXC3-pmHPVcl2gjFfivPxBOr_WgjYQTuCT-dOXv1F5lTld39U1zamBeftpg7m5pLZaKl48LURq8TNE7_7qWIzoXY1HvAriMAuEz38lXJB4Ot75_HQ-N9MmlVGH5dGFjlPezA1POIAw2Cbki50mQLpZrpE0dzCCn95XUL57PplHWLR42GEEGHiY-Hmz4Tfamy4DhDOT-0WrW_oB57CPN-SfAe1vn5DKp5_LQR4Z3CDeTYA';

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

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  ),
);

Future<List<Category>> fetchCategories() async {
  try {
    final response = await dio.get('/v1/info/categories');
    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Invalid data format from API');
    }
  } on DioError catch (e) {
    print('Error: ${e.message}');
    print('Response data: ${e.response?.data}');
    print('Status code: ${e.response?.statusCode}');
    return [];
  }
}


