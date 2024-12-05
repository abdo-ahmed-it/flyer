class AppHelper {
  static String toClassName(String input) {
    if (input.contains('_')) {
      return input.split('_').map((word) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join('');
    }

    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  static String toFileName(String className) {
    final snakeCase = className.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match match) => '${match.group(1)}_${match.group(2)}',
    );
    return snakeCase.toLowerCase();
  }
}
