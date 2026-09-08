import 'package:flutter/material.dart';

import '../../data/database_helper.dart';
import '../../data/models/plant_model.dart';
import '../theme/app_colors.dart';
import '../widgets/plant_card.dart';
import 'plant_detail_screen.dart';

/// Database-backed reference for every plant available to the application.
class PlantEncyclopediaScreen extends StatefulWidget {
  const PlantEncyclopediaScreen({super.key});

  @override
  State<PlantEncyclopediaScreen> createState() => _PlantEncyclopediaScreenState();
}

class _PlantEncyclopediaScreenState extends State<PlantEncyclopediaScreen> {
  late final Future<List<Plant>> _plants = DatabaseHelper.instance.getAllPlants();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Encyclopedia')),
      body: FutureBuilder<List<Plant>>(
        future: _plants,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final plants = (snapshot.data ?? []).where((plant) {
            final q = _query.toLowerCase().trim();
            return q.isEmpty || plant.commonName.toLowerCase().contains(q) || plant.scientificName.toLowerCase().contains(q);
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search plants by common or scientific name',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () => setState(() => _query = ''),
                          )
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${plants.length} plants in the encyclopedia', style: const TextStyle(color: AppColors.textMutedLight)),
                ),
              ),
              Expanded(
                child: plants.isEmpty
                    ? const Center(child: Text('No matching plant information is available yet.'))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: plants.length,
                        itemBuilder: (context, index) => PlantCard(
                          plant: plants[index],
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailScreen(plant: plants[index]))),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
