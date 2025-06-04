import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:weatherapp/Modal/NEWS.dart';

class NEWSListScreen extends StatefulWidget {
  const NEWSListScreen({super.key});

  @override
  State<NEWSListScreen> createState() => _NEWSListScreenState();
}

class _NEWSListScreenState extends State<NEWSListScreen> {
  late Future<List<NEWS>> _NEWSFuture;

  @override
  void initState() {
    super.initState();
    _NEWSFuture = _fetchNEWS();
  }

  Future<List<NEWS>> _fetchNEWS() async {
    try {
      const apiKey = 'YOUR_GNEWS_API_KEY'; // Replace with your actual API key
      final url = Uri.parse(
        'https://gNEWS.io/api/v4/search?q=climate change&lang=en&max=20&token=$apiKey',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List? ?? [];
        return articles.map((json) => NEWS.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load NEWS');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open article')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Climate NEWS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _NEWSFuture = _fetchNEWS();
          });
        },
        child: FutureBuilder<List<NEWS>>(
          future: _NEWSFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Failed to load NEWS'));
            }
            final NEWSList = snapshot.data ?? [];
            if (NEWSList.isEmpty) {
              return const Center(child: Text('No NEWS available'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: NEWSList.length,
              itemBuilder: (context, index) {
                final NEWS = NEWSList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _openUrl(NEWS.url),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: NEWS.image.isNotEmpty
                                ? Image.network(
                                    NEWS.image,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 40),
                                    ),
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 40),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  NEWS.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NEWS.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}