import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Class to be used for mocking.
class MockNewsService extends Mock implements NewsService {}

void main() {
  final threeArticles = [
    Article(title: 'Title 1', content: 'Content 1'),
    Article(title: 'Title 2', content: 'Content 2'),
    Article(title: 'Title 3', content: 'Content 3'),
  ];

  late MockNewsService mockNewsService;
  setUp(() {
    //For integration and Widget tests we only need the Mock Service intance.

    mockNewsService = MockNewsService();
  });

  //Function to trigger service to get News from a simulated server.
  void fetchAtleastThreeArticles() {
    when(() => mockNewsService.getArticles())
        .thenAnswer((invocation) async => threeArticles);
  }

  //Function to trigger service to get News from a simulated server after 2 seconds
  void fetchAtleastThreeArticlesAfter2s() {
    when(() => mockNewsService.getArticles()).thenAnswer((invocation) async {
      await Future.delayed(const Duration(seconds: 2));
      return threeArticles;
    });
  }

  Widget initializeWidgetsTree() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  //Perform  Widget and Integration tests.

  //Perform Widget tests.

  testWidgets('title is displayed correctly', (WidgetTester tester) async {
    fetchAtleastThreeArticles();

    await tester.pumpWidget(initializeWidgetsTree());
    expect(find.text('News'), findsOneWidget);
  });

  testWidgets(
      'loading indicator is shown when articles are loading and dismised when no more loading.',
      (WidgetTester tester) async {
    //Fetch the articles after 2 seconds - To allow proper propagation time.

    fetchAtleastThreeArticlesAfter2s();
    await tester.pumpWidget(initializeWidgetsTree());
    await tester.pump(const Duration(microseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    //When we xpect widgets, we intend to test static widgets. Dynamic widgets will throw an exception.

    expect(
        find.byKey(
          const Key('progress-indicator'),
        ),
        findsOneWidget);

    expect(
        find.byKey(
          const Key('key-scaffold'),
        ),
        findsOneWidget);

    // Await till no more insterations happening on app.
    await tester.pumpAndSettle();
  });

  // Test if titles/ Descriptions are exactly the same.

  testWidgets('title and descriptions are shown correctly',
      (WidgetTester tester) async {
    fetchAtleastThreeArticles();
    await tester.pumpWidget(initializeWidgetsTree());
    await tester.pump();
    for (final article in threeArticles) {
      expect(find.text(article.title), findsOneWidget);

      expect(find.text(article.content), findsOneWidget);
    }
  });
}
