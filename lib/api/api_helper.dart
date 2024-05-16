import 'dart:convert';
import 'package:http/http.dart' as http;
class ChatAPI {
  final String apiURL = 'http://192.168.1.4:3000/';

  // Future<List<Map<String, dynamic>>> sendRequest(String msg, List history) async {
  //   final response = await http.post(
  //     Uri.parse('${apiURL}testAPI'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode({
  //       'msg': msg,
  //       'history': history
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final List<Map<String, dynamic>> responseData = json.decode(response.body);
  //     return responseData;
  //   } else {
  //     throw Exception('Failed to post data');
  //   }
  // }

  Future<Map<String, dynamic>> sendRequest(String msg, List history) async {
    final response = await http.post(
      Uri.parse('${apiURL}geminiAPI'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'msg': msg,
        'history': history
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to post data');
    }
  }
}