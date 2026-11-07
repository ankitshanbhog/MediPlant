import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';

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
    final isThisActive = isThisPlaying || isThisPaused;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isThisPlaying
              ? AppColors.primaryAccent.withOpacity(0.18)
              : (isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isThisPlaying
                ? AppColors.primaryAccent
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isThisPlaying ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            voiceVM.togglePlayPause(title: title, text: speechText);
          },
          borderRadius: BorderRadius.circular(26),
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
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isThisPlaying ? 'Listening...' : (isThisPaused ? 'Paused' : 'Listen Aloud'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
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

    final totalSentences = voiceVM.totalSentences;
    final currentSentence = (voiceVM.currentSentenceIndex + 1).clamp(1, totalSentences > 0 ? totalSentences : 1);
    final progress = totalSentences > 0 ? currentSentence / totalSentences : 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF142E21), const Color(0xFF0F241A)]
              : [const Color(0xFFEAF5EE), const Color(0xFFF4FAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isThisPlaying
              ? AppColors.primaryAccent
              : (isDark ? AppColors.borderDark : AppColors.lightMint),
          width: isThisPlaying ? 1.8 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header: Bot avatar + title + speed selector & settings
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isThisPlaying
                      ? AppColors.primaryAccent
                      : AppColors.primary.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: isThisPlaying ? Colors.white : AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interactive Botanical Guide',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: isDark ? AppColors.mint : AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isThisPlaying
                          ? 'Narrating: $title'
                          : (isThisPaused ? 'Paused — Tap play to resume' : 'Listen with interactive voice navigation'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              _VoiceSettingsButton(voiceVM: voiceVM),
            ],
          ),
          const SizedBox(height: 12),

          // Waveform & Status Visualizer
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.28)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : const Color(0xFFE2EBE5),
              ),
            ),
            child: Row(
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
                          height: (val * 24).clamp(5.0, 24.0),
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
                const SizedBox(width: 10),
                Text(
                  isThisPlaying
                      ? '$currentSentence/$totalSentences'
                      : (isThisPaused ? 'Paused' : 'Ready'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isThisPlaying
                        ? AppColors.primary
                        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                ),
              ],
            ),
          ),

          // Reading progress bar if active
          if (isThisActive && totalSentences > 0) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],

          // Active speaking word live display
          if (isThisPlaying && voiceVM.activeWord.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.09),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.graphic_eq_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '“ ${voiceVM.activeWord} ”',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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

          // Responsive Transport Controls: Previous Sentence | Play/Pause | Next Sentence | Stop
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // Rewind / Previous Sentence button
              IconButton.filledTonal(
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? AppColors.surfaceSubtleDark : Colors.white,
                  padding: const EdgeInsets.all(10),
                  minimumSize: const Size(40, 40),
                ),
                icon: const Icon(Icons.skip_previous_rounded, size: 22),
                onPressed: () => voiceVM.previousSentence(),
                tooltip: 'Previous Sentence',
              ),

              // Main Play / Pause Button
              ElevatedButton.icon(
                onPressed: () {
                  voiceVM.togglePlayPause(title: title, text: speechText);
                },
                icon: Icon(
                  isThisPlaying
                      ? Icons.pause_rounded
                      : (isThisPaused ? Icons.play_arrow_rounded : Icons.volume_up_rounded),
                  size: 22,
                ),
                label: Text(
                  isThisPlaying
                      ? 'Pause'
                      : (isThisPaused ? 'Resume' : 'Listen Aloud'),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
              ),

              // Forward / Next Sentence button
              IconButton.filledTonal(
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? AppColors.surfaceSubtleDark : Colors.white,
                  padding: const EdgeInsets.all(10),
                  minimumSize: const Size(40, 40),
                ),
                icon: const Icon(Icons.skip_next_rounded, size: 22),
                onPressed: () => voiceVM.nextSentence(),
                tooltip: 'Next Sentence',
              ),

              if (isThisActive)
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.12),
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(40, 40),
                  ),
                  icon: const Icon(Icons.stop_rounded, size: 22),
                  onPressed: () => voiceVM.stop(),
                  tooltip: 'Stop',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoiceSettingsButton extends StatelessWidget {
  final VoiceViewModel voiceVM;
  const _VoiceSettingsButton({required this.voiceVM});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Voice Options',
      icon: const Icon(Icons.tune_rounded, size: 22),
      onSelected: (val) {
        if (val.startsWith('speed:')) {
          final speed = double.parse(val.substring(6));
          voiceVM.setRate(speed);
        } else if (val.startsWith('pitch:')) {
          final pitch = double.parse(val.substring(6));
          voiceVM.setPitch(pitch);
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          enabled: false,
          child: Text('Playback Speed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        PopupMenuItem(value: 'speed:0.75', child: Text('0.75x Slower ${voiceVM.speechRate == 0.75 ? "✓" : ""}')),
        PopupMenuItem(value: 'speed:1.0', child: Text('1.0x Normal ${voiceVM.speechRate == 1.0 ? "✓" : ""}')),
        PopupMenuItem(value: 'speed:1.25', child: Text('1.25x Faster ${voiceVM.speechRate == 1.25 ? "✓" : ""}')),
        const PopupMenuDivider(),
        const PopupMenuItem(
          enabled: false,
          child: Text('Voice Pitch & Tone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        PopupMenuItem(value: 'pitch:0.85', child: Text('Deep & Warm ${voiceVM.pitch == 0.85 ? "✓" : ""}')),
        PopupMenuItem(value: 'pitch:1.0', child: Text('Natural Balanced ${voiceVM.pitch == 1.0 ? "✓" : ""}')),
        PopupMenuItem(value: 'pitch:1.15', child: Text('Bright & Crisp ${voiceVM.pitch == 1.15 ? "✓" : ""}')),
      ],
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
