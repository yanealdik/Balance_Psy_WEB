import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Экран чтения статьи
class ArticleDetailScreen extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String? category;
  final int? readTime;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    this.imageUrl,
    this.category,
    this.readTime,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isBookmarked = false;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() => _showTitle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar с изображением
          _buildSliverAppBar(),

          // Контент статьи
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и метаданные
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Категория
                      if (widget.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.category!,
                            style: AppTextStyles.body2.copyWith(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Заголовок
                      Text(
                        widget.title,
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 28,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Метаданные
                      Row(
                        children: [
                          // Время чтения
                          if (widget.readTime != null) ...[
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.readTime} мин',
                              style: AppTextStyles.body2.copyWith(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],

                          // Дата публикации
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '15 октября 2024',
                            style: AppTextStyles.body2.copyWith(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 32),

                // Контент статьи
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildArticleContent(),
                ),

                const SizedBox(height: 32),

                // Похожие статьи
                _buildRelatedArticles(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sliver App Bar с изображением
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() => _isBookmarked = !_isBookmarked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarked
                        ? 'Статья добавлена в закладки'
                        : 'Статья удалена из закладок',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: _shareArticle,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: _showTitle
            ? Text(
                widget.title,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Изображение статьи
            if (widget.imageUrl != null)
              Image.network(
                widget.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            else
              _buildPlaceholderImage(),

            // Градиент снизу
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder для изображения
  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: const Center(
        child: Icon(Icons.article_outlined, size: 80, color: AppColors.primary),
      ),
    );
  }

  // Контент статьи
  Widget _buildArticleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Вступление
        Text(
          'Грусть — это естественная эмоция, которую испытывает каждый человек. '
          'Она может возникать по разным причинам: расставание, неудачи, потеря близких. '
          'Но важно понимать, что грусть — это не слабость, а нормальная реакция на жизненные ситуации.',
          style: AppTextStyles.body1.copyWith(
            fontSize: 17,
            height: 1.6,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 24),

        // Основной контент
        _buildSectionTitle('Почему важно проживать грусть?'),
        const SizedBox(height: 12),
        _buildParagraph(
          'Многие люди стараются подавить грусть, отвлечься от неё или притвориться, '
          'что всё в порядке. Однако подавленные эмоции имеют свойство накапливаться '
          'и проявляться позже в виде стресса, тревоги или даже депрессии.',
        ),
        const SizedBox(height: 16),
        _buildParagraph(
          'Проживание грусти означает признание и принятие этой эмоции. '
          'Это не значит, что нужно погружаться в негатив, но важно дать себе право '
          'чувствовать то, что вы чувствуете.',
        ),

        const SizedBox(height: 32),

        _buildSectionTitle('Как прожить грусть с пользой?'),
        const SizedBox(height: 16),

        // Список советов
        _buildTipItem(
          '1',
          'Признайте свои чувства',
          'Не пытайтесь убедить себя, что всё хорошо, если это не так. '
              'Скажите себе: "Да, мне грустно, и это нормально".',
        ),

        _buildTipItem(
          '2',
          'Выражайте эмоции',
          'Плач — это естественный способ освобождения от накопившихся эмоций. '
              'Не стесняйтесь плакать, если чувствуете в этом потребность.',
        ),

        _buildTipItem(
          '3',
          'Ведите дневник',
          'Записывайте свои мысли и чувства. Это помогает лучше понять себя '
              'и осознать причины грусти.',
        ),

        _buildTipItem(
          '4',
          'Поговорите с кем-то',
          'Делитесь своими переживаниями с близкими людьми или психологом. '
              'Иногда просто быть услышанным уже помогает.',
        ),

        _buildTipItem(
          '5',
          'Будьте терпеливы',
          'Грусть проходит не сразу. Дайте себе время на восстановление '
              'и не торопите события.',
        ),

        const SizedBox(height: 32),

        _buildSectionTitle('Когда стоит обратиться за помощью?'),
        const SizedBox(height: 12),
        _buildParagraph(
          'Если грусть длится больше двух недель, мешает повседневной жизни, '
          'сопровождается потерей интереса ко всему или мыслями о самоповреждении, '
          'важно обратиться к специалисту. Психолог или психотерапевт помогут вам '
          'разобраться в ситуации и найти выход.',
        ),

        const SizedBox(height: 24),

        // Важное замечание
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Важно помнить',
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Грусть — это временное состояние. Проживая её осознанно, '
                      'вы делаете важный шаг к эмоциональному здоровью и личностному росту.',
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Заголовок секции
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h2.copyWith(fontSize: 22, height: 1.3),
    );
  }

  // Параграф текста
  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: AppTextStyles.body1.copyWith(
        fontSize: 16,
        height: 1.7,
        color: AppColors.textPrimary,
      ),
    );
  }

  // Пункт совета
  Widget _buildTipItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3.copyWith(fontSize: 17)),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Похожие статьи
  Widget _buildRelatedArticles() {
    final articles = [
      {
        'title': 'Что делать, когда нет сил',
        'category': 'Самопомощь',
        'time': 4,
      },
      {
        'title': 'Техники борьбы со стрессом',
        'category': 'Практики',
        'time': 6,
      },
      {'title': 'Как наладить режим сна', 'category': 'Здоровье', 'time': 5},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Похожие статьи',
            style: AppTextStyles.h3.copyWith(fontSize: 20),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right: index < articles.length - 1 ? 12 : 0,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        article['category'] as String,
                        style: AppTextStyles.body2.copyWith(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article['title'] as String,
                      style: AppTextStyles.h3.copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article['time']} мин',
                          style: AppTextStyles.body2.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Поделиться статьей
  void _shareArticle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Функция "Поделиться" будет доступна скоро'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
