import 'dart:convert';

import 'package:http/http.dart' as http;

class PostDeviceInfoRepo {
  String message = '';

  Future<String> postData(Map<String, dynamic> data) async {
    String apiUrl =
        'http://devapiv4.dealsdray.com/api/v2/user/device/add'; // Replace with your API endpoint
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      message = data["data"]["message"];
      print('Data posted successfully: ${response.body}');
      return message;
    } else {
      print('Failed to post data: ${response.statusCode}');
      throw Exception('Failed to post data');
    }
  }
}
