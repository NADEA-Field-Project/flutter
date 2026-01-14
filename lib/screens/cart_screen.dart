import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('장바구니'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('전체 삭제', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  _CartItem(
                    title: '더블 치즈버거 세트',
                    options: '사이드: 감자튀김, 음료: 콜라',
                    price: '9,500원',
                    quantity: 1,
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAaAKd7cFEgwdEK5Pj6oShMDY208TUT6mAAVBRQAPY8UradpelSjTotgBgyeOBcOZjHjwq0du3Y6oJGyF95DPwCzhGhVrt5QU8plBdp49DrVwUkvoMHBUYNPMy60CZ-EVuVvhH9VN5rwG1DPL_hq7sPGqpkblW3yURtUUhxP45bmxQOLwtSoK58qbEQ3rZDTv8L-osQwD6D_ssmWsLkS-hV1xrX5tGEFcsK8-MtVPP7ibE83pTjhl6JlqnrIJBVqrqWhdydtXfSEbc',
                  ),
                  SizedBox(height: 24),
                  _CartItem(
                    title: '페퍼로니 피자 (M)',
                    options: '토핑 추가: 올리브, 치즈 크러스트',
                    price: '16,000원',
                    quantity: 1,
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAAWYuFthFKJVAOf6IqqCfkbUH6XeR4s9RUvcWag3PJEapH91CY91IzYzgRMepgFMtUwdSf9yP4LOmYZn4wyfNM6CpoFMaaF-QBu8nCEyDsQt6GDTgeQG79J7R4HCMLyzIi3MVEjuAhJqCS7c8a4TIh8IzgHHO1F7uUQXCZoSQZ-Kr40QUQPGXLIepA9FDOJZMWcvFKkZw6rLF5hu9UagClVYBxTmC_pynZ4AU-BmmTZVjHcvFQiWF-toeTewM8GBeJtdpTAi1AKKE',
                  ),
                  SizedBox(height: 24),
                  _CartItem(
                    title: '시저 샐러드',
                    options: '드레싱: 발사믹',
                    price: '7,000원',
                    quantity: 2,
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAa48xzzzAEkhbDz0r7RlYqUjfooricATMR8gq11tLrpAzioUYBwKe823b7Jx8Umg5iYdlP6j5jVs3mqL_ZWRzkrdk9KYbJ-8kxfQEewdwGc36sqNY1W9nm0xBJOv8DskhwNpurtOCYnIv1MUrDcbLKallwVZSShjI09uKwxIiL55i-tbteF-LS4MYIkPrtoQPnkL70zfmHi5iqI6E-cHyAfXfMPvGq-JHIoO16tGvvBj1vY1gLwgwDEmKEIhz49CbEEJqIIrkbTqc',
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6), indent: 20, endIndent: 20),
            const SizedBox(height: 32),
            // Payment Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('결제 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const _SummaryRow(label: '주문 금액', value: '39,500원'),
                    const SizedBox(height: 12),
                    const _SummaryRow(label: '배달팁', value: '3,000원'),
                    const SizedBox(height: 12),
                    const _SummaryRow(label: '할인 금액', value: '-2,000원', isDiscount: true),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: _DashedLine(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('총 결제 금액', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('40,500원', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 160),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[100]!)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('40,500원 결제하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 12),
            const Text(
              '주문 내용을 확인하였으며, 정보 제공 등에 동의합니다.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String title;
  final String options;
  final String price;
  final int quantity;
  final String imageUrl;

  const _CartItem({
    required this.title,
    required this.options,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            border: Border.all(color: Colors.grey[100]!),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.close, size: 20, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                options,
                style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.remove, size: 16, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        const Icon(Icons.add, size: 16, color: Colors.black),
                      ],
                    ),
                  ),
                  Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;

  const _SummaryRow({required this.label, required this.value, this.isDiscount = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey[300])),
            );
          }),
        );
      },
    );
  }
}
