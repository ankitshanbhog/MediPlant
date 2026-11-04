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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmerViewModel>().loadFarmerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final farmerVM = context.watch<FarmerViewModel>();

    if (!authVM.isFarmer) {
      return Scaffold(
        appBar: AppBar(title: const Text('Farmer Workspace')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                const Text('Farmer Access Required', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Please sign in with a registered Farmer account to access cultivation tools and crop records.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
                  child: const Text('Return Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: Text(
          'Farmer Hub',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
            letterSpacing: -0.3,
            color: isDark ? AppColors.mint : const Color(0xFF1B5E20),
          ),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? AppColors.mint : const Color(0xFF1B5E20),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => farmerVM.loadFarmerData(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: _buildContextualFAB(farmerVM),
      body: farmerVM.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : RefreshIndicator(
              onRefresh: () => farmerVM.loadFarmerData(),
              color: const Color(0xFF2E7D32),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildFarmerHeroBanner(context, farmerVM),
                  const SizedBox(height: 14),
                  _buildStatsRow(farmerVM, isDark),
                  const SizedBox(height: 16),
                  _buildCategoryTabs(farmerVM, isDark),
                  const SizedBox(height: 14),
                  _buildActiveTabView(context, farmerVM),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildFarmerHeroBanner(BuildContext context, FarmerViewModel farmerVM) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF14532D), Color(0xFF166534)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14532D).withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medicinal Crop Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Crop calendar, agronomic cultivation guides & market benchmark signals',
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(FarmerViewModel farmerVM, bool isDark) {
    final activeCrops = farmerVM.crops.length;
    final totalGuides = farmerVM.cultivationGuides.length;
    final totalSignals = ((farmerVM.marketInfo?['benchmarks'] as List?) ?? []).length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            label: 'Crops Sown',
            value: '$activeCrops',
            unit: 'batches',
            icon: Icons.calendar_today_rounded,
            color: const Color(0xFF047857),
            isDark: isDark,
            onTap: () => farmerVM.setTabIndex(0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            label: 'Agronomy Guides',
            value: '$totalGuides',
            unit: 'species',
            icon: Icons.menu_book_rounded,
            color: const Color(0xFF1D4ED8),
            isDark: isDark,
            onTap: () => farmerVM.setTabIndex(1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            label: 'Market Signals',
            value: '$totalSignals',
            unit: 'benchmarks',
            icon: Icons.trending_up_rounded,
            color: const Color(0xFFD97706),
            isDark: isDark,
            onTap: () => farmerVM.setTabIndex(2),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              unit,
              style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(FarmerViewModel farmerVM, bool isDark) {
    final tabs = [
      {'title': 'Crop Planning & Calendar', 'icon': Icons.calendar_today_rounded},
      {'title': 'Agronomy Guides', 'icon': Icons.menu_book_rounded},
      {'title': 'Market Signals & Benchmarks', 'icon': Icons.trending_up_rounded},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (idx) {
          final isSelected = farmerVM.selectedTabIndex == idx;
          final tab = tabs[idx];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              avatar: Icon(
                tab['icon'] as IconData,
                size: 15,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.mint : const Color(0xFF166534)),
              ),
              label: Text(
                tab['title'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.mint : const Color(0xFF166534)),
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFF15803D),
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF15803D)
                    : (isDark ? AppColors.borderDark : Colors.grey.shade300),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (_) => farmerVM.setTabIndex(idx),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveTabView(BuildContext context, FarmerViewModel farmerVM) {
    switch (farmerVM.selectedTabIndex) {
      case 0:
        return _buildCropCalendarView(context, farmerVM);
      case 1:
        return _buildCultivationGuideView(farmerVM);
      case 2:
        return _buildMarketSignalsView(farmerVM);
      default:
        return _buildCropCalendarView(context, farmerVM);
    }
  }

  Widget _buildCropCalendarView(BuildContext context, FarmerViewModel farmerVM) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (farmerVM.crops.isEmpty) {
      return _buildEmptyState(
        icon: Icons.grass_rounded,
        title: 'No crops planned yet',
        subtitle: 'Track sowing dates, vegetative stages, and expected harvest windows.',
        buttonLabel: 'Record First Crop',
        onTap: () => _showAddCropDialog(context, farmerVM),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Crop Batches',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              '${farmerVM.crops.length} species',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...farmerVM.crops.map((c) {
          final id = c['id'] as int;
          final plantName = c['plant_name'] ?? 'Medicinal Plant';
          final stage = c['stage'] ?? 'Sowing';
          final sowing = c['sowing_date'];
          final harvest = c['expected_harvest'];
          final qty = c['quantity'];
          final notes = c['notes'];

          Color stageBg = isDark ? const Color(0xFF064E3B) : const Color(0xFFE8F5E9);
          Color stageColor = isDark ? const Color(0xFF34D399) : const Color(0xFF2E7D32);
          if (stage.contains('Harvest')) {
            stageBg = isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7);
            stageColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);
          } else if (stage.contains('Flowering')) {
            stageBg = isDark ? const Color(0xFF4C1D95) : const Color(0xFFEDE9FE);
            stageColor = isDark ? const Color(0xFFA78BFA) : const Color(0xFF6D28D9);
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            color: isDark ? AppColors.surfaceDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plantName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, size: 18, color: isDark ? Colors.grey.shade400 : Colors.black54),
                        onSelected: (val) {
                          if (val == 'delete') {
                            farmerVM.deleteCrop(id);
                          } else {
                            farmerVM.updateCropStage(id, val);
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(value: 'Sowing / Germination', child: Text('Stage: Sowing')),
                          const PopupMenuItem(value: 'Vegetative Growth', child: Text('Stage: Vegetative')),
                          const PopupMenuItem(value: 'Flowering Stage', child: Text('Stage: Flowering')),
                          const PopupMenuItem(value: 'Harvest Ready', child: Text('Stage: Harvest Ready')),
                          const PopupMenuItem(value: 'Post-Harvest Curing', child: Text('Stage: Post-Harvest')),
                          const PopupMenuDivider(),
                          const PopupMenuItem(value: 'delete', child: Text('Delete Record', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: stageBg, borderRadius: BorderRadius.circular(6)),
                        child: Text(stage, style: TextStyle(color: stageColor, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      if (qty != null && qty.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(qty, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (sowing != null && sowing.isNotEmpty) ...[
                        Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? Colors.grey.shade400 : Colors.grey),
                        const SizedBox(width: 4),
                        Text('Sown: $sowing', style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700)),
                        const SizedBox(width: 14),
                      ],
                      if (harvest != null && harvest.isNotEmpty) ...[
                        Icon(Icons.event_available_rounded, size: 13, color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857)),
                        const SizedBox(width: 4),
                        Text(
                          'Harvest: $harvest',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (notes != null && notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(notes, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800)),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCultivationGuideView(FarmerViewModel farmerVM) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final guides = farmerVM.cultivationGuides;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Botanical Agronomy Guides',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Documented guidance on soil, climate, spacing, and post-harvest handling.',
          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        ),
        const SizedBox(height: 10),
        ...guides.map((g) {
          final species = g['species'] ?? 'Botanical Species';
          final part = g['primary_part'] ?? 'Whole Herb';

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            color: isDark ? AppColors.surfaceDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: Icon(Icons.eco_rounded, color: isDark ? const Color(0xFF34D399) : const Color(0xFF166534)),
              title: Text(
                species,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                'Primary Harvest: $part',
                style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildGuideRow(Icons.landscape_rounded, 'Soil & pH', g['soil'], isDark),
                _buildGuideRow(Icons.wb_sunny_rounded, 'Sunlight', g['sunlight'], isDark),
                _buildGuideRow(Icons.thermostat_rounded, 'Climate', g['climate'], isDark),
                _buildGuideRow(Icons.water_drop_rounded, 'Irrigation', g['irrigation'], isDark),
                _buildGuideRow(Icons.grid_4x4_rounded, 'Spacing', g['spacing'], isDark),
                _buildGuideRow(Icons.bug_report_rounded, 'Pests & Management', g['pests'], isDark),
                _buildGuideRow(Icons.agriculture_rounded, 'Harvesting Time', g['harvesting'], isDark),
                _buildGuideRow(Icons.inventory_2_rounded, 'Post-Harvest Curing', g['post_harvest'], isDark),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGuideRow(IconData icon, String title, String? desc, bool isDark) {
    if (desc == null || desc.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: isDark ? const Color(0xFF34D399) : const Color(0xFF166534)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketSignalsView(FarmerViewModel farmerVM) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final benchmarks = (farmerVM.marketInfo?['benchmarks'] as List?) ?? [];
    final disclaimer = farmerVM.marketInfo?['disclaimer_notice'] ?? 'Benchmark reference only.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 16, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  disclaimer,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...benchmarks.map((b) {
          final crop = b['crop'] ?? '';
          final price = b['benchmark_price'] ?? '';
          final trend = b['trend'] ?? '';
          final signal = b['demand_signal'] ?? '';
          final source = b['source'] ?? '';
          final lastUp = b['last_updated'] ?? '';

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            color: isDark ? AppColors.surfaceDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        crop,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          trend,
                          style: TextStyle(
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF15803D),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF047857),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    signal,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.verified_outlined, size: 12, color: isDark ? Colors.grey.shade400 : Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Source: $source • $lastUp',
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget? _buildContextualFAB(FarmerViewModel farmerVM) {
    if (farmerVM.selectedTabIndex == 0) {
      return FloatingActionButton.extended(
        onPressed: () => _showAddCropDialog(context, farmerVM),
        backgroundColor: const Color(0xFF166534),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Crop Batch', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }
    return null;
  }

  void _showAddCropDialog(BuildContext context, FarmerViewModel farmerVM) {
    final plantCtrl = TextEditingController();
    final stageCtrl = TextEditingController(text: 'Sowing / Germination');
    final sowDateCtrl = TextEditingController(text: DateTime.now().toString().substring(0, 10));
    final harvDateCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Plan New Crop Batch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(
                  controller: plantCtrl,
                  decoration: const InputDecoration(labelText: 'Species (e.g. Ashwagandha, Gotu Kola)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: stageCtrl,
                  decoration: const InputDecoration(labelText: 'Growth Stage', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: sowDateCtrl,
                        decoration: const InputDecoration(labelText: 'Sowing Date', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: harvDateCtrl,
                        decoration: const InputDecoration(labelText: 'Expected Harvest', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: qtyCtrl,
                  decoration: const InputDecoration(labelText: 'Estimated Quantity (e.g. 50 kg dried roots)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Field Notes & Plot Details', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF166534), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () async {
                      if (plantCtrl.text.trim().isEmpty) return;
                      Navigator.pop(ctx);
                      await farmerVM.addCrop(
                        plantName: plantCtrl.text.trim(),
                        stage: stageCtrl.text.trim(),
                        sowingDate: sowDateCtrl.text.trim(),
                        expectedHarvest: harvDateCtrl.text.trim(),
                        quantity: qtyCtrl.text.trim(),
                        notes: notesCtrl.text.trim(),
                      );
                    },
                    child: const Text('Save Crop Record', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonLabel,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(icon, size: 44, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
                if (buttonLabel != null && onTap != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF166534), foregroundColor: Colors.white),
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(buttonLabel),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
