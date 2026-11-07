import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'voice_service.dart';

class FlutterTtsVoiceService implements VoiceTtsService {
  final FlutterTts _tts = FlutterTts();

  VoiceState _state = VoiceState.stopped;
  double _speechRate = 0.44; // Balanced, natural human conversational pacing
  double _pitch = 1.0;
  String _selectedVoiceName = '';

  final _stateController = StreamController<VoiceState>.broadcast();
  final _wordController = StreamController<String>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();
  final _sentenceController = StreamController<int>.broadcast();

  Timer? _waveformTimer;
  bool _initialized = false;

  List<String> _sentences = [];
  int _currentSentenceIndex = 0;
  List<Map<String, String>> _availableVoices = [];

  FlutterTtsVoiceService() {
    _init();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(1.0);
      await _tts.setPitch(_pitch);

      if (defaultTargetPlatform == TargetPlatform.android) {
        final engines = await _tts.getEngines;
        debugPrint('[TTS] Available engines: $engines');
        try {
          if (engines is List && engines.contains('com.google.android.tts')) {
            await _tts.setEngine('com.google.android.tts');
            debugPrint('[TTS] Set Google Speech Neural TTS engine');
          }
        } catch (_) {}
      }

      await _loadVoices();

      _tts.setCompletionHandler(() async {
        if (_state != VoiceState.playing) return;

        if (_currentSentenceIndex + 1 < _sentences.length) {
          _currentSentenceIndex++;
          _sentenceController.add(_currentSentenceIndex);
          await Future.delayed(const Duration(milliseconds: 320));

          if (_state == VoiceState.playing) {
            await _tts.speak(_sentences[_currentSentenceIndex]);
          }
        } else {
          _stopWaveform();
          _setState(VoiceState.stopped);
          _wordController.add('');
        }
      });

      _tts.setErrorHandler((message) {
        debugPrint('[TTS] Error: $message');
        _stopWaveform();
        _setState(VoiceState.stopped);
      });

      _tts.setProgressHandler((text, start, end, word) {
        _wordController.add(word);
      });

      _tts.setCancelHandler(() {
        _stopWaveform();
        _setState(VoiceState.stopped);
      });

      _tts.setPauseHandler(() => _setState(VoiceState.paused));
      _tts.setContinueHandler(() => _setState(VoiceState.playing));

      debugPrint('[TTS] Smart Interactive Voice Engine Ready');
    } catch (e) {
      debugPrint('[TTS] Initialization error: $e');
    }
  }

  Future<void> _loadVoices() async {
    try {
      final rawVoices = await _tts.getVoices;
      if (rawVoices is List) {
        final List<Map<String, String>> parsed = [];
        for (final v in rawVoices) {
          if (v is Map) {
            final name = v['name']?.toString() ?? '';
            final locale = v['locale']?.toString() ?? '';
            if (locale.startsWith('en')) {
              String label = name;
              if (name.contains('female') || name.contains('sfg') || name.contains('f-')) {
                label = '$name (Female)';
              } else if (name.contains('male') || name.contains('iol') || name.contains('m-')) {
                label = '$name (Male)';
              }
              parsed.add({
                'name': name,
                'locale': locale,
                'label': label,
              });
            }
          }
        }
        if (parsed.isNotEmpty) {
          _availableVoices = parsed;
          final preferred = parsed.firstWhere(
            (v) => v['name']!.contains('sfg') || v['name']!.contains('natural') || v['name']!.contains('en-us'),
            orElse: () => parsed.first,
          );
          _selectedVoiceName = preferred['name']!;
          await _tts.setVoice({
            'name': preferred['name']!,
            'locale': preferred['locale']!,
          });
        }
      }
    } catch (e) {
      debugPrint('[TTS] Could not load custom voices: $e');
    }
  }

  void _startWaveform() {
    _waveformTimer?.cancel();
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_state == VoiceState.playing) {
        final bars = List<double>.generate(
          12,
          (i) => 0.25 + (0.7 * ((i % 4 == 0) ? 0.95 : (i % 4 == 1) ? 0.7 : (i % 4 == 2) ? 0.45 : 0.85)),
        );
        _waveformController.add(bars);
      }
    });
  }

  void _stopWaveform() {
    _waveformTimer?.cancel();
    _waveformController.add(List.filled(12, 0.1));
  }

  void _setState(VoiceState s) {
    _state = s;
    _stateController.add(s);
  }

  @override
  VoiceState get state => _state;

  @override
  Stream<VoiceState> get stateStream => _stateController.stream;

  @override
  Stream<String> get currentWordStream => _wordController.stream;

  @override
  Stream<List<double>> get waveformStream => _waveformController.stream;

  @override
  Stream<int> get currentSentenceIndexStream => _sentenceController.stream;

  @override
  double get speechRate => _speechRate;

  @override
  double get pitch => _pitch;

  @override
  String get voiceName => _selectedVoiceName;

  @override
  int get currentSentenceIndex => _currentSentenceIndex;

  @override
  int get totalSentences => _sentences.length;

  @override
  List<String> get sentences => _sentences;

  @override
  Future<void> speak(String text) async {
    if (!_initialized) await _init();
    await _tts.stop();
    _wordController.add('');

    _sentences = text
        .split(RegExp(r'(?<=[.!?;\n])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (_sentences.isEmpty) {
      _stopWaveform();
      _setState(VoiceState.stopped);
      return;
    }

    _currentSentenceIndex = 0;
    _sentenceController.add(_currentSentenceIndex);
    _setState(VoiceState.playing);
    _startWaveform();

    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(_speechRate);
    await _tts.setPitch(_pitch);

    await _tts.speak(_sentences[0]);
  }

  @override
  Future<void> pause() async {
    if (_state == VoiceState.playing) {
      await _tts.stop();
      _stopWaveform();
      _setState(VoiceState.paused);
    }
  }

  @override
  Future<void> resume() async {
    if (_state == VoiceState.paused && _currentSentenceIndex < _sentences.length) {
      _setState(VoiceState.playing);
      _startWaveform();
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(_pitch);
      await _tts.speak(_sentences[_currentSentenceIndex]);
    }
  }

  @override
  Future<void> stop() async {
    _sentences.clear();
    _currentSentenceIndex = 0;
    await _tts.stop();
    _stopWaveform();
    _wordController.add('');
    _sentenceController.add(0);
    _setState(VoiceState.stopped);
  }

  @override
  Future<void> nextSentence() async {
    if (_currentSentenceIndex + 1 < _sentences.length) {
      _currentSentenceIndex++;
      _sentenceController.add(_currentSentenceIndex);
      final wasPlaying = _state == VoiceState.playing;
      await _tts.stop();
      if (wasPlaying) {
        _setState(VoiceState.playing);
        _startWaveform();
        await _tts.speak(_sentences[_currentSentenceIndex]);
      } else {
        _setState(VoiceState.paused);
      }
    }
  }

  @override
  Future<void> previousSentence() async {
    if (_currentSentenceIndex > 0) {
      _currentSentenceIndex--;
      _sentenceController.add(_currentSentenceIndex);
      final wasPlaying = _state == VoiceState.playing;
      await _tts.stop();
      if (wasPlaying) {
        _setState(VoiceState.playing);
        _startWaveform();
        await _tts.speak(_sentences[_currentSentenceIndex]);
      } else {
        _setState(VoiceState.paused);
      }
    }
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    final mapped = (rate * 0.48).clamp(0.15, 0.85);
    await _tts.setSpeechRate(mapped);
  }

  @override
  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    await _tts.setPitch(pitch);
  }

  @override
  Future<void> setVoice(String voiceName) async {
    _selectedVoiceName = voiceName;
    final matched = _availableVoices.firstWhere(
      (v) => v['name'] == voiceName,
      orElse: () => {'name': voiceName, 'locale': 'en-US'},
    );
    await _tts.setVoice({
      'name': matched['name']!,
      'locale': matched['locale'] ?? 'en-US',
    });
  }

  @override
  Future<List<Map<String, String>>> getAvailableVoices() async {
    if (_availableVoices.isEmpty) {
      await _loadVoices();
    }
    return _availableVoices;
  }

  @override
  void dispose() {
    _waveformTimer?.cancel();
    _tts.stop();
    _stateController.close();
    _wordController.close();
    _waveformController.close();
    _sentenceController.close();
  }
}
