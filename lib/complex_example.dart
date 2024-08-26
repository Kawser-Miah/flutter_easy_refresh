import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

class Article {
  final String title;
  final String subtitle;
  final String imageUrl;

  Article({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class ComplexEasyRefreshExample extends StatefulWidget {
  const ComplexEasyRefreshExample({super.key});

  @override
  State<ComplexEasyRefreshExample> createState() =>
      _ComplexEasyRefreshExampleState();
}

class _ComplexEasyRefreshExampleState extends State<ComplexEasyRefreshExample> {
  List<Article> articles = [];
  int _nextPage = 1;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles({bool isRefresh = false}) async {
    if (isRefresh) {
      _nextPage = 1;
      articles.clear();
    }

    await Future.delayed(const Duration(seconds: 2));

    List<Article> newArticles = List.generate(10, (index) {
      int articleNumber = (_nextPage - 1) * 10 + index + 1;
      return Article(
        title: 'Article $articleNumber',
        subtitle: 'This is the subtitle for article $articleNumber.',
        imageUrl: 'https://via.placeholder.com/150?text=Image+$articleNumber',
      );
    });

    setState(() {
      articles.addAll(newArticles);
      _nextPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Coseries'),
      ),
      body: EasyRefresh(
        onRefresh: () async {
          await _loadArticles(isRefresh: true);
        },
        onLoad: () async {
          await _loadArticles();
        },
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Image.network(
                  article.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(article.title),
                subtitle: Text(article.subtitle),
              ),
            );
          },
        ),
      ),
    );
  }
}
