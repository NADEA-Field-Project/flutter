import 'package:flutter/material.dart';

class MenuDetailScreen extends StatelessWidget {
  const MenuDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, size: 32),
                ),
                const Text(
                  '메뉴 상세',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDm6mIx0fs99Oua6sn3tJGFTtRKlkEO4-jr0mJQzRr5vXc3lWzMhaaS8R-6ic0tczSQX-znCUl1X4QG7HGMsYIJ-G3rXZoqAry9L5vfx-DdqZTKWFem1A4Yi8ZZJ3X27DwBUHxcv8J9fxAUSyjM7vhGEM8oVSNYZDH5WpZQnkbcVdmi70gxIQ8F-0OGIksIM6uGB87NQP2I6Y_7rkpKp3ZTHB4JoDB0uaPTCm5audamNYXgJka7QVag_g1083b7NmKkWViDYh7nL04'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '클래식 치즈버거',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '₩8,900',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '두툼한 소고기 패티와 고소한 체다 치즈, 신선한 양상추와 토마토가 어우러진 버거 조인트의 시그니처 메뉴입니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            // Mandatory Option: Patty
            const _OptionSection(
              title: '패티 선택',
              isMandatory: true,
              children: [
                _RadioOption(label: '싱글 패티', price: '₩0', isSelected: true),
                _RadioOption(label: '더블 패티', price: '+₩3,500'),
              ],
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            // Optional: Cheese
            const _OptionSection(
              title: '치즈 추가',
              isMandatory: false,
              children: [
                _CheckOption(label: '체다 치즈', price: '+₩1,000'),
                _CheckOption(label: '스위스 치즈', price: '+₩1,200'),
              ],
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            // Optional: Exclude
            const _OptionSection(
              title: '재료 제외',
              isMandatory: false,
              children: [
                _CheckOption(label: '양파 제외', price: '₩0'),
                _CheckOption(label: '피클 제외', price: '₩0'),
                _CheckOption(label: '토마토 제외', price: '₩0'),
              ],
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            // Quantity
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('수량', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _QuantityBtn(icon: Icons.remove),
                        const SizedBox(width: 16),
                        const Text('1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        _QuantityBtn(icon: Icons.add),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[100]!)),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('장바구니에 담기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('₩8,900', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionSection extends StatelessWidget {
  final String title;
  final bool isMandatory;
  final List<Widget> children;

  const _OptionSection({
    required this.title,
    required this.isMandatory,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isMandatory ? '필수' : '선택',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final String price;
  final bool isSelected;

  const _RadioOption({required this.label, required this.price, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                    width: isSelected ? 6 : 2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckOption extends StatelessWidget {
  final String label;
  final String price;
  final bool isSelected;

  const _CheckOption({required this.label, required this.price, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: isSelected ? const Icon(Icons.check, size: 14) : null,
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            price,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _QuantityBtn extends StatelessWidget {
  final IconData icon;
  const _QuantityBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ]),
      child: Icon(icon, size: 18),
    );
  }
}
