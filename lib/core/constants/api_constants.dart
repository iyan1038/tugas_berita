class ApiConstants {
  // NewsData.io API (Free tier - dapatkan API key dari newsdata.io)
  static const String newsDataBaseUrl = 'https://newsdata.io/api/1';
  static const String newsDataApiKey =
      'pub_b2d0bbfaf015497da813fcdbb1f0d487'; // Daftar gratis

  // Alternatif: Inshorts API (No API key required)
  static const String inshortsBaseUrl = 'https://apnews.com/';

  // Currents API (Free tier - dapatkan API key dari currentsapi.services)
  static const String currentsBaseUrl = 'https://api.currentsapi.services/v1';
  static const String currentsApiKey =
      '6YgEdGvXKnJRcAPEcKgtjHatITldl195JcScC756McXRwx1l';
}

class AppConstants {
  static const String appName = 'News Reader';
  static const String defaultCountry = 'id';
  static const List<String> categories = [
    'all',
    'national',
    'business',
    'sports',
    'world',
    'politics',
    'technology',
    'startup',
    'entertainment',
    'science',
    'automobile',
  ];
}
