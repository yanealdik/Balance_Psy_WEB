// Фрагмент для замены в lib/web_pages/profile_patient/blog_patient.dart

import 'package:flutter/material.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_colors.dart';
import '../../../сore/router/app_router.dart';
import '../../../widgets/profile_patient/patient_bar.dart';
import '../../services/directus_service.dart';
import '../../models/directus_models.dart';

class BlogPatientPage extends StatefulWidget {
  const BlogPatientPage({super.key});

  @override
  State<BlogPatientPage> createState() => _BlogPatientPageState();
}

class _BlogPatientPageState extends State<BlogPatientPage> {
  List<DirectusArticle> _articles = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'Все';

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Загружаем статьи из Directus
      final articlesJson = await DirectusService.getArticles(
        status: 'published',
        category: _selectedCategory == 'Все' ? null : _selectedCategory,
      );

      final articles = articlesJson
          .map((json) => DirectusArticle.fromJson(json))
          .toList();

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка загрузки статей: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return PageWrapper(
      currentRoute: AppRouter.blog,
      showHeader: false,
      showFooter: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PatientBar(currentRoute: AppRouter.blog),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                margin: const EdgeInsets.all(40),
                child: _isLoading
                    ? _buildLoadingState()
                    : _errorMessage != null
                    ? _buildErrorState()
                    : _buildContent(ctx),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text('Загрузка статей...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(_errorMessage!, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadArticles,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_articles.isNotEmpty) ...[
          _buildFeaturedArticle(ctx, _articles.first),
          const SizedBox(height: 40),
        ],
        _buildCategoriesFilter(),
        const SizedBox(height: 32),
        _buildFilteredArticles(ctx),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildFeaturedArticle(BuildContext ctx, DirectusArticle article) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 400,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: AppColors.inputBackground,
              image: article.featuredImage != null
                  ? DecorationImage(
                      image: NetworkImage(
                        DirectusService.getImageUrl(
                          article.featuredImage!,
                          width: 400,
                          height: 280,
                        ),
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: article.featuredImage == null
                ? const Center(
                    child: Icon(
                      Icons.article,
                      size: 80,
                      color: AppColors.textTertiary,
                    ),
                  )
                : null,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      article.category,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.excerpt,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${article.readTime} мин чтения',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${article.views}',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _openArticle(ctx, article),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Читать статью',
                      style: AppTextStyles.button.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    final categories = [
      'Все',
      'Эмоции',
      'Самопомощь',
      'Отношения',
      'Состояние покоя',
      'Популярное',
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = _selectedCategory == cat;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() => _selectedCategory = cat);
                _loadArticles();
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.inputBorder.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Text(
                  cat,
                  style: AppTextStyles.body1.copyWith(
                    color: isActive ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilteredArticles(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCategory == 'Все' ? 'Все статьи' : _selectedCategory,
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_articles.length} статей',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.3,
          ),
          itemCount: _articles.length,
          itemBuilder: (_, i) => _buildArticleCard(ctx, _articles[i]),
        ),
      ],
    );
  }

  Widget _buildArticleCard(BuildContext ctx, DirectusArticle article) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openArticle(ctx, article),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: AppColors.inputBackground,
                  image: article.featuredImage != null
                      ? DecorationImage(
                          image: NetworkImage(
                            DirectusService.getImageUrl(
                              article.featuredImage!,
                              width: 300,
                              height: 130,
                            ),
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: article.featuredImage == null
                    ? const Center(
                        child: Icon(
                          Icons.article,
                          size: 40,
                          color: AppColors.textTertiary,
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(14),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article.category,
                        style: AppTextStyles.body3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      article.title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.readTime} мин',
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openArticle(BuildContext ctx, DirectusArticle article) async {
    // Увеличиваем счётчик просмотров
    DirectusService.incrementArticleViews(article.id);

    // Открываем статью
    // TODO: Реализовать страницу чтения статьи
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text('Открытие статьи: ${article.title}')),
    );
  }
}
