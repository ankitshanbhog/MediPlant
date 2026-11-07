import 'dart:async';

enum VoiceState {
  stopped,
  playing,
  paused,
}

abstract class VoiceTtsService {
  VoiceState get state;
  Stream<VoiceState> get stateStream;
  Stream<String> get currentWordStream;
  Stream<List<double>> get waveformStream;
  Stream<int> get currentSentenceIndexStream;
  double get speechRate;
  double get pitch;
  String get voiceName;
  int get currentSentenceIndex;
  int get totalSentences;
  List<String> get sentences;

  Future<void> speak(String text);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> nextSentence();
  Future<void> previousSentence();
  Future<void> setSpeechRate(double rate);
  Future<void> setPitch(double pitch);
  Future<void> setVoice(String voiceName);
  Future<List<Map<String, String>>> getAvailableVoices();
  void dispose();
}

class MockVoiceTtsService implements VoiceTtsService {
  VoiceState _state = VoiceState.stopped;
  double _speechRate = 1.0;
  double _pitch = 1.0;
  String _voiceName = 'default';
  List<String> _words = [];
  int _currentWordIndex = 0;
  List<String> _sentencesList = [];
  int _sentenceIndex = 0;

  Timer? _playbackTimer;
  Timer? _waveformTimer;

  final _stateController = StreamController<VoiceState>.broadcast();
  final _wordController = StreamController<String>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();
  final _sentenceController = StreamController<int>.broadcast();

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
  String get voiceName => _voiceName;

  @override
  int get currentSentenceIndex => _sentenceIndex;

  @override
  int get totalSentences => _sentencesList.length;

  @override
  List<String> get sentences => _sentencesList;

  @override
  Future<void> speak(String text) async {
    await stop();
    _sentencesList = text
        .split(RegExp(r'(?<=[.!?;\n])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    _sentenceIndex = 0;
    _words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    _currentWordIndex = 0;
    _setState(VoiceState.playing);
    _sentenceController.add(_sentenceIndex);

    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_currentWordIndex < _words.length) {
        _wordController.add(_words[_currentWordIndex]);
        _currentWordIndex++;
      } else {
        stop();
      }
    });

    _waveformTimer?.cancel();
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_state == VoiceState.playing) {
        _waveformController.add(List.generate(12, (_) => 0.5));
      } else {
        _waveformController.add(List.filled(12, 0.1));
      }
    });
  }

  @override
  Future<void> pause() async {
    if (_state == VoiceState.playing) {
      _playbackTimer?.cancel();
      _setState(VoiceState.paused);
    }
  }

  @override
  Future<void> resume() async {
    if (_state == VoiceState.paused) {
      _setState(VoiceState.playing);
    }
  }

  @override
  Future<void> stop() async {
    _playbackTimer?.cancel();
    _waveformTimer?.cancel();
    _currentWordIndex = 0;
    _setState(VoiceState.stopped);
    _wordController.add('');
    _waveformController.add(List.filled(12, 0.1));
  }

  @override
  Future<void> nextSentence() async {
    if (_sentenceIndex + 1 < _sentencesList.length) {
      _sentenceIndex++;
      _sentenceController.add(_sentenceIndex);
    }
  }

  @override
  Future<void> previousSentence() async {
    if (_sentenceIndex > 0) {
      _sentenceIndex--;
      _sentenceController.add(_sentenceIndex);
    }
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
  }

  @override
  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
  }

  @override
  Future<void> setVoice(String voiceName) async {
    _voiceName = voiceName;
  }

  @override
  Future<List<Map<String, String>>> getAvailableVoices() async {
    return [
      {'name': 'en-us-x-sfg-local', 'locale': 'en-US', 'gender': 'female', 'label': 'Aria (Natural Clear)'},
      {'name': 'en-us-x-iol-local', 'locale': 'en-US', 'gender': 'male', 'label': 'Marcus (Warm Deep)'},
      {'name': 'en-gb-x-rjs-local', 'locale': 'en-GB', 'gender': 'female', 'label': 'Serena (British Calm)'},
      {'name': 'en-in-x-cxx-local', 'locale': 'en-IN', 'gender': 'female', 'label': 'Priya (Indian Expressive)'},
    ];
  }

  void _setState(VoiceState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _waveformTimer?.cancel();
    _stateController.close();
    _wordController.close();
    _waveformController.close();
    _sentenceController.close();
  }
}
