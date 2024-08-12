import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatGptService {

  Future<String> getFoodImageAnalysis(String imageURL) async{

    String result = await ChatGptService().getImageDescription(
      '''Please provide the nutritional information of the food picture
      in JSON format with the following structure:
        {
          "nutrition": {
            "calories": "200",
            "protein": "10g",
            "fat": "8g",
            "carbohydrates": "30g"
          },
          "description": "A healthy salad containing fresh vegetables and chicken.",
          "ingredients": "Tomato, Lettuce, Chicken Breast"
        }
      Please try to identify even if you are 75% sure.
      Please do not use we, us, I.
      Please provide the nutrition information in English only. 
      Avoid using asterisks or any special characters. 
      If it is not food or you can not identify please respond
      in plain text with a short reason starting with "Error: ...".
      Please do not ask for response back.''',
      imageURL
    );

    return result;
  }

  Future<String> getImageDescription(String query, String imageURL) async {
    try{
      final apiKey = dotenv.env['chatGPTKey']!;
      const url = 'https://api.openai.com/v1/chat/completions';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      final body = jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text', 
                'text': query
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': imageURL,
                },
              },
            ],
          }
        ],
        'max_tokens': 300,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('choices') &&
        data['choices'] is List &&
        data['choices'].isNotEmpty &&
        data['choices'][0].containsKey('message') &&
        data['choices'][0]['message'].containsKey('content')) {
          return data['choices'][0]['message']['content'].toString();
        } else {
          return 'Error: Invalid response structure.';
        }
      } else {
        return 'Error: Request failed with status: ${response.statusCode}.';
      }
    }catch(e) {
      return 'Error: $e.';
    }
  }
}