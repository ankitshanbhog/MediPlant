import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'mock/mock_diseases_data.dart';
import 'mock/mock_plants_data.dart';
import 'mock/mock_remedies_data.dart';
import 'models/disease_model.dart';
import 'models/history_item_model.dart';
import 'models/plant_model.dart';
import 'models/remedy_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mediplant.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 7,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE plants ADD COLUMN appearance TEXT NOT NULL DEFAULT ""');
        await db.execute('ALTER TABLE plants ADD COLUMN plantType TEXT NOT NULL DEFAULT "Medicinal Herb"');
      } catch (_) {}
    }
    if (oldVersion < 3) {
      
      final batch = db.batch();
      for (final p in mockPlants) {
        batch.insert(
          'plants',
          {
            'id': p.id,
            'commonName': p.commonName,
            'scientificName': p.scientificName,
            'family': p.family,
            'vernacularNames': jsonEncode(p.vernacularNames),
            'description': p.description,
            'imageUrl': p.imageUrl,
            'medicinalUses': jsonEncode(p.medicinalUses),
            'healthBenefits': jsonEncode(p.healthBenefits),
            'traditionalUses': jsonEncode(p.traditionalUses),
            'activeConstituents': jsonEncode(p.activeConstituents),
            'partsUsed': jsonEncode(p.partsUsed),
            'sideEffects': jsonEncode(p.sideEffects),
            'precautions': jsonEncode(p.precautions),
            'contraindications': jsonEncode(p.contraindications),
            'preparationMethods': p.preparationMethods,
            'dosageGuidelines': p.dosageGuidelines,
            'habitat': p.habitat,
            'appearance': p.appearance,
            'plantType': p.plantType,
            'isSupportedInModel2': p.isSupportedInModel2 ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS app_settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 5) {
      
      final batch = db.batch();
      for (final p in mockPlants) {
        batch.insert(
          'plants',
          {
            'id': p.id,
            'commonName': p.commonName,
            'scientificName': p.scientificName,
            'family': p.family,
            'vernacularNames': jsonEncode(p.vernacularNames),
            'description': p.description,
            'imageUrl': p.imageUrl,
            'medicinalUses': jsonEncode(p.medicinalUses),
            'healthBenefits': jsonEncode(p.healthBenefits),
            'traditionalUses': jsonEncode(p.traditionalUses),
            'activeConstituents': jsonEncode(p.activeConstituents),
            'partsUsed': jsonEncode(p.partsUsed),
            'sideEffects': jsonEncode(p.sideEffects),
            'precautions': jsonEncode(p.precautions),
            'contraindications': jsonEncode(p.contraindications),
            'preparationMethods': p.preparationMethods,
            'dosageGuidelines': p.dosageGuidelines,
            'habitat': p.habitat,
            'appearance': p.appearance,
            'plantType': p.plantType,
            'isSupportedInModel2': p.isSupportedInModel2 ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      for (final d in mockDiseases) {
        batch.insert(
          'diseases',
          {
            'id': d.id,
            'name': d.name,
            'category': d.category,
            'description': d.description,
            'symptoms': jsonEncode(d.symptoms),
            'iconName': d.iconName,
            'relatedPlantIds': jsonEncode(d.relatedPlantIds),
            'homeRemedyIds': jsonEncode(d.homeRemedyIds),
            'medicalDisclaimer': d.medicalDisclaimer,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      for (final r in mockRemedies) {
        batch.insert(
          'remedies',
          {
            'id': r.id,
            'condition': r.condition,
            'title': r.title,
            'primaryPlantName': r.primaryPlantName,
            'primaryPlantScientific': r.primaryPlantScientific,
            'plantId': r.plantId,
            'ingredients': jsonEncode(r.ingredients),
            'preparationSteps': jsonEncode(r.preparationSteps),
            'howToUse': r.howToUse,
            'dosage': r.dosage,
            'precautions': jsonEncode(r.precautions),
            'category': r.category,
            'timeToPrepare': r.timeToPrepare,
            'isEducationalOnly': r.isEducationalOnly ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    }
    if (oldVersion < 6) {
      // Clean up legacy plants not part of the verified botanical species
      final validIds = mockPlants.map((p) => "'${p.id}'").join(',');
      await db.execute('DELETE FROM plants WHERE id NOT IN ($validIds)');
    }
    if (oldVersion < 7) {
      // Full reseed for the new MediPlant 10-class model.
      // Remove all existing plants, diseases, and remedies, then re-insert
      // the 10 supported classes with accurate, updated information.
      await db.execute('DELETE FROM plants');
      await db.execute('DELETE FROM diseases');
      await db.execute('DELETE FROM remedies');
      final batch = db.batch();
      for (final p in mockPlants) {
        batch.insert('plants', {
          'id': p.id,
          'commonName': p.commonName,
          'scientificName': p.scientificName,
          'family': p.family,
          'vernacularNames': jsonEncode(p.vernacularNames),
          'description': p.description,
          'imageUrl': p.imageUrl,
          'medicinalUses': jsonEncode(p.medicinalUses),
          'healthBenefits': jsonEncode(p.healthBenefits),
          'traditionalUses': jsonEncode(p.traditionalUses),
          'activeConstituents': jsonEncode(p.activeConstituents),
          'partsUsed': jsonEncode(p.partsUsed),
          'sideEffects': jsonEncode(p.sideEffects),
          'precautions': jsonEncode(p.precautions),
          'contraindications': jsonEncode(p.contraindications),
          'preparationMethods': p.preparationMethods,
          'dosageGuidelines': p.dosageGuidelines,
          'habitat': p.habitat,
          'appearance': p.appearance,
          'plantType': p.plantType,
          'isSupportedInModel2': p.isSupportedInModel2 ? 1 : 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final d in mockDiseases) {
        batch.insert('diseases', {
          'id': d.id,
          'name': d.name,
          'category': d.category,
          'description': d.description,
          'symptoms': jsonEncode(d.symptoms),
          'iconName': d.iconName,
          'relatedPlantIds': jsonEncode(d.relatedPlantIds),
          'homeRemedyIds': jsonEncode(d.homeRemedyIds),
          'medicalDisclaimer': d.medicalDisclaimer,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final r in mockRemedies) {
        batch.insert('remedies', {
          'id': r.id,
          'condition': r.condition,
          'title': r.title,
          'primaryPlantName': r.primaryPlantName,
          'primaryPlantScientific': r.primaryPlantScientific,
          'plantId': r.plantId,
          'ingredients': jsonEncode(r.ingredients),
          'preparationSteps': jsonEncode(r.preparationSteps),
          'howToUse': r.howToUse,
          'dosage': r.dosage,
          'precautions': jsonEncode(r.precautions),
          'category': r.category,
          'timeToPrepare': r.timeToPrepare,
          'isEducationalOnly': r.isEducationalOnly ? 1 : 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Plants Table
    await db.execute('''
      CREATE TABLE plants (
        id TEXT PRIMARY KEY,
        commonName TEXT NOT NULL,
        scientificName TEXT NOT NULL,
        family TEXT NOT NULL,
        vernacularNames TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        medicinalUses TEXT NOT NULL,
        healthBenefits TEXT NOT NULL,
        traditionalUses TEXT NOT NULL,
        activeConstituents TEXT NOT NULL,
        partsUsed TEXT NOT NULL,
        sideEffects TEXT NOT NULL,
        precautions TEXT NOT NULL,
        contraindications TEXT NOT NULL,
        preparationMethods TEXT NOT NULL,
        dosageGuidelines TEXT NOT NULL,
        habitat TEXT NOT NULL,
        appearance TEXT NOT NULL DEFAULT "",
        plantType TEXT NOT NULL DEFAULT "Medicinal Herb",
        isSupportedInModel2 INTEGER NOT NULL
      )
    ''');

    // 2. Diseases Table
    await db.execute('''
      CREATE TABLE diseases (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        symptoms TEXT NOT NULL,
        iconName TEXT NOT NULL,
        relatedPlantIds TEXT NOT NULL,
        homeRemedyIds TEXT NOT NULL,
        medicalDisclaimer TEXT NOT NULL
      )
    ''');

    // 3. Remedies Table
    await db.execute('''
      CREATE TABLE remedies (
        id TEXT PRIMARY KEY,
        condition TEXT NOT NULL,
        title TEXT NOT NULL,
        primaryPlantName TEXT NOT NULL,
        primaryPlantScientific TEXT NOT NULL,
        plantId TEXT,
        ingredients TEXT NOT NULL,
        preparationSteps TEXT NOT NULL,
        howToUse TEXT NOT NULL,
        dosage TEXT NOT NULL,
        precautions TEXT NOT NULL,
        category TEXT NOT NULL,
        timeToPrepare TEXT NOT NULL,
        isEducationalOnly INTEGER NOT NULL
      )
    ''');

    // 4. Scan History Table
    await db.execute('''
      CREATE TABLE scan_history (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        plantName TEXT NOT NULL,
        scientificName TEXT NOT NULL,
        plantId TEXT,
        confidence REAL NOT NULL,
        status TEXT NOT NULL,
        source TEXT NOT NULL,
        imagePath TEXT,
        thumbnailAsset TEXT
      )
    ''');

    // 5. App Settings Table
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Initial Data Seeding
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    final batch = db.batch();

    for (final p in mockPlants) {
      batch.insert('plants', {
        'id': p.id,
        'commonName': p.commonName,
        'scientificName': p.scientificName,
        'family': p.family,
        'vernacularNames': jsonEncode(p.vernacularNames),
        'description': p.description,
        'imageUrl': p.imageUrl,
        'medicinalUses': jsonEncode(p.medicinalUses),
        'healthBenefits': jsonEncode(p.healthBenefits),
        'traditionalUses': jsonEncode(p.traditionalUses),
        'activeConstituents': jsonEncode(p.activeConstituents),
        'partsUsed': jsonEncode(p.partsUsed),
        'sideEffects': jsonEncode(p.sideEffects),
        'precautions': jsonEncode(p.precautions),
        'contraindications': jsonEncode(p.contraindications),
        'preparationMethods': p.preparationMethods,
        'dosageGuidelines': p.dosageGuidelines,
        'habitat': p.habitat,
        'appearance': p.appearance,
        'plantType': p.plantType,
        'isSupportedInModel2': p.isSupportedInModel2 ? 1 : 0,
      });
    }

    for (final d in mockDiseases) {
      batch.insert('diseases', {
        'id': d.id,
        'name': d.name,
        'category': d.category,
        'description': d.description,
        'symptoms': jsonEncode(d.symptoms),
        'iconName': d.iconName,
        'relatedPlantIds': jsonEncode(d.relatedPlantIds),
        'homeRemedyIds': jsonEncode(d.homeRemedyIds),
        'medicalDisclaimer': d.medicalDisclaimer,
      });
    }

    for (final r in mockRemedies) {
      batch.insert('remedies', {
        'id': r.id,
        'condition': r.condition,
        'title': r.title,
        'primaryPlantName': r.primaryPlantName,
        'primaryPlantScientific': r.primaryPlantScientific,
        'plantId': r.plantId,
        'ingredients': jsonEncode(r.ingredients),
        'preparationSteps': jsonEncode(r.preparationSteps),
        'howToUse': r.howToUse,
        'dosage': r.dosage,
        'precautions': jsonEncode(r.precautions),
        'category': r.category,
        'timeToPrepare': r.timeToPrepare,
        'isEducationalOnly': r.isEducationalOnly ? 1 : 0,
      });
    }

    await batch.commit(noResult: true);
  }

  // --- Plant Queries ---
  Future<List<Plant>> getAllPlants() async {
    final db = await database;
    final validIds = mockPlants.map((p) => "'${p.id}'").join(',');
    final result = await db.rawQuery('SELECT * FROM plants WHERE id IN ($validIds) ORDER BY commonName ASC');
    if (result.isEmpty) {
      return mockPlants;
    }
    return result.map((row) => _rowToPlant(row)).toList();
  }

  Future<Plant?> getPlantById(String id) async {
    final db = await database;
    final normalized = id.toLowerCase().trim();

    // 1. Direct ID match
    final direct = await db.query(
      'plants',
      where: 'LOWER(id) = ?',
      whereArgs: [normalized],
      limit: 1,
    );
    if (direct.isNotEmpty) {
      return _rowToPlant(direct.first);
    }

    // 2. Alias variations (e.g., malabar_nut <-> malabar_nut_plant, insulin_plant <-> insulin)
    final aliases = <String>[
      normalized.replaceAll('_plant', ''),
      '${normalized.replaceAll('_plant', '')}_plant',
      if (normalized.contains('malabar_nut')) 'vasaka',
      if (normalized.contains('vasaka')) 'malabar_nut',
    ];

    for (final alias in aliases) {
      if (alias == normalized) continue;
      final res = await db.query(
        'plants',
        where: 'LOWER(id) = ?',
        whereArgs: [alias],
        limit: 1,
      );
      if (res.isNotEmpty) {
        return _rowToPlant(res.first);
      }
    }

    // 3. Fallback search by common name or scientific name containing normalized term
    final clean = normalized.replaceAll('_plant', '').replaceAll('_', ' ');
    final searchResult = await searchPlants(clean);
    if (searchResult.isNotEmpty) {
      return searchResult.first;
    }

    return null;
  }

  Future<List<Plant>> searchPlants(String query) async {
    final db = await database;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAllPlants();

    final result = await db.rawQuery('''
      SELECT * FROM plants 
      WHERE LOWER(commonName) LIKE ? 
         OR LOWER(scientificName) LIKE ? 
         OR LOWER(family) LIKE ? 
         OR LOWER(medicinalUses) LIKE ? 
         OR LOWER(vernacularNames) LIKE ?
    ''', ['%$q%', '%$q%', '%$q%', '%$q%', '%$q%']);

    return result.map((row) => _rowToPlant(row)).toList();
  }

  Future<List<Plant>> getFeaturedPlants() async {
    final db = await database;
    final result = await db.query('plants', limit: 6);
    return result.map((row) => _rowToPlant(row)).toList();
  }

  Future<List<Plant>> getPlantsByDisease(String diseaseId) async {
    final db = await database;
    final d = diseaseId.toLowerCase();
    final result = await db.rawQuery('''
      SELECT * FROM plants 
      WHERE LOWER(medicinalUses) LIKE ? 
         OR LOWER(traditionalUses) LIKE ?
    ''', ['%$d%', '%$d%']);
    return result.map((row) => _rowToPlant(row)).toList();
  }

  Plant _rowToPlant(Map<String, dynamic> row) {
    return Plant(
      id: row['id'] as String,
      commonName: row['commonName'] as String,
      scientificName: row['scientificName'] as String,
      family: row['family'] as String,
      vernacularNames: Map<String, String>.from(jsonDecode(row['vernacularNames'] as String)),
      description: row['description'] as String,
      imageUrl: row['imageUrl'] as String,
      medicinalUses: List<String>.from(jsonDecode(row['medicinalUses'] as String)),
      healthBenefits: List<String>.from(jsonDecode(row['healthBenefits'] as String)),
      traditionalUses: List<String>.from(jsonDecode(row['traditionalUses'] as String)),
      activeConstituents: List<String>.from(jsonDecode(row['activeConstituents'] as String)),
      partsUsed: List<String>.from(jsonDecode(row['partsUsed'] as String)),
      sideEffects: List<String>.from(jsonDecode(row['sideEffects'] as String)),
      precautions: List<String>.from(jsonDecode(row['precautions'] as String)),
      contraindications: List<String>.from(jsonDecode(row['contraindications'] as String)),
      preparationMethods: row['preparationMethods'] as String,
      dosageGuidelines: row['dosageGuidelines'] as String,
      habitat: row['habitat'] as String,
      appearance: (row['appearance'] as String?) ?? '',
      plantType: (row['plantType'] as String?) ?? 'Medicinal Plant',
      isSupportedInModel2: (row['isSupportedInModel2'] as int) == 1,
    );
  }

  // --- Disease Queries ---
  Future<List<Disease>> getAllDiseases() async {
    final db = await database;
    final result = await db.query('diseases');
    return result.map((row) => _rowToDisease(row)).toList();
  }

  Future<Disease?> getDiseaseById(String id) async {
    final db = await database;
    final result = await db.query(
      'diseases',
      where: 'LOWER(id) = ?',
      whereArgs: [id.toLowerCase()],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return _rowToDisease(result.first);
    }
    return null;
  }

  Future<List<Disease>> searchDiseases(String query) async {
    final db = await database;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAllDiseases();

    final result = await db.rawQuery('''
      SELECT * FROM diseases 
      WHERE LOWER(name) LIKE ? 
         OR LOWER(category) LIKE ? 
         OR LOWER(symptoms) LIKE ?
    ''', ['%$q%', '%$q%', '%$q%']);

    return result.map((row) => _rowToDisease(row)).toList();
  }

  Future<List<Disease>> getDiseasesByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'diseases',
      where: 'LOWER(category) = ?',
      whereArgs: [category.toLowerCase()],
    );
    return result.map((row) => _rowToDisease(row)).toList();
  }

  Disease _rowToDisease(Map<String, dynamic> row) {
    return Disease(
      id: row['id'] as String,
      name: row['name'] as String,
      category: row['category'] as String,
      description: row['description'] as String,
      symptoms: List<String>.from(jsonDecode(row['symptoms'] as String)),
      iconName: row['iconName'] as String,
      relatedPlantIds: List<String>.from(jsonDecode(row['relatedPlantIds'] as String)),
      homeRemedyIds: List<String>.from(jsonDecode(row['homeRemedyIds'] as String)),
      medicalDisclaimer: row['medicalDisclaimer'] as String,
    );
  }

  // --- Remedy Queries ---
  Future<List<Remedy>> getAllRemedies() async {
    final db = await database;
    final result = await db.query('remedies');
    return result.map((row) => _rowToRemedy(row)).toList();
  }

  Future<Remedy?> getRemedyById(String id) async {
    final db = await database;
    final result = await db.query(
      'remedies',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return _rowToRemedy(result.first);
    }
    return null;
  }

  Future<List<Remedy>> getRemediesForPlant(String plantId) async {
    final db = await database;
    final result = await db.query(
      'remedies',
      where: 'LOWER(plantId) = ?',
      whereArgs: [plantId.toLowerCase()],
    );
    return result.map((row) => _rowToRemedy(row)).toList();
  }

  Future<List<Remedy>> getRemediesForCondition(String condition) async {
    final db = await database;
    final q = condition.trim().toLowerCase();
    final result = await db.rawQuery('''
      SELECT * FROM remedies 
      WHERE LOWER(condition) LIKE ? 
         OR LOWER(category) LIKE ?
    ''', ['%$q%', '%$q%']);
    return result.map((row) => _rowToRemedy(row)).toList();
  }

  Future<List<Remedy>> searchRemedies(String query) async {
    final db = await database;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAllRemedies();

    final result = await db.rawQuery('''
      SELECT * FROM remedies 
      WHERE LOWER(title) LIKE ? 
         OR LOWER(condition) LIKE ? 
         OR LOWER(primaryPlantName) LIKE ? 
         OR LOWER(category) LIKE ? 
         OR LOWER(ingredients) LIKE ?
    ''', ['%$q%', '%$q%', '%$q%', '%$q%', '%$q%']);

    return result.map((row) => _rowToRemedy(row)).toList();
  }

  Remedy _rowToRemedy(Map<String, dynamic> row) {
    return Remedy(
      id: row['id'] as String,
      condition: row['condition'] as String,
      title: row['title'] as String,
      primaryPlantName: row['primaryPlantName'] as String,
      primaryPlantScientific: row['primaryPlantScientific'] as String,
      plantId: row['plantId'] as String?,
      ingredients: List<String>.from(jsonDecode(row['ingredients'] as String)),
      preparationSteps: List<String>.from(jsonDecode(row['preparationSteps'] as String)),
      howToUse: row['howToUse'] as String,
      dosage: row['dosage'] as String,
      precautions: List<String>.from(jsonDecode(row['precautions'] as String)),
      category: row['category'] as String,
      timeToPrepare: row['timeToPrepare'] as String,
      isEducationalOnly: (row['isEducationalOnly'] as int) == 1,
    );
  }

  // --- Scan History Queries ---
  Future<List<HistoryItem>> getHistory() async {
    final db = await database;
    final result = await db.query('scan_history', orderBy: 'timestamp DESC');
    return result.map((row) => HistoryItem.fromJson(row)).toList();
  }

  Future<void> addHistoryItem(HistoryItem item) async {
    final db = await database;
    await db.insert(
      'scan_history',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteHistoryItem(String id) async {
    final db = await database;
    await db.delete('scan_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('scan_history');
  }

  // --- App Settings (Cloud Server URL, etc.) ---
  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query('app_settings', where: 'key = ?', whereArgs: [key]);
    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
