import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../screens/U_articles/ArticleDetail/ArticleDetailScreen.dart';

/// Переиспользуемая карточка статьи с двухслойным эффектом
class ArticleCard extends StatelessWidget {
  final String title;
  final String image;
  final String category;
  final int readTime;
  final double width;
  final double height;

  const ArticleCard({
    Key? key,
    required this.title,
    required this.image,
    required this.category,
    required this.readTime,
    this.width = 110,
    this.height = 110,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              title: title,
              category: category,
              readTime: readTime,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Контейнер со стеком
          SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                // Нижний слой (синяя "тень")
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                // Верхний слой (белая карточка с изображением)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: width - 7,
                    height: height - 7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Center(
                              child: Icon(
                                Icons.article,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Текст под карточкой
          SizedBox(
            width: width,
            child: Text(
              title,
              style: AppTextStyles.body1.copyWith(fontSize: 12, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Горизонтальный список статей
class HorizontalArticlesList extends StatelessWidget {
  final List<Map<String, dynamic>> articles;
  final double cardWidth;
  final double cardHeight;

  const HorizontalArticlesList({
    Key? key,
    required this.articles,
    this.cardWidth = 110,
    this.cardHeight = 110,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight + 50, // +50 для текста под карточкой
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < articles.length - 1 ? 16 : 0,
            ),
            child: ArticleCard(
              title: article['title'] ?? 'Статья',
              image: article['image'] ?? '',
              category: article['category'] ?? 'Общее',
              readTime: article['readTime'] ?? 5,
              width: cardWidth,
              height: cardHeight,
            ),
          );
        },
      ),
    );
  }
}
