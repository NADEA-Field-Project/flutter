import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'main_navigation.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nameController = TextEditingController(text: 'User');
  final TextEditingController _phoneController = TextEditingController(text: '010-1234-5678');
  final TextEditingController _addressController = TextEditingController(text: '서울시 강남구 테헤란로 123');
  List<dynamic> _cartItems = [];
  Map<String, dynamic>? _defaultPaymentMethod;
  bool _isLoading = false;
  bool _isLoadingCart = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
    _fetchDefaultAddress();
    _fetchDefaultPaymentMethod();
  }

  Future<void> _fetchDefaultAddress() async {
    try {
      final addresses = await _apiService.getAddresses();
      final defaultAddr = addresses.firstWhere(
        (addr) => addr['is_default'] == 1 || addr['is_default'] == true,
        orElse: () => null,
      );

      if (defaultAddr != null && mounted) {
        setState(() {
          _nameController.text = defaultAddr['receiver_name'];
          _phoneController.text = defaultAddr['phone'];
          _addressController.text = '${defaultAddr['address_line1']} ${defaultAddr['address_line2'] ?? ''}'.trim();
        });
      }
    } catch (e) {
      print('Error fetching default address: $e');
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      final result = await _apiService.getCart();
      if (mounted) {
        setState(() {
          _cartItems = result['items'] ?? [];
          _isLoadingCart = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingCart = false);
    }
  }

  Future<void> _fetchDefaultPaymentMethod() async {
    try {
      final methods = await _apiService.getPaymentMethods();
      final defaultMethod = methods.firstWhere(
        (m) => m['is_default'] == 1 || m['is_default'] == true,
        orElse: () => null,
      );
      if (mounted) {
        setState(() {
          _defaultPaymentMethod = defaultMethod;
        });
      }
    } catch (e) {
      print('Error fetching default payment method: $e');
    }
  }

  void _showAddressSelectionBottomSheet() async {
    try {
      final addresses = await _apiService.getAddresses();
      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('배송지 선택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('등록된 배송지가 없습니다.'),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final addr = addresses[index];
                      return ListTile(
                        title: Text(addr['receiver_name']),
                        subtitle: Text('${addr['address_line1']} ${addr['address_line2'] ?? ''}'),
                        trailing: addr['is_default'] == 1 ? const Icon(Icons.check_circle, color: Colors.black) : null,
                        onTap: () {
                          setState(() {
                            _nameController.text = addr['receiver_name'];
                            _phoneController.text = addr['phone'];
                            _addressController.text = '${addr['address_line1']} ${addr['address_line2'] ?? ''}'.trim();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error loading addresses: $e');
    }
  }

  void _showCardSelectionBottomSheet() async {
    try {
      final methods = await _apiService.getPaymentMethods();
      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('결제 수단 선택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (methods.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('등록된 결제 수단이 없습니다.'),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: methods.length,
                    itemBuilder: (context, index) {
                      final item = methods[index];
                      return ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(item['card_name']),
                        subtitle: Text(item['card_number']),
                        trailing: item['is_default'] == 1 ? const Icon(Icons.check_circle, color: Colors.black) : null,
                        onTap: () {
                          setState(() {
                            _defaultPaymentMethod = item;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error loading cards: $e');
    }
  }

  Future<void> _handlePayment() async {
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery info')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _apiService.placeOrder(
        address: _addressController.text,
        contact: _phoneController.text,
        paymentMethod: 'Credit Card',
      );

      if (mounted) {
        if (result['success'] == true) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Order Complete'),
              content: const Text('Your order has been placed successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainNavigation()),
                      (route) => false,
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Order failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAmount = widget.totalAmount - 3000;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Info Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('배송지 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: _showAddressSelectionBottomSheet,
                    child: Text('배송지 변경', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _InputField(label: '이름', controller: _nameController, placeholder: '김토스')),
                  const SizedBox(width: 12),
                  Expanded(child: _InputField(label: '전화번호', controller: _phoneController, placeholder: '010-1234-5678')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _InputField(label: '주소', controller: _addressController, hasSearch: true, placeholder: '서울시 강남구 테헤란로 123'),
            ),
            const SizedBox(height: 24),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            
            // Payment Method Section
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('결제 수단', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: _showCardSelectionBottomSheet,
                    child: Text('카드 변경', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Credit Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(4, (i) => Container(
                            width: 8, height: 8, 
                            margin: const EdgeInsets.only(right: 4),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          )),
                        ),
                        Icon(Icons.contactless, color: Colors.white.withOpacity(0.6)),
                      ],
                    ),
                    Text(
                      _defaultPaymentMethod != null 
                        ? _defaultPaymentMethod!['card_number'] 
                        : '•••• •••• •••• 8892', 
                      style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w500)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardInfo(label: 'CARD HOLDER', value: _nameController.text.toUpperCase()),
                        _CardInfo(label: 'EXPIRES', value: _defaultPaymentMethod != null ? 'PERMANENT' : '12/28'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Card Detail Inputs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _InputField(label: '카드 번호', prefixIcon: Icons.credit_card, placeholder: '0000 0000 0000 0000'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(child: _InputField(label: '유효기간', placeholder: 'MM/YY')),
                      const SizedBox(width: 12),
                      Expanded(child: _InputField(label: 'CVC', placeholder: '123', suffixIcon: Icons.help_outline)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 8, thickness: 8, color: Color(0xFFF9FAFB)),
            
            // Order Items Section
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('주문 내역', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[100]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _isLoadingCart
                            ? const CircularProgressIndicator(color: Colors.black)
                            : Column(
                                children: _cartItems.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            item['name']?.toLowerCase().contains('cola') == true
                                                ? Icons.local_drink
                                                : Icons.lunch_dining,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['name'] ?? 'Product',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              ),
                                              Text(
                                                '수량: ${item['quantity'] ?? 1}개',
                                                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '₩${((double.tryParse(item['price'].toString()) ?? 0) * (item['quantity'] ?? 1)).toInt()}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: _DashedLine(),
                        ),
                        const SizedBox(height: 16),
                        _SummaryRow(label: '상품 금액', value: '₩${productAmount.toInt()}'),
                        const SizedBox(height: 12),
                        const _SummaryRow(label: '배송비', value: '무료', isHighlight: true),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('총 결제금액', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              '₩${widget.totalAmount.toInt()}',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handlePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₩${widget.totalAmount.toInt()} 결제 완료',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  ],
                ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? placeholder;
  final bool hasSearch;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;

  const _InputField({
    required this.label,
    this.controller,
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
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[300]),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[400], size: 20) : null,
            suffixIcon: hasSearch
                ? const Icon(Icons.search, color: Colors.black)
                : suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.grey[400], size: 20)
                    : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
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
        Text(
          label.toUpperCase(),
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: isHighlight ? Colors.grey[400] : Colors.black,
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
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey[100]!)),
            );
          }),
        );
      },
    );
  }
}
