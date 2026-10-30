import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/farmer_viewmodel.dart';

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

    // Route guard check
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text(
          'Farmer & Grower Hub',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, letterSpacing: -0.3),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: 'Edit Grower Profile',
            onPressed: () => _showEditProfileSheet(context, farmerVM),
          ),
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
                  _buildGrowerHeroHeader(context, farmerVM),
                  const SizedBox(height: 14),
                  _buildStatsRow(farmerVM),
                  const SizedBox(height: 16),
                  _buildCategoryTabs(farmerVM),
                  const SizedBox(height: 14),
                  _buildActiveTabView(context, farmerVM),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  // ── 1. Hero Header & Trust Verification ───────────────────────────────────
  Widget _buildGrowerHeroHeader(BuildContext context, FarmerViewModel farmerVM) {
    final profile = farmerVM.profile ?? {};
    final isVerified = farmerVM.overview?['is_verified'] == true;
    final farmName = profile['farm_name'] ?? 'Medicinal Herbal Estate';
    final region = profile['region'] ?? 'Western Ghats Foothills';
    final method = profile['farming_method'] ?? 'Natural Farming';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.nature_people_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            region,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showVerificationInfo(context, isVerified),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isVerified ? const Color(0xFF10B981) : Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isVerified ? Icons.verified_rounded : Icons.pending_rounded, size: 13, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        isVerified ? 'VERIFIED' : 'PENDING',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.eco_rounded, size: 13, color: Color(0xFF86EFAC)),
                const SizedBox(width: 6),
                Text(
                  method,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Metric Stat Cards ──────────────────────────────────────────────────
  Widget _buildStatsRow(FarmerViewModel farmerVM) {
    final stats = farmerVM.overview?['stats'] ?? {};
    final activeCrops = stats['active_crops'] ?? farmerVM.crops.length;
    final inStockBatches = stats['in_stock_batches'] ?? farmerVM.stockBatches.length;
    final totalStockKg = stats['total_stock_kg'] ?? 0;
    final pendingInquiries = stats['pending_inquiries'] ?? farmerVM.inquiries.where((i) => i['status'] == 'pending').length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            label: 'Crops in Field',
            value: '$activeCrops',
            unit: 'batches',
            icon: Icons.grass_rounded,
            color: const Color(0xFF047857),
            onTap: () => farmerVM.setTabIndex(0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            label: 'Stock Ready',
            value: '$inStockBatches',
            unit: '$totalStockKg kg',
            icon: Icons.inventory_2_rounded,
            color: const Color(0xFF1D4ED8),
            onTap: () => farmerVM.setTabIndex(1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            label: 'Inquiries',
            value: '$pendingInquiries',
            unit: 'pending',
            icon: Icons.mark_chat_unread_rounded,
            color: const Color(0xFFD97706),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
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

  // ── 3. Segmented Horizontal Category Tabs ─────────────────────────────────
  Widget _buildCategoryTabs(FarmerViewModel farmerVM) {
    final tabs = [
      {'title': 'Crop Calendar', 'icon': Icons.calendar_today_rounded},
      {'title': 'Stock & Batches', 'icon': Icons.all_inbox_rounded},
      {'title': 'Buyer Inquiries', 'icon': Icons.chat_bubble_outline_rounded},
      {'title': 'Cultivation Guide', 'icon': Icons.menu_book_rounded},
      {'title': 'Market Signals', 'icon': Icons.trending_up_rounded},
      {'title': 'Govt Schemes', 'icon': Icons.account_balance_rounded},
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
                color: isSelected ? Colors.white : const Color(0xFF166534),
              ),
              label: Text(
                tab['title'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF166534),
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFF15803D),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? const Color(0xFF15803D) : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (_) => farmerVM.setTabIndex(idx),
            ),
          );
        }),
      ),
    );
  }

  // ── 4. Active Tab Content Dispatcher ──────────────────────────────────────
  Widget _buildActiveTabView(BuildContext context, FarmerViewModel farmerVM) {
    switch (farmerVM.selectedTabIndex) {
      case 0:
        return _buildCropCalendarView(context, farmerVM);
      case 1:
        return _buildStockBatchesView(context, farmerVM);
      case 2:
        return _buildInquiriesView(context, farmerVM);
      case 3:
        return _buildCultivationGuideView(farmerVM);
      case 4:
        return _buildMarketSignalsView(farmerVM);
      case 5:
        return _buildGovtSchemesView(farmerVM);
      default:
        return _buildCropCalendarView(context, farmerVM);
    }
  }

  // ── TAB 1: Crop Planning & Harvest Calendar ───────────────────────────────
  Widget _buildCropCalendarView(BuildContext context, FarmerViewModel farmerVM) {
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
            const Text('Active Crop Batches', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('${farmerVM.crops.length} species', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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

          Color stageBg = const Color(0xFFE8F5E9);
          Color stageColor = const Color(0xFF2E7D32);
          if (stage.contains('Harvest')) {
            stageBg = const Color(0xFFFEF3C7);
            stageColor = const Color(0xFFB45309);
          } else if (stage.contains('Flowering')) {
            stageBg = const Color(0xFFEDE9FE);
            stageColor = const Color(0xFF6D28D9);
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(plantName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18),
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
                        Text(qty, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (sowing != null && sowing.isNotEmpty) ...[
                        const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Sown: $sowing', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                        const SizedBox(width: 14),
                      ],
                      if (harvest != null && harvest.isNotEmpty) ...[
                        const Icon(Icons.event_available_rounded, size: 13, color: Color(0xFF047857)),
                        const SizedBox(width: 4),
                        Text('Harvest: $harvest', style: const TextStyle(fontSize: 11, color: Color(0xFF047857), fontWeight: FontWeight.bold)),
                      ],
                    ],
                  ),
                  if (notes != null && notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                      child: Text(notes, style: TextStyle(fontSize: 11, color: Colors.grey.shade800)),
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

  // ── TAB 2: Stock & Batch Management ───────────────────────────────────────
  Widget _buildStockBatchesView(BuildContext context, FarmerViewModel farmerVM) {
    if (farmerVM.stockBatches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.all_inbox_rounded,
        title: 'No inventory batches',
        subtitle: 'Log harvested planting materials, dried roots, and available quantities.',
        buttonLabel: 'Add Stock Batch',
        onTap: () => _showAddStockDialog(context, farmerVM),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Harvest Batches in Storage', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('${farmerVM.stockBatches.length} items', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 8),
        ...farmerVM.stockBatches.map((b) {
          final id = b['id'] as int;
          final plantName = b['plant_name'] ?? 'Botanical Batch';
          final state = b['state'] ?? 'Fresh';
          final qty = b['quantity'] ?? 0;
          final unit = b['unit'] ?? 'kg';
          final qNotes = b['quality_notes'];
          final status = b['status'] ?? 'In Stock';
          final price = b['price_per_unit'];

          Color statusColor;
          switch (status) {
            case 'In Stock':
              statusColor = const Color(0xFF047857);
              break;
            case 'Reserved':
              statusColor = const Color(0xFFD97706);
              break;
            default:
              statusColor = Colors.grey;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(plantName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18),
                        onSelected: (val) {
                          if (val == 'delete') {
                            farmerVM.deleteStockBatch(id);
                          } else {
                            farmerVM.updateStockStatus(id, val);
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(value: 'In Stock', child: Text('Status: In Stock')),
                          const PopupMenuItem(value: 'Reserved', child: Text('Status: Reserved')),
                          const PopupMenuItem(value: 'Sold Out', child: Text('Status: Sold Out')),
                          const PopupMenuDivider(),
                          const PopupMenuItem(value: 'delete', child: Text('Delete Batch', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(6)),
                        child: Text(state, style: const TextStyle(color: Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text('$qty $unit', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                      if (price != null && price.isNotEmpty) ...[
                        const Spacer(),
                        Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                      if (qNotes != null && qNotes.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '• $qNotes',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  // ── TAB 3: Buyer Inquiries ────────────────────────────────────────────────
  Widget _buildInquiriesView(BuildContext context, FarmerViewModel farmerVM) {
    if (farmerVM.inquiries.isEmpty) {
      return _buildEmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'No buyer inquiries yet',
        subtitle: 'Inbound requests from laboratories, buyers, and nurseries appear here.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Procurement Inquiries', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('${farmerVM.inquiries.length} total', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 8),
        ...farmerVM.inquiries.map((inq) {
          final id = inq['id'] as int;
          final buyerName = inq['buyer_name'] ?? 'Buyer';
          final buyerContact = inq['buyer_contact'] ?? '';
          final plantName = inq['plant_name'] ?? '';
          final qty = inq['requested_qty'] ?? '';
          final message = inq['message'] ?? '';
          final status = inq['status'] ?? 'pending';

          Color statusBg = Colors.grey.shade100;
          Color statusText = Colors.grey.shade700;
          if (status == 'accepted') {
            statusBg = const Color(0xFFE8F5E9);
            statusText = const Color(0xFF2E7D32);
          } else if (status == 'declined') {
            statusBg = const Color(0xFFFFEBEE);
            statusText = Colors.red;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(buyerName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                        child: Text(status.toUpperCase(), style: TextStyle(color: statusText, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(buyerContact, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAF8), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Requested: $qty of $plantName', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                        if (message.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(message, style: TextStyle(fontSize: 11, color: Colors.grey.shade800)),
                        ],
                      ],
                    ),
                  ),
                  if (status == 'pending') ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: () => farmerVM.respondToInquiry(id, 'declined'),
                          child: const Text('Decline', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF166534),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          ),
                          onPressed: () => farmerVM.respondToInquiry(id, 'accepted'),
                          child: const Text('Accept Inquiry', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
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

  // ── TAB 4: Cultivation Assistant (Documented Agronomy) ─────────────────────
  Widget _buildCultivationGuideView(FarmerViewModel farmerVM) {
    final guides = farmerVM.cultivationGuides;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Botanical Agronomy Guides', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Documented guidance on soil, climate, spacing, and post-harvest handling.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 10),
        ...guides.map((g) {
          final species = g['species'] ?? 'Botanical Species';
          final part = g['primary_part'] ?? 'Whole Herb';

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: const Icon(Icons.eco_rounded, color: Color(0xFF166534)),
              title: Text(species, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text('Primary Harvest: $part', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildGuideRow(Icons.landscape_rounded, 'Soil & pH', g['soil']),
                _buildGuideRow(Icons.wb_sunny_rounded, 'Sunlight', g['sunlight']),
                _buildGuideRow(Icons.thermostat_rounded, 'Climate', g['climate']),
                _buildGuideRow(Icons.water_drop_rounded, 'Irrigation', g['irrigation']),
                _buildGuideRow(Icons.grid_4x4_rounded, 'Spacing', g['spacing']),
                _buildGuideRow(Icons.bug_report_rounded, 'Pests & Management', g['pests']),
                _buildGuideRow(Icons.agriculture_rounded, 'Harvesting Time', g['harvesting']),
                _buildGuideRow(Icons.inventory_2_rounded, 'Post-Harvest Curing', g['post_harvest']),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGuideRow(IconData icon, String title, String? desc) {
    if (desc == null || desc.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF166534)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.4),
                children: [
                  TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 5: Market Signals & Price Benchmarks ───────────────────────────────
  Widget _buildMarketSignalsView(FarmerViewModel farmerVM) {
    final benchmarks = (farmerVM.marketInfo?['benchmarks'] as List?) ?? [];
    final disclaimer = farmerVM.marketInfo?['disclaimer_notice'] ?? 'Benchmark reference only.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF1D4ED8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  disclaimer,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF1E40AF), height: 1.4),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(crop, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                        child: Text(trend, style: const TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF047857))),
                  const SizedBox(height: 6),
                  Text(signal, style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.3)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.verified_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text('Source: $source • $lastUp', style: TextStyle(fontSize: 10, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis),
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

  // ── TAB 6: Government Schemes & Directory ──────────────────────────────────
  Widget _buildGovtSchemesView(FarmerViewModel farmerVM) {
    final schemes = farmerVM.agriculturalResources;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Government Schemes & Agronomy Helplines', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Verified subsidies, cultivation support, and official institutional contacts.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 10),
        ...schemes.map((s) {
          final title = s['title'] ?? '';
          final agency = s['agency'] ?? '';
          final summary = s['scheme_summary'] ?? '';
          final eligibility = s['eligibility'] ?? '';
          final contact = s['contact'] ?? '';
          final checked = s['last_checked'] ?? '';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.account_balance_rounded, size: 20, color: Color(0xFF166534)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(agency, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(summary, style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.4)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Eligibility:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const SizedBox(height: 2),
                        Text(eligibility, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.phone_in_talk_rounded, size: 12, color: Color(0xFF166534)),
                          const SizedBox(width: 4),
                          Text(contact, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                        ],
                      ),
                      Text('Verified: $checked', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
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

  // ── Modals & Dialogs ──────────────────────────────────────────────────────
  Widget? _buildContextualFAB(FarmerViewModel farmerVM) {
    if (farmerVM.selectedTabIndex == 0) {
      return FloatingActionButton.extended(
        onPressed: () => _showAddCropDialog(context, farmerVM),
        backgroundColor: const Color(0xFF166534),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Crop Batch', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else if (farmerVM.selectedTabIndex == 1) {
      return FloatingActionButton.extended(
        onPressed: () => _showAddStockDialog(context, farmerVM),
        backgroundColor: const Color(0xFF15803D),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.post_add_rounded),
        label: const Text('Add Harvest Stock', style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _showAddStockDialog(BuildContext context, FarmerViewModel farmerVM) {
    final plantCtrl = TextEditingController();
    final stateCtrl = TextEditingController(text: 'Sun-Dried');
    final qtyCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'kg');
    final priceCtrl = TextEditingController(text: '₹');
    final qNotesCtrl = TextEditingController(text: 'Grade A Certified Organic');

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
                const Text('Log Harvest Stock Batch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(
                  controller: plantCtrl,
                  decoration: const InputDecoration(labelText: 'Plant Name (e.g. Ashwagandha Roots)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: stateCtrl,
                  decoration: const InputDecoration(labelText: 'Physical State (Fresh / Sun-Dried / Powder)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: unitCtrl,
                        decoration: const InputDecoration(labelText: 'Unit (kg / bundles)', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(labelText: 'Price per Unit (e.g. ₹450/kg)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: qNotesCtrl,
                  decoration: const InputDecoration(labelText: 'Quality Notes & Curing Method', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () async {
                      final q = double.tryParse(qtyCtrl.text.trim()) ?? 0.0;
                      if (plantCtrl.text.trim().isEmpty || q <= 0) return;
                      Navigator.pop(ctx);
                      await farmerVM.addStockBatch(
                        plantName: plantCtrl.text.trim(),
                        state: stateCtrl.text.trim(),
                        quantity: q,
                        unit: unitCtrl.text.trim(),
                        pricePerUnit: priceCtrl.text.trim(),
                        qualityNotes: qNotesCtrl.text.trim(),
                      );
                    },
                    child: const Text('Add to Stock', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileSheet(BuildContext context, FarmerViewModel farmerVM) {
    final prof = farmerVM.profile ?? {};
    final farmCtrl = TextEditingController(text: prof['farm_name'] ?? '');
    final regionCtrl = TextEditingController(text: prof['region'] ?? '');
    final methodCtrl = TextEditingController(text: prof['farming_method'] ?? 'Certified Organic');
    final expCtrl = TextEditingController(text: (prof['experience_years'] ?? 3).toString());
    final phoneCtrl = TextEditingController(text: prof['contact_phone'] ?? '');
    final bioCtrl = TextEditingController(text: prof['bio'] ?? '');

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
                const Text('Update Grower Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(controller: farmCtrl, decoration: const InputDecoration(labelText: 'Farm / Estate Name', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: regionCtrl, decoration: const InputDecoration(labelText: 'Geographic Region / District', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: methodCtrl, decoration: const InputDecoration(labelText: 'Farming Method (e.g. Certified Organic, Natural Farming)', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: expCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of Experience', border: OutlineInputBorder()))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Contact Phone', border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: bioCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'About Farm & Crop Varieties', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF166534), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await farmerVM.updateProfile(
                        farmName: farmCtrl.text.trim(),
                        region: regionCtrl.text.trim(),
                        farmingMethod: methodCtrl.text.trim(),
                        experienceYears: int.tryParse(expCtrl.text.trim()) ?? 1,
                        bio: bioCtrl.text.trim(),
                        contactPhone: phoneCtrl.text.trim(),
                      );
                    },
                    child: const Text('Save Grower Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVerificationInfo(BuildContext context, bool isVerified) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(isVerified ? Icons.verified_rounded : Icons.pending_rounded, color: isVerified ? const Color(0xFF10B981) : Colors.amber.shade700),
            const SizedBox(width: 8),
            Text(isVerified ? 'Verified Grower' : 'Pending Verification'),
          ],
        ),
        content: Text(
          isVerified
              ? 'Your grower profile is botanically authenticated by MediPlant botanical reviewers. Buyers and herbal pharmacists see your verified credentials on stock listings.'
              : 'Your verification request is currently under review by our botanical team. You can continue managing crops and stock in the meantime.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonLabel,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 44, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
  }
}
