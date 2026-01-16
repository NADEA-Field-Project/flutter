import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../login_screen.dart';
import 'order_list_screen.dart';
import 'address_screen.dart';
import 'payment_method_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  String _userName = '사용자';
  String _userEmail = '';
  String _userImageUrl = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde';
  String _userPhone = '';
  List<dynamic> _recentOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _fetchOrders();
  }

  // To refresh when screen is appearing (e.g. after navigating back or switching tabs)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchOrders();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await _apiService.getUserInfo();
      setState(() {
        _userName = userInfo['username'] ?? '사용자';
        _userEmail = userInfo['email'] ?? '';
        _userImageUrl = userInfo['image_url'] ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde';
        _userPhone = userInfo['phone'] ?? '';
      });
    } catch (e) {
      setState(() {
        _userName = _apiService.userName ?? '사용자';
        _userEmail = _apiService.userEmail ?? '';
        _userImageUrl = _apiService.userImageUrl ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde';
      });
    }
  }

  Future<void> _handleChangeProfileImage() async {
    _showUrlInputDialog();
  }

  Future<void> _showUrlInputDialog() async {
    final TextEditingController urlController = TextEditingController(text: _userImageUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이미지 URL 입력'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            hintText: 'https://example.com/image.jpg',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = urlController.text.trim();
              if (url.isEmpty) return;
              Navigator.pop(context);
              
              setState(() => _isLoading = true);
              try {
                final result = await _apiService.updateProfileImageUrl(url);
                if (mounted) {
                  if (result['success'] == true) {
                    setState(() {
                      _userImageUrl = url;
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('프로필 이미지가 변경되었습니다.')),
                    );
                  } else {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message'] ?? '업데이트 실패')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('오류 발생: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProfileDialog() async {
    final TextEditingController nameController = TextEditingController(text: _userName);
    final TextEditingController phoneController = TextEditingController(text: _userPhone);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '사용자 이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: '전화번호',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context);
              
              setState(() => _isLoading = true);
              try {
                final result = await _apiService.updateProfile(name, phone);
                if (mounted) {
                  if (result['success'] == true) {
                    setState(() {
                      _userName = name;
                      _userPhone = phone;
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('프로필 정보가 수정되었습니다.')),
                    );
                  } else {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message'] ?? '수정 실패')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('오류 발생: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await _apiService.getOrders();
      if (mounted) {
        setState(() {
          _recentOrders = orders.take(2).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    await _apiService.logout();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile Header
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _handleChangeProfileImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            image: DecorationImage(
                              image: NetworkImage(_userImageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Recent Orders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '최근 주문 내역',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderListScreen()),
                      );
                    },
                    child: Row(
                      children: const [
                        Text('더보기', style: TextStyle(color: Colors.grey)),
                        Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Colors.black),
                  ))
                : _recentOrders.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('최근 주문 내역이 없습니다.'),
                      )
                    : Column(
                        children: _recentOrders.map((order) {
                          return _OrderItem(
                            status: order['status'] ?? '주문완료',
                            date: order['created_at'].toString().split('T')[0],
                            title: '주문 #${order['id']}',
                            orderNumber: order['id'].toString(),
                            imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
                          );
                        }).toList(),
                      ),
            const SizedBox(height: 32),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            const SizedBox(height: 32),
            // Settings List
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '설정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _SettingTile(
              icon: Icons.person_outline,
              title: '프로필 정보 수정',
              onTapOverride: _showEditProfileDialog,
            ),
            const _SettingTile(icon: Icons.credit_card_outlined, title: '결제 수단'),
            const _SettingTile(icon: Icons.location_on_outlined, title: '배송지 관리'),
            const _SettingTile(icon: Icons.help_outline, title: '고객센터'),
            const SizedBox(height: 32),
            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: _handleLogout,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout, size: 18, color: Colors.black),
                    SizedBox(width: 8),
                    Text('로그아웃', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'App Version 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 24, color: Colors.grey[100]);
  }
}

class _OrderItem extends StatelessWidget {
  final String status;
  final String date;
  final String title;
  final String orderNumber;
  final String imageUrl;
  final bool isAccentStatus;

  const _OrderItem({
    required this.status,
    required this.date,
    required this.title,
    required this.orderNumber,
    required this.imageUrl,
    this.isAccentStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isAccentStatus ? Colors.orange : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 3, height: 3, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(date, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text('주문번호 $orderNumber', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTapOverride;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.onTapOverride,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: () {
        if (onTapOverride != null) {
          onTapOverride!();
          return;
        }
        
        if (title == '배송지 관리') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddressScreen()),
          );
        } else if (title == '결제 수단') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentMethodScreen()),
          );
        }
      },
    );
  }
}

// End of ProfileScreen.dart
