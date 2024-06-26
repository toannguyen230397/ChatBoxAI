import 'dart:convert';
import 'package:http/http.dart' as http;
class ChatAPI {
  final String apiURL = 'https://chatboxai-backend.onrender.com/';

  // Stream<Map<String, dynamic>> sendRequest(String msg, List history) async* {
  //   final Uri uri = Uri.parse('${apiURL}geminiAPI');
  //   final request = http.Request('POST', uri)
  //     ..headers['Content-Type'] = 'application/json; charset=UTF-8'
  //     ..body = jsonEncode({
  //       'msg': msg,
  //       'history': history,
  //     });

  //   final streamedResponse = await request.send();

  //   if (streamedResponse.statusCode == 200) {
  //     await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
  //       final Map<String, dynamic> responseData = json.decode(chunk);
  //       yield responseData;
  //       // print(responseData);
  //     }
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