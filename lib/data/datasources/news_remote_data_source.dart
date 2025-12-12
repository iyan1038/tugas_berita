import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuaca/core/constants/api_constants.dart';
import 'package:cuaca/core/exceptions/news_exceptions.dart';
import 'package:cuaca/data/models/news_model.dart';
import 'dart:developer';

class NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSource({required this.client});

  // Method menggunakan Inshorts API (No API key required)
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      late Uri uri;
      if (category == 'all') {
        uri = Uri.parse(
          '${ApiConstants.newsDataBaseUrl}/news'
          '?apikey=${ApiConstants.newsDataApiKey}'
          '&language=en',
        );
      } else {
        uri = Uri.parse(
          '${ApiConstants.newsDataBaseUrl}/news'
          '?apikey=${ApiConstants.newsDataApiKey}'
          '&category=$category'
          '&language=en',
        );
      }

      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['results'] ?? [];

        return articles
            .map(
              (article) => NewsModel(
                author: article['creator']?.first ?? 'Unknown',
                title: article['title'] ?? 'No Title',
                description: article['description'] ?? 'No Description',
                url: article['link'] ?? '',
                urlToImage: article['image_url'],
                publishedAt:
                    DateTime.tryParse(article['pubDate'] ?? '') ??
                    DateTime.now(),
                content: article['content'] ?? '',
                source: article['source_id'] ?? 'Unknown',
              ),
            )
            .toList();
      } else {
        throw NewsException(
          'Failed to fetch news: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw NewsException('Network error: $e');
    }
  }

  // Method untuk search news (menggunakan NewsData.io)
  Future<List<NewsModel>> searchNews(String query) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.newsDataBaseUrl}/news?apikey=${ApiConstants.newsDataApiKey}&q=$query&language=en',
      );

      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['results'] ?? [];

        return articles
            .map(
              (article) => NewsModel(
                author: article['creator']?.first ?? 'Unknown',
                title: article['title'] ?? 'No Title',
                description: article['description'] ?? 'No Description',
                url: article['link'] ?? '',
                urlToImage: article['image_url'],
                publishedAt: DateTime.parse(article['pubDate']),
                content: article['content'] ?? '',
                source: article['source_id'] ?? 'Unknown',
              ),
            )
            .toList();
      } else {
        throw NewsException(
          'Failed to search news: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw NewsException('Search error: $e');
    }
  }
}
