import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/v1';
  
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  String? _userName;
  String? _userEmail;
  String? _userImageUrl;
  int? _userId;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userName = prefs.getString('user_name');
    _userEmail = prefs.getString('user_email');
    _userImageUrl = prefs.getString('user_image_url');
    _userId = prefs.getInt('user_id');
  }

  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userImageUrl {
    if (_userImageUrl == null) return null;
    if (_userImageUrl!.startsWith('http')) return _userImageUrl;
    return 'http://localhost:3000$_userImageUrl';
  }
  bool get isLoggedIn => _token != null;

  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Auth
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      _token = data['token'];
      _userName = data['user']['name'];
      _userEmail = data['user']['email'];
      _userImageUrl = data['user']['image'];
      _userId = data['user']['id'];

      await prefs.setString('auth_token', _token!);
      await prefs.setString('user_name', _userName!);
      await prefs.setString('user_email', _userEmail!);
      if (_userImageUrl != null) await prefs.setString('user_image_url', _userImageUrl!);
      await prefs.setInt('user_id', _userId!);
    }
    return data;
  }

  Future<Map<String, dynamic>> signUp(String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_image_url');
    await prefs.remove('user_id');
    
    _token = null;
    _userName = null;
    _userEmail = null;
    _userImageUrl = null;
    _userId = null;
  }

  Future<Map<String, dynamic>> updateProfileImage(String imageUrl) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/me/profile-image'),
      headers: await _getHeaders(),
      body: jsonEncode({'image_url': imageUrl}),
    );
    
    final result = jsonDecode(response.body);
    if (response.statusCode == 200 && result['success'] == true) {
      _userImageUrl = imageUrl;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_image_url', imageUrl);
    }
    return result;
  }

  Future<Map<String, dynamic>> uploadProfileImage(List<int> bytes, String fileName) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/users/me/upload-profile-image'),
    );
    
    request.headers.addAll(await _getHeaders());
    
    // Determine content type
    final ext = p.extension(fileName).toLowerCase().replaceAll('.', '');
    String mimeType = 'image/jpeg';
    if (ext == 'png') mimeType = 'image/png';
    else if (ext == 'webp') mimeType = 'image/webp';
    else if (ext == 'gif') mimeType = 'image/gif';

    request.files.add(http.MultipartFile.fromBytes(
      'image',
      bytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    final result = jsonDecode(response.body);
    if (response.statusCode == 200 && result['success'] == true) {
      _userImageUrl = result['image_url'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_image_url', _userImageUrl!);
    }
    return result;
  }

  // Categories & Products
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<List<dynamic>> getProducts({int? categoryId}) async {
    String url = '$baseUrl/products';
    if (categoryId != null) {
      url += '?category_id=$categoryId';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // Cart
  Future<Map<String, dynamic>> getCart() async {
    final response = await http.get(
      Uri.parse('$baseUrl/carts'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addToCart(int productId, int quantity, Map<String, dynamic> options) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts/items'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'productId': productId,
        'quantity': quantity,
        'options': options,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> removeFromCart(int itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/carts/items/$itemId'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateCartItemQuantity(int itemId, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/carts/items/$itemId'),
      headers: await _getHeaders(),
      body: jsonEncode({'quantity': quantity}),
    );
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<Map<String, dynamic>> placeOrder({
    required String address,
    required String contact,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'address': address,
        'contact': contact,
        'paymentMethod': paymentMethod,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> reorder(String orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts/reorder'),
      headers: await _getHeaders(),
      body: jsonEncode({'orderId': orderId}),
    );
    return jsonDecode(response.body);
  }
}
