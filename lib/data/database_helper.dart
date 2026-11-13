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

    final db = await openDatabase(
      path,
      version: 8,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
    await _ensureFarmerTable(db);
    return db;
  }

  Future<void> _ensureFarmerTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS farmer_crops (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plantName TEXT NOT NULL,
        stage TEXT NOT NULL,
        sowingDate TEXT NOT NULL,
        expectedHarvest TEXT NOT NULL,
        plotArea TEXT,
        quantity TEXT,
        notes TEXT,
        isSynced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    try {
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM farmer_crops'),
      );
      if (count == null || count == 0) {
        final now = DateTime.now();
        final sow1 = now.subtract(const Duration(days: 55)).toString().substring(0, 10);
        final harv1 = now.add(const Duration(days: 105)).toString().substring(0, 10);
        final sow2 = now.subtract(const Duration(days: 40)).toString().substring(0, 10);
        final harv2 = now.add(const Duration(days: 40)).toString().substring(0, 10);

        await db.insert('farmer_crops', {
          'plantName': 'Ashwagandha (Withania somnifera)',
          'stage': 'Vegetative Growth',
          'sowingDate': sow1,
          'expectedHarvest': harv1,
          'plotArea': '1.5 Acres',
          'quantity': '850 kg dried roots (est.)',
          'notes': 'Raised bed line sowing; soil test pH 7.8. Certified organic seed batch #ASH-2026-B1.',
          'isSynced': 1,
        });

        await db.insert('farmer_crops', {
          'plantName': 'Tulsi (Holy Basil)',
          'stage': 'Flowering Stage',
          'sowingDate': sow2,
          'expectedHarvest': harv2,
          'plotArea': '0.75 Acres',
          'quantity': '420 kg dry leaf herbage',
          'notes': 'First harvest scheduled at 80% bloom; drip-irrigated plot.',
          'isSynced': 1,
        });
      }
    } catch (_) {}
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
      
      final validIds = mockPlants.map((p) => "'${p.id}'").join(',');
      await db.execute('DELETE FROM plants WHERE id NOT IN ($validIds)');
    }
    if (oldVersion < 7) {
      
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
    if (oldVersion < 8) {
      
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

    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

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

  Future<List<Plant>> getAllPlants() async {
    final db = await database;
    final result = await db.rawQuery('SELECT * FROM plants ORDER BY commonName ASC');
    if (result.isEmpty) {
      return mockPlants;
    }
    return result.map((row) => _rowToPlant(row)).toList();
  }

  Future<void> upsertPlant(Plant p) async {
    final db = await database;
    await db.insert(
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

  Future<Plant?> getPlantById(String id) async {
    final db = await database;
    final normalized = id.toLowerCase().trim();

    final direct = await db.query(
      'plants',
      where: 'LOWER(id) = ?',
      whereArgs: [normalized],
      limit: 1,
    );
    if (direct.isNotEmpty) {
      return _rowToPlant(direct.first);
    }

    final aliases = <String>[
      normalized.replaceAll('_plant', ''),
      '${normalized.replaceAll('_plant', '')}_plant',
      if (normalized.contains('aloe')) 'aloe_vera',
      if (normalized.contains('amla') || normalized.contains('gooseberry')) 'amla',
      if (normalized.contains('ashwagandha')) 'ashwagandha',
      if (normalized.contains('ayapana')) 'ayapana',
      if (normalized.contains('brahmi')) 'brahmi',
      if (normalized.contains('gotu_kola') || normalized.contains('centella') || normalized.contains('mandukaparni')) 'gotu_kola',
      if (normalized.contains('moringa') || normalized.contains('drumstick')) 'moringa',
      if (normalized.contains('multi_vitamin') || normalized.contains('chakra_muni') || normalized.contains('katuk')) 'multi_vitamin_plant',
      if (normalized.contains('neem') || normalized.contains('azadirachta')) 'neem',
      if (normalized.contains('rosemary')) 'rosemary',
      if (normalized.contains('sarpagandha') || normalized.contains('snakeroot') || normalized.contains('serpentina')) 'sarpagandha',
      if (normalized.contains('tulsi') || normalized.contains('holy_basil')) 'tulsi',
      if (normalized.contains('wood_apple') || normalized.contains('bael') || normalized.contains('limonia')) 'wood_apple',
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
    final id = row['id'] as String;
    Plant? mock;
    try {
      mock = mockPlants.firstWhere((p) => p.id == id);
    } catch (_) {}

    EvidenceLevel ev = mock?.evidenceLevel ?? EvidenceLevel.unknown;
    if (row['evidenceLevel'] != null) {
      final s = row['evidenceLevel'] as String;
      if (s == 'traditional') {
        ev = EvidenceLevel.traditional;
      } else if (s == 'lab') {
        ev = EvidenceLevel.lab;
      } else if (s == 'clinical') {
        ev = EvidenceLevel.clinical;
      }
    }

    List<String> drugInteractions = mock?.drugInteractions ?? const [];
    if (row['drugInteractions'] != null) {
      try {
        drugInteractions = List<String>.from(jsonDecode(row['drugInteractions'] as String));
      } catch (_) {}
    }

    List<String> sources = mock?.sources ?? const [];
    if (row['sources'] != null) {
      try {
        sources = List<String>.from(jsonDecode(row['sources'] as String));
      } catch (_) {}
    }

    List<String> lookAlikeNames = mock?.lookAlikeNames ?? const [];
    if (row['lookAlikeNames'] != null) {
      try {
        lookAlikeNames = List<String>.from(jsonDecode(row['lookAlikeNames'] as String));
      } catch (_) {}
    }

    return Plant(
      id: id,
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
      evidenceLevel: ev,
      drugInteractions: drugInteractions,
      sources: sources,
      lookAlikeNames: lookAlikeNames,
    );
  }

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

  // ── Farmer Local Database Methods ──
  Future<List<Map<String, dynamic>>> getLocalFarmerCrops() async {
    final db = await database;
    return await db.query('farmer_crops', orderBy: 'id DESC');
  }

  Future<int> insertLocalFarmerCrop(Map<String, dynamic> crop) async {
    final db = await database;
    return await db.insert('farmer_crops', crop);
  }

  Future<void> insertOrUpdateCloudCrop({
    required int id,
    required String plantName,
    required String stage,
    required String sowingDate,
    required String expectedHarvest,
    String? quantity,
    String? notes,
  }) async {
    final db = await database;
    await db.insert(
      'farmer_crops',
      {
        'id': id,
        'plantName': plantName,
        'stage': stage,
        'sowingDate': sowingDate,
        'expectedHarvest': expectedHarvest,
        'plotArea': '1.0 Acre',
        'quantity': quantity ?? '',
        'notes': notes ?? '',
        'isSynced': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLocalFarmerCropStage(int id, String newStage, {String? notes}) async {
    final db = await database;
    final data = <String, dynamic>{'stage': newStage};
    if (notes != null && notes.isNotEmpty) {
      data['notes'] = notes;
    }
    await db.update('farmer_crops', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteLocalFarmerCrop(int id) async {
    final db = await database;
    await db.delete('farmer_crops', where: 'id = ?', whereArgs: [id]);
  }
}
