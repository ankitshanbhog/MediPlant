import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/plant_model.dart';
import '../../services/backend_recognition_service.dart';
import '../../viewmodels/recognition_viewmodel.dart';
import '../theme/app_colors.dart';
import 'plant_encyclopedia_screen.dart';
import 'plant_detail_screen.dart';
import '../widgets/plant_image.dart';
import '../../data/database_helper.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'farmer/farmer_dashboard_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'auth/login_screen.dart';


/// Redesigned Vibrant Home Dashboard Screen
///
/// Fully connected to the local SQLite database for botanical plants & history,
/// featuring a cloud backend server manager dialog and modern nature-inspired aesthetics.
class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToIdentify;
  final VoidCallback onNavigateToSearch;
  final VoidCallback onNavigateToRemedies;
  final VoidCallback onNavigateToHistory;

  const HomeScreen({
    super.key,
    required this.onNavigateToIdentify,
    required this.onNavigateToSearch,
    required this.onNavigateToRemedies,
    required this.onNavigateToHistory,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _showServerSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ServerSettingsSheet(onSaved: () => setState(() {})),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recognitionVM = context.read<RecognitionViewModel>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF6FAF7),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Top Bar with Branding & Cloud Server Manager ─────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00796B), Color(0xFF004D40)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'MediPlant',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.3,
                                    color: isDark ? AppColors.mint : AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'AI READY',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Herbal Botanical Intelligence',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Cloud Server Settings Action
                    IconButton(
                      tooltip: 'Cloud Server Settings',
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceSubtleDark : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: const Icon(Icons.cloud_sync_rounded, size: 20, color: AppColors.primary),
                      ),
                      onPressed: () => _showServerSettingsDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── 2. Hero Plant Recognition Card ──────────────────────────
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF064E3B).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -25,
                        bottom: -35,
                        child: Icon(
                          Icons.local_florist_rounded,
                          size: 190,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome, color: Color(0xFF6EE7B7), size: 14),
                                  SizedBox(width: 6),
                                  Text(
                                    '10 Medicinal Species Supported',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Identify Any\nMedicinal Plant',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Snap or upload a leaf photo to instantly classify the botanical species and view healing benefits.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.88),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await recognitionVM.capturePhoto();
                                      if (recognitionVM.hasImage) {
                                        widget.onNavigateToIdentify();
                                      }
                                    },
                                    icon: const Icon(Icons.camera_alt_rounded, size: 20),
                                    label: const Text('Camera'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF064E3B),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      await recognitionVM.pickFromGallery();
                                      if (recognitionVM.hasImage) {
                                        widget.onNavigateToIdentify();
                                      }
                                    },
                                    icon: const Icon(Icons.photo_library_rounded, size: 20, color: Colors.white),
                                    label: const Text('Gallery', style: TextStyle(color: Colors.white)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.white70, width: 1.5),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // ── 3. Search by Health Condition ───────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 30),
                      const SizedBox(height: 12),
                      const Text('Plant Encyclopedia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text('Explore information for the 10 supported plants and any plants added to the database later.', style: TextStyle(fontSize: 13, height: 1.4, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlantEncyclopediaScreen())),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Open Encyclopedia'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Role-Based Ecosystem Card ───────────────────────────────
                Consumer<AuthViewModel>(
                  builder: (context, authVM, _) {
                    final user = authVM.currentUser;
                    final isFarmer = authVM.isFarmer;
                    final isAdmin = authVM.isAdmin;

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isAdmin
                              ? [const Color(0xFFB71C1C), const Color(0xFF7F0000)]
                              : isFarmer
                                  ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                                  : [const Color(0xFF0F172A), const Color(0xFF1E293B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isAdmin
                                        ? Icons.shield_rounded
                                        : isFarmer
                                            ? Icons.agriculture_rounded
                                            : Icons.people_alt_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isAdmin
                                        ? 'ADMIN CONSOLE'
                                        : isFarmer
                                            ? 'FARMER WORKSPACE'
                                            : 'GROWER ECOSYSTEM',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              if (user != null && user.isVerified)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('VERIFIED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isAdmin
                                ? 'Botanical Review & User Oversight'
                                : isFarmer
                                    ? 'Crop Batches & Harvest Management'
                                    : 'Connect with Farmers & Botanical Reviewers',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isAdmin
                                ? 'Verify farmer accounts, audit data, and manage botantical evidence.'
                                : isFarmer
                                    ? 'Log sowing dates, monitor harvest readiness, and receive weather advisories.'
                                    : 'MediPlant bridges plant enthusiasts with verified farmers and botanical experts.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (isFarmer)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF1B5E20),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.dashboard_rounded, size: 18),
                                  label: const Text('Open Farmer Workspace', style: TextStyle(fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const FarmerDashboardScreen()),
                                    );
                                  },
                                ),
                              if (isAdmin)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFFB71C1C),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.admin_panel_settings_rounded, size: 18),
                                  label: const Text('Open Admin Console', style: TextStyle(fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                                    );
                                  },
                                ),
                              if (!authVM.isAuthenticated)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0F172A),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.login_rounded, size: 18),
                                  label: const Text('Sign In to Role Workspace', style: TextStyle(fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── 4. Live Botanical Catalog (From SQLite Database) ────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Medicinal Plants',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PlantEncyclopediaScreen()),
                      ),
                      child: const Text('See All (10)', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Plant>>(
                  future: DatabaseHelper.instance.getAllPlants(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox(height: 180);
                    final plants = snapshot.data ?? [];
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: plants.length,
                        itemBuilder: (context, index) {
                          final plant = plants[index];
                          return _PlantCard(
                            plant: plant,
                            isDark: isDark,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PlantDetailScreen(plant: plant)),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Plant Card for Database Carousel ─────────────────────────────────────────

class _PlantCard extends StatelessWidget {
  final Plant plant;
  final bool isDark;
  final VoidCallback onTap;

  const _PlantCard({
    required this.plant,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 14, bottom: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : const Color(0xFFE5EBE7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlantImage(
              plantId: plant.id,
              fallbackUrl: plant.imageUrl,
              height: 110,
              width: double.infinity,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      plant.family,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.mint : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    plant.commonName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plant.scientificName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// ── Cloud Backend Server Manager Bottom Sheet ────────────────────────────────

class _ServerSettingsSheet extends StatefulWidget {
  final VoidCallback onSaved;

  const _ServerSettingsSheet({required this.onSaved});

  @override
  State<_ServerSettingsSheet> createState() => _ServerSettingsSheetState();
}

class _ServerSettingsSheetState extends State<_ServerSettingsSheet> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String? _testResult;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    final saved = await DatabaseHelper.instance.getSetting('custom_backend_url');
    if (saved != null) {
      _urlController.text = saved;
    } else {
      _urlController.text = BackendRecognitionService.defaultBaseUrl;
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = null;
    });

    final service = BackendRecognitionService(customBaseUrl: _urlController.text.trim());
    final isHealthy = await service.checkHealth();

    setState(() {
      _isLoading = false;
      _isSuccess = isHealthy;
      _testResult = isHealthy
          ? 'Server is online and responding!'
          : 'Could not connect. Please verify URL and cloud server status.';
    });
  }

  Future<void> _saveUrl() async {
    final clean = _urlController.text.trim();
    await DatabaseHelper.instance.setSetting('custom_backend_url', clean);
    widget.onSaved();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Backend Server',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Deploy to Hugging Face or Render for wireless use',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Server Endpoint URL',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'e.g. https://my-mediplant.hf.space',
              prefixIcon: const Icon(Icons.link_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                onPressed: () => _urlController.clear(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_testResult != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                    color: _isSuccess ? const Color(0xFF2E7D32) : Colors.redAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _testResult!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _isSuccess ? const Color(0xFF2E7D32) : Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _testConnection,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Test Connection'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveUrl,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save & Use'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
