import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchClimateNews() async {
  final apiKey = 'a9fd201205f0ea3bdf6cf39381e23cb7';
  final url = Uri.parse(
    'https://gnews.io/api/v4/search?q=("climate change" OR climate) AND (flood OR drought OR wildfire OR hurricane OR cyclone OR disaster) AND (policy OR agreement OR summit OR treaty OR conflict OR geopolitics)&lang=en&max=30&token=$apiKey',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['articles']; // List of articles limited to 30
  } else {
    throw Exception('Failed to fetch news');
  }
}
