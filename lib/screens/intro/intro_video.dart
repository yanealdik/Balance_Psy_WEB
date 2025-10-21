import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/back_button.dart';

/// Экран с видео из YouTube
class IntroVideoScreen extends StatefulWidget {
  final String title;
  final String description;
  final String videoUrl;

  const IntroVideoScreen({
    super.key,
    required this.title,
    required this.description,
    required this.videoUrl,
  });

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late YoutubePlayerController _controller;
  bool _hasWatched = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        hideControls: false,
        controlsVisibleAtStart: true,
        forceHD: false,
      ),
    )..addListener(_videoListener);
  }

  void _videoListener() {
    if (!mounted) return;

    if (_controller.value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }

    // Проверяем прогресс просмотра
    if (_isPlayerReady && _controller.value.isPlaying) {
      final position = _controller.value.position.inSeconds;
      final duration = _controller.metadata.duration.inSeconds;

      // Если досмотрел 80% или дошел до конца
      if (duration > 0 &&
          (position > duration * 0.8 || position >= duration - 5)) {
        if (!_hasWatched && mounted) {
          setState(() {
            _hasWatched = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.pause();
    _controller.dispose();
    // Возвращаем портретную ориентацию
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // Возвращаем портретную ориентацию при выходе из полноэкранного режима
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.grey.shade200,
        ),
        onReady: () {
          debugPrint('Player is ready');
        },
        onEnded: (data) {
          if (mounted) {
            setState(() {
              _hasWatched = true;
            });
          }
        },
      ),
      builder: (context, player) {
        return WillPopScope(
          onWillPop: () async {
            _controller.pause();
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  // Верхняя часть с кнопкой назад
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CustomBackButton(
                          onPressed: () {
                            _controller.pause();
                            Navigator.pop(context, _hasWatched);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Контент
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Заголовок
                          Text(
                            widget.title,
                            style: AppTextStyles.h2.copyWith(fontSize: 24),
                          ),

                          const SizedBox(height: 12),

                          // Описание
                          Text(
                            widget.description,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // YouTube плеер
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: player,
                          ),

                          const SizedBox(height: 24),

                          // Индикатор просмотра
                          if (_hasWatched)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Видео просмотрено! Можешь продолжить',
                                      style: AppTextStyles.body2.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Досмотри видео до конца, чтобы продолжить',
                                      style: AppTextStyles.body3.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Кнопка "Продолжить"
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: CustomButton(
                      text: 'Продолжить',
                      showArrow: true,
                      onPressed: _hasWatched
                          ? () {
                              _controller.pause();
                              Navigator.pop(context, true);
                            }
                          : null,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
