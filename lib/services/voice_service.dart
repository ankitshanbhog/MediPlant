import 'dart:async';
import 'dart:math';

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
  double get speechRate;

  Future<void> speak(String text);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> setSpeechRate(double rate);
  void dispose();
}

class MockVoiceTtsService implements VoiceTtsService {
  VoiceState _state = VoiceState.stopped;
  double _speechRate = 1.0;
  List<String> _words = [];
  int _currentWordIndex = 0;

  Timer? _playbackTimer;
  Timer? _waveformTimer;

  final _stateController = StreamController<VoiceState>.broadcast();
  final _wordController = StreamController<String>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();

  final Random _random = Random();

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
    await stop();
    _words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    _currentWordIndex = 0;
    _setState(VoiceState.playing);

    _startSimulatedPlayback();
    _startWaveformTimer();
  }

  void _startSimulatedPlayback() {
    _playbackTimer?.cancel();
    final intervalMs = (280 / _speechRate).round();

    _playbackTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_currentWordIndex < _words.length) {
        _wordController.add(_words[_currentWordIndex]);
        _currentWordIndex++;
      } else {
        stop();
      }
    });
  }

  void _startWaveformTimer() {
    _waveformTimer?.cancel();
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_state == VoiceState.playing) {
        
        final waves = List.generate(12, (index) {
          return 0.15 + (_random.nextDouble() * 0.85);
        });
        _waveformController.add(waves);
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
      _startSimulatedPlayback();
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
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    if (_state == VoiceState.playing) {
      _startSimulatedPlayback();
    }
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
  }
}
