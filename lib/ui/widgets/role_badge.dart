import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../screens/auth/login_screen.dart';
import '../screens/farmer/farmer_dashboard_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';

class RoleBadgeWidget extends StatelessWidget {
  const RoleBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    if (!authVM.isAuthenticated) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ActionChip(
          avatar: const Icon(Icons.person_outline_rounded, size: 16, color: Colors.white),
          label: const Text(
            'Sign In',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1B5E20),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      );
    }

    final user = authVM.currentUser!;
    final primaryRole = authVM.activeRole;

    Color badgeBg;
    IconData badgeIcon;
    String displayLabel;

    switch (primaryRole) {
      case 'admin':
        badgeBg = const Color(0xFFB71C1C); // Deep red
        badgeIcon = Icons.shield_rounded;
        displayLabel = 'Admin';
        break;
      case 'farmer':
        badgeBg = const Color(0xFF2E7D32); // Emerald green
        badgeIcon = Icons.agriculture_rounded;
        displayLabel = user.isVerified ? 'Farmer ✓' : 'Farmer';
        break;
      default:
        badgeBg = const Color(0xFF1565C0); // Deep Blue
        badgeIcon = Icons.eco_rounded;
        displayLabel = 'Enthusiast';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(badgeIcon, size: 16, color: Colors.white),
        label: Text(
          displayLabel,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: badgeBg,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => _showAccountModal(context, authVM),
      ),
    );
  }

  void _showAccountModal(BuildContext context, AuthViewModel authVM) {
    final user = authVM.currentUser;
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF2E7D32),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (user.isVerified) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, size: 18, color: Color(0xFF2E7D32)),
                              ],
                            ],
                          ),
                          Text(
                            user.email,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(),
                const Text(
                  'Assigned Roles & Access',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: user.roles.map((r) {
                    final isCurrentActive = authVM.activeRole == r;
                    return ChoiceChip(
                      label: Text(r == 'user' ? 'Plant Enthusiast' : r.toUpperCase()),
                      selected: isCurrentActive,
                      selectedColor: const Color(0xFFC8E6C9),
                      onSelected: (selected) {
                        if (selected) {
                          authVM.switchRole(r);
                          Navigator.pop(ctx);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                if (user.isFarmer) ...[
                  ListTile(
                    leading: const Icon(Icons.agriculture_rounded, color: Color(0xFF2E7D32)),
                    title: const Text('Farmer Workspace'),
                    subtitle: const Text('Crop batches, harvest records & alerts'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FarmerDashboardScreen()),
                      );
                    },
                  ),
                ],
                if (user.isAdmin) ...[
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFB71C1C)),
                    title: const Text('Admin Console'),
                    subtitle: const Text('User verification & reviewer controls'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red),
                  title: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    authVM.logout();
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
