import 'package:dio/dio.dart';

const String baseUrl = 'https://api.sebastian.cl/oirs-utem';
const String accessToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ5NzQwYTcwYjA5NzJkY2NmNzVmYTg4YmM1MjliZDE2YTMwNTczYmQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5NzU3NDY5MzQ1NzY0MzUzNjYiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNwZWRyZXJvc0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJyRkt4bXctS0J6ajFmRDZ6RGxYZjBnIiwibmFtZSI6IkNBTUlMTyBFU1RFQkFOIFBFRFJFUk9TIEpBUkEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSUNwU0o0UWk0WXBhTkctSWJYMWhzam95OEhsdmZZblJ2b3FCeFpxZlQzWHZkLWZqRT1zOTYtYyIsImdpdmVuX25hbWUiOiJDQU1JTE8gRVNURUJBTiIsImZhbWlseV9uYW1lIjoiUEVEUkVST1MgSkFSQSIsImlhdCI6MTczMjUxMDE3MywiZXhwIjoxNzMyNTEzNzczfQ.NMq9trTN3Mnl5Ks493TfYTUsraBEqbjLJ-NncyKwYhy07cXf8-r7DNzuiyVPJUw0EKB3MxJeER5YK0_3DIFDBubTfWcItM__voY9fO8HXWRet7T1zcgKiDt47pkuIEgRZ-EdNDfzAtBEXnMpGyH-1i54nq3Jjzep82DjC8EPVKa8U4WNh_IqIjceq8tb3izeaoTro1ADDVtcrE4DwdPqnZNpnJR2_K36uPcVH_XvaV07N2IKLvmRjjOlgKora1xmBbM8J-kMFvf9w2GWbSWGIS7cgp3XfnPAUXY3zgc7ECqLn72YbXVCaJmDlPUmT6CdVuLikiRB1lMeAmfz0qVJ2w';

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
