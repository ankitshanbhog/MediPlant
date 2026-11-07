import '../../data/models/plant_model.dart';
import '../../data/mock/mock_remedies_data.dart';

class PlantSpeechHelper {
  static String getSpeechForSection(Plant plant, int sectionIndex) {
    switch (sectionIndex) {
      case 0:
        // Overview
        final parts = plant.partsUsed.isNotEmpty ? ' Medicinal plant parts used include: ${plant.partsUsed.join(', ')}.' : '';
        final appearance = plant.appearance.isNotEmpty ? ' Physical appearance: ${plant.appearance}.' : '';
        final habitat = plant.habitat.isNotEmpty ? ' Natural habitat: ${plant.habitat}.' : '';
        return 'Overview of ${plant.commonName}. '
            'Botanical scientific name: ${plant.scientificName}, belonging to the botanical family ${plant.family}. '
            '${plant.description}.$appearance$habitat$parts';

      case 1:
        // Medicinal Uses
        final uses = plant.medicinalUses.isNotEmpty
            ? 'Primary health conditions treated include: ${plant.medicinalUses.join('. ')}.'
            : '';
        final benefits = plant.healthBenefits.isNotEmpty
            ? ' Key health benefits: ${plant.healthBenefits.join('. ')}.'
            : '';
        return 'Medicinal uses of ${plant.commonName}. $uses$benefits';

      case 2:
        // Remedies
        final plantCleanId = plant.id.toLowerCase().replaceAll('_plant', '');
        final plantName = plant.commonName.toLowerCase();
        final plantSci = plant.scientificName.toLowerCase();

        final matching = mockRemedies.where((r) {
          final rPlantId = (r.plantId ?? '').toLowerCase().replaceAll('_plant', '');
          if (rPlantId.isNotEmpty && (rPlantId == plantCleanId || rPlantId == plant.id.toLowerCase())) {
            return true;
          }
          final rSci = r.primaryPlantScientific.toLowerCase();
          if (rSci.isNotEmpty && (rSci.contains(plantSci) || plantSci.contains(rSci))) {
            return true;
          }
          final rName = r.primaryPlantName.toLowerCase();
          if (rName.isNotEmpty && (rName.contains(plantName) || plantName.contains(rName))) {
            return true;
          }
          return false;
        }).toList();

        if (matching.isNotEmpty) {
          final titles = matching.map((r) => '${r.title} for ${r.condition}').join('. ');
          return 'Traditional remedies and recipes for ${plant.commonName}. Available recipes include: $titles. Tap any recipe card to review ingredients and preparation steps.';
        } else if (plant.traditionalUses.isNotEmpty || plant.preparationMethods.isNotEmpty) {
          final trad = plant.traditionalUses.isNotEmpty ? 'Traditional preparations: ${plant.traditionalUses.join('. ')}.' : '';
          final prep = plant.preparationMethods.isNotEmpty ? ' Preparation methods: ${plant.preparationMethods}.' : '';
          return 'Traditional remedies for ${plant.commonName}. $trad$prep';
        }
        return 'Traditional preparations and remedies for ${plant.commonName}.';

      case 3:
        // Safety & Dosage
        final dosage = plant.dosageGuidelines.isNotEmpty
            ? 'Dosage guidelines: ${plant.dosageGuidelines}.'
            : '';
        final precautions = plant.precautions.isNotEmpty
            ? ' Safety precautions: ${plant.precautions.join('. ')}.'
            : '';
        final sideEffects = plant.sideEffects.isNotEmpty
            ? ' Possible side effects: ${plant.sideEffects.join('. ')}.'
            : '';
        return 'Safety, dosage, and precautions for ${plant.commonName}. $dosage$precautions$sideEffects';

      case 4:
        // Botanical Science
        final vern = plant.vernacularNames.isNotEmpty
            ? ' Regional names: ${plant.vernacularNames.entries.map((e) => '${e.key}: ${e.value}').join(', ')}.'
            : '';
        final constituents = plant.activeConstituents.isNotEmpty
            ? ' Active bioactive compounds: ${plant.activeConstituents.join(', ')}.'
            : '';
        return 'Botanical science and taxonomy for ${plant.commonName}. '
            'Scientific binomial name: ${plant.scientificName}, Family: ${plant.family}, Plant type: ${plant.plantType}.$vern$constituents';

      default:
        return 'Botanical information for ${plant.commonName}. ${plant.description}';
    }
  }

  static String getSectionTitle(int sectionIndex) {
    switch (sectionIndex) {
      case 0:
        return 'Overview';
      case 1:
        return 'Medicinal Uses';
      case 2:
        return 'Remedies';
      case 3:
        return 'Safety & Dosage';
      case 4:
        return 'Botanical Science';
      default:
        return 'Overview';
    }
  }
}

