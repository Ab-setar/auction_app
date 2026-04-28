import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/prefs_service.dart';
import '../services/notification_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _bidController = TextEditingController();
  double? _currentBid;

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  double get _minimumBid => _currentBid ?? widget.product.price;

  void _placeBid() {
    final input = _bidController.text.trim();
    final bid = double.tryParse(input);

    if (bid == null || input.isEmpty) {
      _showSnackbar('Please enter a valid bid amount.', isError: true);
      return;
    }

    if (bid <= _minimumBid) {
      _showSnackbar(
        'Bid must be greater than \$${_minimumBid.toStringAsFixed(2)}.',
        isError: true,
      );
      return;
    }

    setState(() => _currentBid = bid);
    _bidController.clear();
    PrefsService().saveLastBid(amount: bid, productTitle: widget.product.title);
    NotificationService.instance.showBidPlaced(
      productTitle: widget.product.title,
      amount: bid,
    );
    _showSnackbar('Bid of \$${bid.toStringAsFixed(2)} placed successfully!');
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product image
            Center(
              child: Image.network(
                product.image,
                height: 220,
                fit: BoxFit.contain,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        height: 220,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 220,
                  child: Icon(Icons.broken_image_outlined,
                      size: 64, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              product.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Starting price
            _InfoRow(
              label: 'Starting Price',
              value: '\$${product.price.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),

            // Current bid
            _InfoRow(
              label: 'Current Bid',
              value: _currentBid != null
                  ? '\$${_currentBid!.toStringAsFixed(2)}'
                  : 'No bids yet',
              valueColor:
                  _currentBid != null ? Colors.deepPurple : Colors.grey[600],
            ),

            const Divider(height: 36),

            // Bid section
            Text(
              'Place Your Bid',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Must be greater than \$${_minimumBid.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _bidController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Your Bid Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onSubmitted: (_) => _placeBid(),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _placeBid,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Place Bid', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[700])),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
        ),
      ],
    );
  }
}
