import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('프로필'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[200]!, width: 1),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuB5XozjG5UqAoIiq8pgx3n6xNTqcECxj-ZYATwZjovEAhB6pL9LcfujDdbHMG9krPtFuJoIZgYYlvtPcyhnVpxp_3ZZwIr8zqvyO6GtbPld96UCOzRGKG9G03iBI80oR1tzWcM5F8_yWK8t9a59SLyg_zhvRXgkRPkReZ_FnCok10S3ShvDKYSXoqpf3eoPVkx50jryV8sXRHKbW9lPiPz7fwLA-m65ff4ywZRKYHrTSbDAGKW3F-gQQJNN2-0twUGxGO69WPsccsw'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '김민수',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'minsu.kim@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: BorderSide(color: Colors.grey[200]!),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('프로필 편집',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Row(
                  children: const [
                    _StatItem(label: '포인트', value: '1,250 P'),
                    _VerticalDivider(),
                    _StatItem(label: '쿠폰', value: '3'),
                    _VerticalDivider(),
                    _StatItem(label: '작성 후기', value: '12'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            const SizedBox(height: 32),
            // Recent Orders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '최근 주문 내역',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
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
            const _OrderItem(
              status: '배송 완료',
              date: '2023.10.24',
              title: '프리미엄 가죽 시계 스트랩',
              orderNumber: '#12345',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBBngJtSon_mnChBs7yIYlB-LEf97DIt1UZTvrbqjTNGpP8EiyJggUnxPLpXVJ3k_hE03RUHmhOpTg6QzXtdo_IaEzWfRwG7COx_9Zgd0sTXaVEBX-phZ6fpF0omjwra_axSxVAw6FJUgomVDB0z8FYZu92bvY0nydc93jhwMB6KsvULuyu4c0-Vfw8awnczY7PGKKepBRHco9Jgblz8gKGWsZDMzkD3ETJO6S3ZiNGx5jMGQ0d25Arcos4pYJvPqE5jmKsCjoF4f8',
            ),
            const _OrderItem(
              status: '배송중',
              date: '2023.11.02',
              title: '천연 아로마 디퓨저 세트',
              orderNumber: '#12348',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4ThrOSQiAi7QGPIrU0M-Z5yTjpXd26Tb5ve3iKhdAyMsAkfGIYswNUOOEbsNMcu1G024_rR-GatRu80Mf_bg8NLQamWaW4V6fE95SGlPmNB7ICLSROSieLun2Sp8LZMbspZayx7vrLmXgv3Gy7ZnsevFEhNiRXq_8nOrtp3xldJ7lrWxomcdtny2o3VqcjssHml4bCtJms3cEcqncn-Q95ycJra8jSbi1H8J-KsH-j3kHw3k2IA117eONqr4Lv9jnWw-wND4Z5H0',
              isAccentStatus: true,
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
            const _SettingTile(icon: Icons.notifications_none, title: '알림 설정'),
            const _SettingTile(icon: Icons.location_on_outlined, title: '배송지 관리'),
            const _StattingTile(icon: Icons.credit_card, title: '결제 수단'),
            const _SettingTile(icon: Icons.help_outline, title: '고객센터'),
            const SizedBox(height: 32),
            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () {},
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
              'App Version 2.4.0',
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

  const _SettingTile({required this.icon, required this.title});

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
      onTap: () {},
    );
  }
}

class _StattingTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _StattingTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return _SettingTile(icon: icon, title: title);
  }
}
