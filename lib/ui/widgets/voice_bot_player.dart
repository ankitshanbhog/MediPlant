import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';

/// Voice Bot audio player widget with equalizer waveforms and TTS speech controls
class VoiceBotPlayer extends StatelessWidget {
  final String title;
  final String speechText;
  final bool isCompact;

  const VoiceBotPlayer({
    super.key,
    required this.title,
    required this.speechText,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final voiceVM = context.watch<VoiceViewModel>();
    final isThisPlaying = voiceVM.isPlaying && voiceVM.currentNarrationTitle == title;
    final isThisPaused = voiceVM.isPaused && voiceVM.currentNarrationTitle == title;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isThisPlaying
              ? AppColors.primaryAccent.withOpacity(0.15)
              : (isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isThisPlaying
                ? AppColors.primaryAccent
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: InkWell(
          onTap: () {
            voiceVM.togglePlayPause(title: title, text: speechText);
          },
          borderRadius: BorderRadius.circular(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isThisPlaying
                    ? Icons.pause_circle_filled_rounded
                    : (isThisPaused
                        ? Icons.play_circle_filled_rounded
                        : Icons.volume_up_rounded),
                color: isThisPlaying ? AppColors.primaryAccent : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                isThisPlaying ? 'Listening...' : (isThisPaused ? 'Paused' : 'Listen'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isThisPlaying ? AppColors.primaryAccent : AppColors.primary,
                ),
              ),
              if (isThisPlaying) ...[
                const SizedBox(width: 8),
                _CompactWaveform(waveforms: voiceVM.waveforms),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF142E21), const Color(0xFF0F241A)]
              : [const Color(0xFFEAF5EE), const Color(0xFFF4FAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isThisPlaying
              ? AppColors.primaryAccent
              : (isDark ? AppColors.borderDark : AppColors.lightMint),
          width: isThisPlaying ? 1.5 : 1,
        ),
        boxShadow: isThisPlaying
            ? [
                BoxShadow(
                  color: AppColors.primaryAccent.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isThisPlaying
                      ? AppColors.primaryAccent
                      : AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: isThisPlaying ? Colors.white : AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Voice Assistant',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.mint : AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      isThisPlaying
                          ? 'Narrating: $title'
                          : 'Read aloud plant overview & instructions',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Speed selector button
              _SpeedSelector(
                currentSpeed: voiceVM.speechRate,
                onSelected: (speed) => voiceVM.setRate(speed),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Equalizer waveform visualizer
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.25)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      voiceVM.waveforms.length,
                      (index) {
                        final val = isThisPlaying ? voiceVM.waveforms[index] : 0.15;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: 3.5,
                          height: (val * 24).clamp(4.0, 24.0),
                          decoration: BoxDecoration(
                            color: isThisPlaying
                                ? AppColors.primaryAccent
                                : AppColors.textMutedLight,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isThisPlaying ? 'Speaking' : (isThisPaused ? 'Paused' : 'Ready'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isThisPlaying
                        ? AppColors.primaryAccent
                        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                ),
              ],
            ),
          ),

          // Subtitle / spoken word stream display
          if (isThisPlaying && voiceVM.activeWord.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.graphic_eq, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '“ ... ${voiceVM.activeWord} ... ”',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Player controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isThisPlaying || isThisPaused) ...[
                IconButton.filledTonal(
                  icon: const Icon(Icons.stop_rounded),
                  color: AppColors.confidenceLow,
                  onPressed: () => voiceVM.stop(),
                  tooltip: 'Stop',
                ),
                const SizedBox(width: 12),
              ],
              ElevatedButton.icon(
                onPressed: () {
                  voiceVM.togglePlayPause(title: title, text: speechText);
                },
                icon: Icon(
                  isThisPlaying
                      ? Icons.pause_rounded
                      : (isThisPaused ? Icons.play_arrow_rounded : Icons.volume_up_rounded),
                  size: 20,
                ),
                label: Text(
                  isThisPlaying
                      ? 'Pause Narration'
                      : (isThisPaused ? 'Resume' : 'Listen to Information'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactWaveform extends StatelessWidget {
  final List<double> waveforms;
  const _CompactWaveform({required this.waveforms});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 2.5,
          height: (waveforms[i % waveforms.length] * 12).clamp(3.0, 12.0),
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _SpeedSelector extends StatelessWidget {
  final double currentSpeed;
  final ValueChanged<double> onSelected;

  const _SpeedSelector({
    required this.currentSpeed,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: currentSpeed,
      onSelected: onSelected,
      tooltip: 'Voice Speed',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${currentSpeed}x',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
            const Icon(Icons.arrow_drop_down, size: 14),
          ],
        ),
      ),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 0.75, child: Text('0.75x (Slower)')),
        PopupMenuItem(value: 1.0, child: Text('1.0x (Normal)')),
        PopupMenuItem(value: 1.25, child: Text('1.25x (Faster)')),
        PopupMenuItem(value: 1.5, child: Text('1.5x (Fast)')),
      ],
    );
  }
}
