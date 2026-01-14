import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('결제'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('배송지 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Expanded(child: _InputField(label: '이름', value: '김토스')),
                  SizedBox(width: 16),
                  Expanded(child: _InputField(label: '전화번호', value: '010-1234-5678')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _InputField(label: '주소', value: '서울시 강남구 테헤란로 123', hasSearch: true),
            ),
            const SizedBox(height: 32),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('결제 수단', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('카드 변경', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Credit Card Mockup
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBrOOT_ykf8ts3Soe3hgJiZjmKEAmLmbBc8zllufg8_i1D8uVhtwh_Z3j9PPqQMq_jxjB3SSyFuAafIgCVTOVwYFARXWnfXvxhU4Ui7FJOtirO1UzgXbrms_cfX1Fxv6nLzBnt9rqjFhAJW770njBfgNYlwq0LchCNX7zunmAM3qHejX-OyCEowOOTiUJKOqeR8gpN5lwFFIiFlM-ND8quti-H3hvIUE_RUdqwk2uWnUTC5B5VoxFYQQkCBCpEduoewWMg8Ub21LwM',
                          height: 32,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        Icon(Icons.contactless, color: Colors.white.withOpacity(0.5)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '••••  ••••  ••••  8892',
                          style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CardInfo(label: 'Card Holder', value: 'KIM TOSS'),
                            _CardInfo(label: 'Expires', value: '12/28'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _InputField(label: '카드 번호', placeholder: '0000 0000 0000 0000', prefixIcon: Icons.credit_card),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Expanded(child: _InputField(label: '유효기간', placeholder: 'MM/YY')),
                  SizedBox(width: 16),
                  Expanded(child: _InputField(label: 'CVC', placeholder: '123', isPassword: true, suffixIcon: Icons.help_outline)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('주문 내역', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Column(
                  children: const [
                    _OrderItem(icon: Icons.lunch_dining, name: '치즈버거 세트', quantity: 1, price: '₩8,900'),
                    SizedBox(height: 16),
                    _OrderItem(icon: Icons.local_drink, name: '제로 콜라', quantity: 1, price: '₩2,000'),
                    Padding(padding: EdgeInsets.symmetric(vertical: 16), child: _DashedLine()),
                    _SummaryRow(label: '상품 금액', value: '₩10,900'),
                    _SummaryRow(label: '배송비', value: '무료'),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('총 결제금액', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('₩10,900', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
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
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('결제 완료', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(width: 8),
              Icon(Icons.check, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String? value;
  final String? placeholder;
  final bool hasSearch;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;

  const _InputField({
    required this.label,
    this.value,
    this.placeholder,
    this.hasSearch = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey[500], letterSpacing: 1.2)),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[300]),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[400]) : null,
            suffixIcon: hasSearch
                ? const Icon(Icons.search, color: Colors.black)
                : suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.grey[400])
                    : null,
            contentPadding: const EdgeInsets.all(15),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}

class _CardInfo extends StatelessWidget {
  final String label;
  final String value;
  const _CardInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _OrderItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final int quantity;
  final String price;

  const _OrderItem({required this.icon, required this.name, required this.quantity, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.black, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('수량: $quantity개', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
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
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey[200])),
            );
          }),
        );
      },
    );
  }
}
