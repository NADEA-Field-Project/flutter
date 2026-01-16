import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    }
    return 'http://localhost:3000/api/v1';
  }
  
  static String get hostUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }
  
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
    return '$hostUrl$_userImageUrl';
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

  Future<Map<String, dynamic>> getUserInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load user info');
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

  Future<Map<String, dynamic>> updateProfile(String username, String phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/me'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': username,
        'phone': phone,
      }),
    );
    
    final result = jsonDecode(response.body);
    if (response.statusCode == 200 && result['success'] == true) {
      _userName = username;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', username);
    }
    return result;
  }

  Future<Map<String, dynamic>> updateProfileImageUrl(String imageUrl) async {
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

  // Addresses
  Future<List<dynamic>> getAddresses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/addresses'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<Map<String, dynamic>> addAddress({
    required String receiverName,
    required String phone,
    required String addressLine1,
    String? addressLine2,
    bool isDefault = false,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addresses'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'receiver_name': receiverName,
        'phone': phone,
        'address_line1': addressLine1,
        'address_line2': addressLine2,
        'is_default': isDefault,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteAddress(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/addresses/$id'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> setDefaultAddress(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/addresses/$id/default'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Payment Methods
  Future<List<dynamic>> getPaymentMethods() async {
    final response = await http.get(
      Uri.parse('$baseUrl/payment-methods'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<Map<String, dynamic>> addPaymentMethod({
    required String cardName,
    required String cardNumber,
    required String cardType,
    bool isDefault = false,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payment-methods'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'card_name': cardName,
        'card_number': cardNumber,
        'card_type': cardType,
        'is_default': isDefault,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deletePaymentMethod(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/payment-methods/$id'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> setDefaultPaymentMethod(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/payment-methods/$id/default'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<int> getCartCount() async {
    try {
      final cart = await getCart();
      final items = cart['items'] as List<dynamic>?;
      return items?.length ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Favorites
  Future<List<dynamic>> getFavorites() async {
    final response = await http.get(
      Uri.parse('$baseUrl/favorites'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['favorites'] ?? [];
    }
    return [];
  }

  Future<Map<String, dynamic>> toggleFavorite(int productId) async {
    print('Requesting Toggle Favorite for product: $productId');
    final response = await http.post(
      Uri.parse('$baseUrl/favorites/toggle'),
      headers: await _getHeaders(),
      body: jsonEncode({'productId': productId}),
    );
    print('Toggle Favorite Response: ${response.statusCode} - ${response.body}');
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getTrendingFavorites() async {
    final response = await http.get(
      Uri.parse('$baseUrl/favorites/trending'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['trending'] ?? [];
    }
    return [];
  }

  Future<List<dynamic>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?q=${Uri.encodeComponent(query)}'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
