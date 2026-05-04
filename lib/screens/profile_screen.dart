import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/prefs_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _prefs = PrefsService();
  final _picker = ImagePicker();

  String? _username;
  Map<String, dynamic>? _lastBid;
  bool _loading = true;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final username = await _prefs.getUsername();
    final lastBid = await _prefs.getLastBid();
    final imagePath = await _prefs.getProfileImagePath();
    setState(() {
      _username = username;
      _lastBid = lastBid;
      _profileImage = imagePath != null ? File(imagePath) : null;
      _loading = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
      );
      if (picked == null) return;
      final file = File(picked.path);
      await _prefs.saveProfileImagePath(picked.path);
      setState(() => _profileImage = file);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not access camera/gallery: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.deepPurple,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? const Icon(Icons.person,
                                  size: 48, color: Colors.white)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _username ?? 'Unknown User',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  _SectionCard(
                    title: 'Account Info',
                    child: _InfoTile(
                      icon: Icons.person_outline,
                      label: 'Username',
                      value: _username ?? '—',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Last Bid',
                    child: _lastBid != null
                        ? Column(
                            children: [
                              _InfoTile(
                                icon: Icons.shopping_bag_outlined,
                                label: 'Product',
                                value: _lastBid!['product'] as String,
                              ),
                              const Divider(height: 1),
                              _InfoTile(
                                icon: Icons.attach_money,
                                label: 'Amount',
                                value:
                                    '\$${(_lastBid!['amount'] as double).toStringAsFixed(2)}',
                                valueColor: Colors.deepPurple,
                              ),
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'No bids placed yet.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Colors.grey[600], letterSpacing: 0.8),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: child,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700])),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
