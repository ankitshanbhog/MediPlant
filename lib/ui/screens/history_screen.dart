import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/database_helper.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/confidence_indicator.dart';
import '../widgets/state_views.dart';
import 'plant_detail_screen.dart';

/// Screen displaying previously identified plant scans
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyVM = context.watch<HistoryViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          if (historyVM.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear History',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Scan History?'),
                    content: const Text('This will remove all saved scans from local history.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.confidenceLow),
                        onPressed: () {
                          historyVM.clearAll();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear All', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              onChanged: (val) => historyVM.setFilterQuery(val),
              decoration: InputDecoration(
                hintText: 'Filter history by plant name...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceLight,
              ),
            ),
          ),

          Expanded(
            child: historyVM.items.isEmpty
                ? const EmptyStateView(
                    icon: Icons.history_rounded,
                    title: 'No Scans Recorded',
                    message: 'Your previously identified plants will appear here with timestamp logs and confidence scores.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    itemCount: historyVM.items.length,
                    itemBuilder: (context, index) {
                      final item = historyVM.items[index];
                      final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(item.timestamp);

                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.confidenceLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.white),
                        ),
                        onDismissed: (_) => historyVM.deleteItem(item.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: InkWell(
                            onTap: () async {
                              if (item.plantId != null) {
                                final matched = await DatabaseHelper.instance.getPlantById(item.plantId!);
                                if (matched != null && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlantDetailScreen(plant: matched),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(color: AppColors.lightMint, borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.spa, color: AppColors.primary),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.plantName,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.scientificName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ConfidenceIndicator(
                                  confidence: item.confidence,
                                  sourceLabel: '',
                                  isCompact: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
