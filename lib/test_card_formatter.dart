import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/user/payment.dart';

/// Test widget to demonstrate the card input formatting
class CardFormatterTest extends StatefulWidget {
  const CardFormatterTest({super.key});

  @override
  State<CardFormatterTest> createState() => _CardFormatterTestState();
}

class _CardFormatterTestState extends State<CardFormatterTest> {
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Input Formatter Test'),
        backgroundColor: const Color(0xFF9B652E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test the real-time formatting:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Card Number Test
            const Text('Card Number (should format as: 1234 5678 9012 3456)'),
            const SizedBox(height: 8),
            TextField(
              controller: _cardController,
              keyboardType: TextInputType.number,
              inputFormatters: [CardNumberInputFormatter()],
              decoration: const InputDecoration(
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 20),
            
            // Expiry Date Test
            const Text('Expiry Date (should format as: MM/YY)'),
            const SizedBox(height: 8),
            TextField(
              controller: _expiryController,
              keyboardType: TextInputType.number,
              inputFormatters: [ExpiryDateInputFormatter()],
              decoration: const InputDecoration(
                hintText: 'MM/YY',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
              ),
            ),
            const SizedBox(height: 20),
            
            // CVV Test
            const Text('CVV (3-4 digits)'),
            const SizedBox(height: 8),
            TextField(
              controller: _cvvController,
              keyboardType: TextInputType.number,
              obscureText: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                hintText: '123',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            
            // Display current values
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Values:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Card: "${_cardController.text}"'),
                  Text('Expiry: "${_expiryController.text}"'),
                  Text('CVV: "${_cvvController.text}"'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Type numbers in the card field - spaces will be added automatically'),
                  Text('• Type 4 digits in expiry field - slash will be added after 2nd digit'),
                  Text('• CVV field accepts 3-4 digits and hides the input'),
                  Text('• All fields limit input length appropriately'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}


