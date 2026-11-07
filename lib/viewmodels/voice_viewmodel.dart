import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/voice_service.dart';

class VoiceViewModel extends ChangeNotifier {
  final VoiceTtsService _voiceService;

  StreamSubscription<VoiceState>? _stateSub;
  StreamSubscription<String>? _wordSub;
  StreamSubscription<List<double>>? _waveSub;
  StreamSubscription<int>? _sentenceSub;

  VoiceViewModel({required VoiceTtsService voiceService})
      : _voiceService = voiceService {
    _initSubscriptions();
  }

  VoiceState _state = VoiceState.stopped;
  String _activeWord = '';
  List<double> _waveforms = List.filled(12, 0.1);
  String _currentNarrationTitle = '';
  int _currentSentenceIndex = 0;
  List<Map<String, String>> _availableVoices = [];

  VoiceState get state => _state;
  bool get isPlaying => _state == VoiceState.playing;
  bool get isPaused => _state == VoiceState.paused;
  bool get isStopped => _state == VoiceState.stopped;
  String get activeWord => _activeWord;
  List<double> get waveforms => _waveforms;
  double get speechRate => _voiceService.speechRate;
  double get pitch => _voiceService.pitch;
  String get currentVoiceName => _voiceService.voiceName;
  String get currentNarrationTitle => _currentNarrationTitle;
  int get currentSentenceIndex => _currentSentenceIndex;
  int get totalSentences => _voiceService.totalSentences;
  List<String> get sentences => _voiceService.sentences;
  List<Map<String, String>> get availableVoices => _availableVoices;

  void _initSubscriptions() {
    _stateSub = _voiceService.stateStream.listen((newState) {
      _state = newState;
      notifyListeners();
    });

    _wordSub = _voiceService.currentWordStream.listen((word) {
      _activeWord = word;
      notifyListeners();
    });

    _waveSub = _voiceService.waveformStream.listen((waves) {
      _waveforms = waves;
      notifyListeners();
    });

    _sentenceSub = _voiceService.currentSentenceIndexStream.listen((idx) {
      _currentSentenceIndex = idx;
      notifyListeners();
    });

    _loadVoices();
  }

  Future<void> _loadVoices() async {
    _availableVoices = await _voiceService.getAvailableVoices();
    notifyListeners();
  }

  Future<void> readAloud({
    required String title,
    required String text,
  }) async {
    _currentNarrationTitle = title;
    notifyListeners();
    await _voiceService.speak(text);
  }

  Future<void> pause() async {
    await _voiceService.pause();
  }

  Future<void> resume() async {
    await _voiceService.resume();
  }

  Future<void> stop() async {
    _currentNarrationTitle = '';
    await _voiceService.stop();
  }

  Future<void> nextSentence() async {
    await _voiceService.nextSentence();
  }

  Future<void> previousSentence() async {
    await _voiceService.previousSentence();
  }

  Future<void> togglePlayPause({
    required String title,
    required String text,
  }) async {
    if (isPlaying) {
      await pause();
    } else if (isPaused) {
      await resume();
    } else {
      await readAloud(title: title, text: text);
    }
  }

  Future<void> setRate(double rate) async {
    await _voiceService.setSpeechRate(rate);
    notifyListeners();
  }

  Future<void> setPitch(double pitch) async {
    await _voiceService.setPitch(pitch);
    notifyListeners();
  }

  Future<void> setVoice(String voiceName) async {
    await _voiceService.setVoice(voiceName);
    notifyListeners();
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _wordSub?.cancel();
    _waveSub?.cancel();
    _sentenceSub?.cancel();
    super.dispose();
  }
}
