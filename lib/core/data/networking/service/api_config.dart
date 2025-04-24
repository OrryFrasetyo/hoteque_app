class ApiConfig {
  static const String baseUrl = "http://192.168.80.233:3000";
  static const String apiUrl = "$baseUrl/api";
  
  // Helper untuk mengonversi path relatif menjadi URL lengkap
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return ""; // or return a default image URL
    }
    
    // Jika path sudah berupa URL lengkap (dimulai dengan http)
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    
    // Jika path adalah jalur relatif, tambahkan base URL
    return "$baseUrl$imagePath";
  }
}