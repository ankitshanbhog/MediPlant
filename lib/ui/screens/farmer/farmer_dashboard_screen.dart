import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/farmer_viewmodel.dart';
import '../../theme/app_colors.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  String _guideSearchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmerViewModel>().loadFarmerData();
    });
  }

  void _showDatabaseArchitectureSheet(BuildContext context, bool isConnected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
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
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.storage_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Dual-Database Architecture',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF3F9F5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD6EAE0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF2E7D32)),
                        SizedBox(width: 8),
                        Text('1. Local SQLite Engine (Active)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'All crop entries and harvest records are saved instantly to the local SQLite database. Works 100% offline in agricultural fields with zero latency.',
                      style: TextStyle(fontSize: 13.5, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          isConnected ? Icons.cloud_done_rounded : Icons.cloud_queue_rounded,
                          size: 18,
                          color: isConnected ? const Color(0xFF1565C0) : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isConnected ? '2. Cloud Database (Synchronized)' : '2. Cloud Database (Offline Standby)',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'When network connectivity is detected, local records seamlessly synchronize with the central REST/PostgreSQL cloud server for multi-device backup.',
                      style: TextStyle(fontSize: 13.5, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Got It', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final farmerVM = context.watch<FarmerViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!authVM.isFarmer) {
      return Scaffold(
        appBar: AppBar(title: const Text('Farmer Workspace')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.agriculture_rounded, size: 68, color: AppColors.primary),
                const SizedBox(height: 18),
                const Text('Farmer Account Required', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(
                  'Please sign in with a registered Farmer profile to access agronomy dossiers, crop planning, and local SQLite harvest tracking.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight, fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Return Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7FAF8),
      appBar: AppBar(
        title: const Text(
          'Farmer Workspace',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.3),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Sync / Refresh',
            onPressed: () => farmerVM.loadFarmerData(),
          ),
        ],
      ),
      floatingActionButton: farmerVM.selectedTabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddCropSheet(context, farmerVM),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded, size: 22),
              label: const Text('Record New Sowing', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            )
          : null,
      body: farmerVM.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: () => farmerVM.loadFarmerData(),
              color: AppColors.primary,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                children: [
                  // Dual Architecture Status Banner (Tap to explain)
                  _buildDualArchitectureBanner(context, farmerVM, isDark),
                  const SizedBox(height: 16),

                  // 4 Segmented Tabs
                  _buildSegmentedTabs(farmerVM, isDark),
                  const SizedBox(height: 18),

                  // Active Tab View
                  _buildActiveTabView(context, farmerVM, isDark),
                  const SizedBox(height: 90),
                ],
              ),
            ),
    );
  }

  Widget _buildDualArchitectureBanner(BuildContext context, FarmerViewModel farmerVM, bool isDark) {
    final isCloud = farmerVM.isCloudConnected;

    return InkWell(
      onTap: () => _showDatabaseArchitectureSheet(context, isCloud),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : const Color(0xFFDCE7DF),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Local SQLite Storage: ACTIVE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  Text(
                    isCloud ? 'Cloud Database: Synchronized' : 'Cloud Sync: Standby (Offline Ready)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isCloud ? const Color(0xFF1565C0) : Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Info', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs(FarmerViewModel farmerVM, bool isDark) {
    final tabs = [
      {'title': 'Crop Tracker', 'icon': Icons.calendar_today_rounded, 'count': '${farmerVM.crops.length}'},
      {'title': 'Cultivation Dossiers', 'icon': Icons.menu_book_rounded, 'count': '${farmerVM.dossiers.length}'},
      {'title': 'Gov Subsidies', 'icon': Icons.account_balance_rounded, 'count': '${farmerVM.schemes.length}'},
      {'title': 'Market Rates', 'icon': Icons.trending_up_rounded, 'count': '${farmerVM.benchmarks.length}'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = farmerVM.selectedTabIndex == index;
          final tab = tabs[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => farmerVM.setTabIndex(index),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.surfaceDark : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFE2EBE5)),
                    width: isSelected ? 1.6 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      size: 17,
                      color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${tab['title']} (${tab['count']})',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveTabView(BuildContext context, FarmerViewModel farmerVM, bool isDark) {
    switch (farmerVM.selectedTabIndex) {
      case 0:
        return _buildCropTrackerTab(context, farmerVM, isDark);
      case 1:
        return _buildCultivationDossiersTab(farmerVM, isDark);
      case 2:
        return _buildGovernmentSubsidiesTab(farmerVM, isDark);
      case 3:
        return _buildMarketRatesTab(farmerVM, isDark);
      default:
        return _buildCropTrackerTab(context, farmerVM, isDark);
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 1: CROP TRACKER & HARVESTS (SQLITE + CLOUD)
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildCropTrackerTab(BuildContext context, FarmerViewModel farmerVM, bool isDark) {
    if (farmerVM.crops.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7)),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.grass_rounded, size: 48, color: AppColors.primary),
              const SizedBox(height: 12),
              const Text('No Sowing Records Yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(
                'Track crop lifecycles, growth stages, and automatic harvest dates stored directly in your local SQLite database.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight, height: 1.4),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () => _showAddCropSheet(context, farmerVM),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Record First Crop', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Botanical Batches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
            ),
            Text(
              '${farmerVM.crops.length} Batches',
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...farmerVM.crops.map((c) {
          final id = c['id'] is int ? c['id'] as int : int.tryParse(c['id'].toString()) ?? 0;
          final plantName = c['plantName'] ?? c['plant_name'] ?? 'Medicinal Plant';
          final stage = c['stage'] ?? 'Sowing';
          final sow = c['sowingDate'] ?? c['sowing_date'] ?? '';
          final harv = c['expectedHarvest'] ?? c['expected_harvest'] ?? '';
          final plot = c['plotArea'] ?? '1 Acre';
          final qty = c['quantity'] ?? '';
          final notes = c['notes'] ?? '';

          Color stageColor = const Color(0xFF2E7D32);
          if (stage.toString().contains('Harvest')) {
            stageColor = const Color(0xFFE65100);
          } else if (stage.toString().contains('Flowering')) {
            stageColor = const Color(0xFF5E35B1);
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plantName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: stageColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              stage,
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: stageColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded),
                      onSelected: (val) {
                        if (val == 'delete') {
                          farmerVM.deleteCrop(id);
                        } else {
                          farmerVM.updateCropStage(id, val);
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'Sowing / Germination', child: Text('Stage: Sowing')),
                        const PopupMenuItem(value: 'Vegetative Growth', child: Text('Stage: Vegetative Growth')),
                        const PopupMenuItem(value: 'Flowering Stage', child: Text('Stage: Flowering Stage')),
                        const PopupMenuItem(value: 'Harvest Ready', child: Text('Stage: Harvest Ready')),
                        const PopupMenuItem(value: 'Post-Harvest Curing', child: Text('Stage: Post-Harvest Curing')),
                        const PopupMenuDivider(),
                        const PopupMenuItem(value: 'delete', child: Text('Delete Record', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: isDark ? AppColors.borderDark : const Color(0xFFEDF2EE)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sowing Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          const SizedBox(height: 2),
                          Text(sow.isNotEmpty ? sow : 'Recorded', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target Harvest', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                          const SizedBox(height: 2),
                          Text(harv.isNotEmpty ? harv : 'Calculated', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(Icons.landscape_rounded, size: 16, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    const SizedBox(width: 6),
                    Text('Plot: $plot', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    if (qty.isNotEmpty) ...[
                      const SizedBox(width: 14),
                      Icon(Icons.inventory_2_outlined, size: 16, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      const SizedBox(width: 6),
                      Text('Est: $qty', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ],
                ),

                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF5F8F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(notes, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 2: CULTIVATION DOSSIERS (13 PLANTS - ICAR / NMPB DATA)
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildCultivationDossiersTab(FarmerViewModel farmerVM, bool isDark) {
    final filtered = farmerVM.dossiers.where((d) {
      if (_guideSearchQuery.isEmpty) return true;
      final q = _guideSearchQuery.toLowerCase();
      return d.speciesName.toLowerCase().contains(q) ||
          d.botanicalName.toLowerCase().contains(q) ||
          d.soilAndPh.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Botanical Agronomic Protocols',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
        ),
        const SizedBox(height: 4),
        Text(
          'Verified field guidelines sourced from NMPB and ICAR research bulletins',
          style: TextStyle(fontSize: 13.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
        ),
        const SizedBox(height: 14),

        // Search bar
        TextField(
          onChanged: (val) => setState(() => _guideSearchQuery = val.trim()),
          decoration: InputDecoration(
            hintText: 'Search species (e.g. Ashwagandha, Tulsi)...',
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),

        ...filtered.map((dossier) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dossier.speciesName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          Text(dossier.botanicalName, style: TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic, color: isDark ? AppColors.mint : const Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('Harvested Part: ${dossier.primaryPart}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: isDark ? AppColors.borderDark : const Color(0xFFEDF2EE)),
                const SizedBox(height: 8),

                _buildDossierRow(Icons.landscape_rounded, 'Soil & pH Range', dossier.soilAndPh, isDark),
                _buildDossierRow(Icons.grid_4x4_rounded, 'Seed Rate & Spacing', dossier.seedRateAndSpacing, isDark),
                _buildDossierRow(Icons.thermostat_rounded, 'Agro-Climate Zone', dossier.climateZone, isDark),
                _buildDossierRow(Icons.water_drop_rounded, 'Irrigation Protocol', dossier.irrigationNeeds, isDark),
                _buildDossierRow(Icons.timelapse_rounded, 'Cycle to Maturity', '${dossier.daysToMaturity} days (${dossier.harvestingIndicators})', isDark),
                _buildDossierRow(Icons.dry_cleaning_rounded, 'Post-Harvest Curing', dossier.postHarvestCuring, isDark),
                _buildDossierRow(Icons.inventory_rounded, 'Expected Yield per Ha', dossier.expectedYield, isDark),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDossierRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                children: [
                  TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w800)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 3: GOVERNMENT SCHEMES & SUBSIDIES
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildGovernmentSubsidiesTab(FarmerViewModel farmerVM, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Government Cultivation Subsidies',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
        ),
        const SizedBox(height: 4),
        Text(
          'Official financial grants, cluster schemes, and direct assistance for medicinal flora',
          style: TextStyle(fontSize: 13.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
        ),
        const SizedBox(height: 16),

        ...farmerVM.schemes.map((scheme) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    scheme.subsidyRate,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFF2E7D32)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(scheme.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(scheme.agency, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight)),
                const SizedBox(height: 12),
                Text(scheme.description, style: const TextStyle(fontSize: 14, height: 1.45)),
                const SizedBox(height: 14),

                // Eligibility
                const Text('Eligibility Criteria:', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                ...scheme.eligibilityCriteria.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_rounded, size: 16, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(c, style: const TextStyle(fontSize: 13, height: 1.35))),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),

                // Required Documents
                const Text('Required Documents:', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                ...scheme.requiredDocuments.map((doc) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.description_outlined, size: 15, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Expanded(child: Text(doc, style: const TextStyle(fontSize: 13, height: 1.35))),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),

                // Helpline & Portal
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF7FAF8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.support_agent_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Helpline: ${scheme.helplineNumber}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TAB 4: MARKET RATES (e-CHARAK MANDI BENCHMARKS)
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildMarketRatesTab(FarmerViewModel farmerVM, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wholesale Market Price Bands',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
        ),
        const SizedBox(height: 4),
        Text(
          'Reference benchmark rates compiled from e-Charak and APMC Neemuch trading bulletins',
          style: TextStyle(fontSize: 13.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
        ),
        const SizedBox(height: 16),

        ...farmerVM.benchmarks.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.cropName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          Text(item.botanicalName, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: isDark ? AppColors.mint : const Color(0xFF2E7D32))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.trend,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Text(
                  item.wholesalePriceBand,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2E7D32), letterSpacing: -0.5),
                ),
                const SizedBox(height: 6),
                Text('Quality Standard: ${item.grade}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Trading Hub: ${item.majorMandi}', style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight)),
                const SizedBox(height: 6),
                Text(item.demandLevel, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: isDark ? Colors.white70 : const Color(0xFF374151))),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // ADD NEW CROP MODAL (SQLITE CRUD + AUTO-HARVEST DATES)
  // ════════════════════════════════════════════════════════════════════════
  void _showAddCropSheet(BuildContext context, FarmerViewModel farmerVM) {
    String selectedSpecies = 'Ashwagandha';
    final plotCtrl = TextEditingController(text: '1.0 Acre');
    final sowDateCtrl = TextEditingController(text: DateTime.now().toString().substring(0, 10));
    final harvDateCtrl = TextEditingController(
      text: farmerVM.calculateEstimatedHarvest('Ashwagandha', DateTime.now()),
    );
    final qtyCtrl = TextEditingController(text: '750 kg dried roots');
    final notesCtrl = TextEditingController();
    String selectedStage = 'Sowing / Germination';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: 22,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Record New Sowing Batch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Text('Saved instantly to SQLite database and synced to cloud.', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 16),

                    // Plant species picker
                    const Text('Select Botanical Species:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedSpecies,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      items: farmerVM.dossiers.map((d) {
                        return DropdownMenuItem(value: d.speciesName, child: Text(d.speciesName));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            selectedSpecies = val;
                            harvDateCtrl.text = farmerVM.calculateEstimatedHarvest(val, DateTime.parse(sowDateCtrl.text));
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Growth Stage
                    const Text('Initial Growth Stage:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedStage,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Sowing / Germination', child: Text('Sowing / Germination')),
                        DropdownMenuItem(value: 'Vegetative Growth', child: Text('Vegetative Growth')),
                        DropdownMenuItem(value: 'Flowering Stage', child: Text('Flowering Stage')),
                        DropdownMenuItem(value: 'Harvest Ready', child: Text('Harvest Ready')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedStage = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Sowing & Harvest Date
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: sowDateCtrl,
                            decoration: InputDecoration(
                              labelText: 'Sowing Date',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: harvDateCtrl,
                            decoration: InputDecoration(
                              labelText: 'Auto Harvest Date',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Plot area & estimated quantity
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: plotCtrl,
                            decoration: InputDecoration(
                              labelText: 'Plot Area (e.g. 1 Acre)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: qtyCtrl,
                            decoration: InputDecoration(
                              labelText: 'Target Yield (e.g. 800 kg)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Notes
                    TextField(
                      controller: notesCtrl,
                      decoration: InputDecoration(
                        labelText: 'Plot Notes / Seed Lot #',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await farmerVM.addCrop(
                            plantName: selectedSpecies,
                            stage: selectedStage,
                            sowingDate: sowDateCtrl.text.trim(),
                            expectedHarvest: harvDateCtrl.text.trim(),
                            plotArea: plotCtrl.text.trim(),
                            quantity: qtyCtrl.text.trim(),
                            notes: notesCtrl.text.trim(),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saved $selectedSpecies batch to local SQLite.')),
                            );
                          }
                        },
                        child: const Text('Save Crop Record (SQLite + Cloud)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
