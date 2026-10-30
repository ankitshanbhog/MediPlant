import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = AuthService();
      await authService.initializeSession();
      final users = await authService.getAdminUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleVerification(int userId, bool currentVal) async {
    try {
      final authService = AuthService();
      await authService.initializeSession();
      await authService.toggleUserVerification(userId, !currentVal);
      _fetchUsers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification status updated for User #$userId'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    // Route guard check: must be admin
    if (!authVM.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Console')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security_rounded, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Botanical Admin Access Required',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your current account (${authVM.currentUser?.email ?? "Guest"}) does not have Admin / Botanical Reviewer privileges.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB71C1C), foregroundColor: Colors.white),
                  child: const Text('Return Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin & Reviewer Console', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFB71C1C)))
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                        const SizedBox(height: 12),
                        Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _fetchUsers, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Admin Stats Card
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Registered Users', '${_users.length}', Icons.people_outline),
                            _buildStatItem(
                              'Verified Farmers',
                              '${_users.where((u) => u['is_verified'] == true && ((u['roles'] as List).contains('farmer'))).length}',
                              Icons.verified_rounded,
                            ),
                            _buildStatItem(
                              'Admins',
                              '${_users.where((u) => (u['roles'] as List).contains('admin')).length}',
                              Icons.shield_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'User & Role Directory',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    ..._users.map((u) {
                      final roles = (u['roles'] as List).cast<String>();
                      final isVerified = u['is_verified'] == true;
                      final isFarmer = roles.contains('farmer');
                      final isAdmin = roles.contains('admin');

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isAdmin
                                ? const Color(0xFFB71C1C)
                                : isFarmer
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF1565C0),
                            child: Icon(
                              isAdmin
                                  ? Icons.shield_rounded
                                  : isFarmer
                                      ? Icons.agriculture_rounded
                                      : Icons.eco_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(u['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              if (isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF2E7D32)),
                              ],
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u['email'] ?? '', style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                children: roles.map((r) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      r.toUpperCase(),
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          trailing: isFarmer
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isVerified ? Colors.red : const Color(0xFF2E7D32),
                                    side: BorderSide(color: isVerified ? Colors.red : const Color(0xFF2E7D32)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  ),
                                  onPressed: () => _toggleVerification(u['id'], isVerified),
                                  child: Text(
                                    isVerified ? 'Revoke' : 'Verify',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                )
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFB71C1C), size: 24),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }
}
