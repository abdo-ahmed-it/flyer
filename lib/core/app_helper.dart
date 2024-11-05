class AppHelper{
 static String toClassName(String input) {
    return input.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }
}