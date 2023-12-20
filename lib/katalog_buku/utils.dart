class Utils {
  static String changeUrl(String url) {
    return url.replaceAll('http://images.amazon.com', 'https://m.media-amazon.com');
  }
}