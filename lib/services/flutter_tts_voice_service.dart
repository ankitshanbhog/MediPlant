import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'voice_service.dart';

/// Real Text-to-Speech implementation backed by the device's native TTS engine.
///
/// Enhanced with sentence-by-sentence queueing and natural pauses (380ms)
/// between sentences and clauses to prevent continuous run-on speech.
class FlutterTtsVoiceService implements VoiceTtsService {
  final FlutterTts _tts = FlutterTts();

  VoiceState _state = VoiceState.stopped;
  double _speechRate = 0.44; // Calibrated for clear, natural conversational pacing

  final _stateController = StreamController<VoiceState>.broadcast();
  final _wordController = StreamController<String>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();

  Timer? _waveformTimer;
  bool _initialized = false;

  List<String> _sentences = [];
  int _currentSentenceIndex = 0;

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
      await _tts.setPitch(1.0);

      if (defaultTargetPlatform == TargetPlatform.android) {
        final engines = await _tts.getEngines;
        debugPrint('[TTS] Available engines: $engines');
      }

      // Sentence completion callback with natural pause before next sentence
      _tts.setCompletionHandler(() async {
        if (_state != VoiceState.playing) return;

        if (_currentSentenceIndex + 1 < _sentences.length) {
          _currentSentenceIndex++;

          // Natural breathing pause between distinct thoughts and sentences
          await Future.delayed(const Duration(milliseconds: 380));

          if (_state == VoiceState.playing) {
            final nextSentence = _sentences[_currentSentenceIndex];
            await _tts.speak(nextSentence);
          }
        } else {
          _stopWaveform();
          _setState(VoiceState.stopped);
          _wordController.add('');
        }
      });

      // Error callback
      _tts.setErrorHandler((message) {
        debugPrint('[TTS] Error: $message');
        _stopWaveform();
        _setState(VoiceState.stopped);
      });

      // Word boundary / progress
      _tts.setProgressHandler((text, start, end, word) {
        _wordController.add(word);
      });

      // Cancel callback
      _tts.setCancelHandler(() {
        _stopWaveform();
        _setState(VoiceState.stopped);
      });

      _tts.setPauseHandler(() => _setState(VoiceState.paused));
      _tts.setContinueHandler(() => _setState(VoiceState.playing));

      debugPrint('[TTS] FlutterTtsVoiceService initialized with natural sentence pauses');
    } catch (e) {
      debugPrint('[TTS] Initialization error: $e');
    }
  }

  void _startWaveform() {
    _waveformTimer?.cancel();
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_state == VoiceState.playing) {
        final bars = List<double>.generate(
          12,
          (i) => 0.3 + (0.6 * ((i % 3 == 0) ? 0.9 : (i % 3 == 1) ? 0.6 : 0.4)),
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

  // ──────────────────────────────────────────────────────────
  // VoiceTtsService interface
  // ──────────────────────────────────────────────────────────

  @override
  VoiceState get state => _state;

  @override
  Stream<VoiceState> get stateStream => _stateController.stream;

  @override
  Stream<String> get currentWordStream => _wordController.stream;

  @override
  Stream<List<double>> get waveformStream => _waveformController.stream;

  @override
  double get speechRate => _speechRate;

  @override
  Future<void> speak(String text) async {
    if (!_initialized) await _init();
    await _tts.stop();
    _wordController.add('');

    // Segment text into discrete sentences or punctuated clauses for natural pauses
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
    _setState(VoiceState.playing);
    _startWaveform();

    final result = await _tts.speak(_sentences[0]);
    if (result == 0) {
      debugPrint('[TTS] speak() returned 0 — engine may not be ready.');
      _stopWaveform();
      _setState(VoiceState.stopped);
    }
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
    _setState(VoiceState.stopped);
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    final mapped = (rate * 0.44).clamp(0.1, 1.0);
    await _tts.setSpeechRate(mapped);
  }

  @override
  void dispose() {
    _waveformTimer?.cancel();
    _tts.stop();
    _stateController.close();
    _wordController.close();
    _waveformController.close();
  }
}
