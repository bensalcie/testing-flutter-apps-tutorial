import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/article_page.dart';
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

  //Make sure widget tree is initalized.
  Widget initializeWidgetsTree() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets('''App was opened, first article tapped, opens details page and
   confirms title and content shown correctly''', (WidgetTester tester) async {
    fetchAtleastThreeArticles();
    await tester.pumpWidget(initializeWidgetsTree());
    await tester.pump();
    await tester.tap(find.text('Content 1'));


    await tester.pumpAndSettle();

    expect(find.byType(NewsPage), findsNothing);
    expect(find.byType(ArticlePage), findsOneWidget);
    expect(find.text('Title 1'), findsOneWidget);
    expect(find.text('Content 1'), findsOneWidget);

            await Future.delayed(const Duration(seconds: 2));


    
  });

    testWidgets('''App was opened, second article tapped, opens details page and
   confirms title and content shown correctly''', (WidgetTester tester) async {
    fetchAtleastThreeArticles();
    await tester.pumpWidget(initializeWidgetsTree());
    await tester.pump();
    await tester.tap(find.text('Content 2'));
    

    await tester.pumpAndSettle();

    expect(find.byType(NewsPage), findsNothing);
    expect(find.byType(ArticlePage), findsOneWidget);
    expect(find.text('Title 2'), findsOneWidget);
    expect(find.text('Content 2'), findsOneWidget);

        await Future.delayed(const Duration(seconds: 2));


    
  });


    testWidgets('''App was opened, third article tapped, opens details page and
   confirms title and content shown correctly''', (WidgetTester tester) async {
    fetchAtleastThreeArticles();
    await tester.pumpWidget(initializeWidgetsTree());
    await tester.pump();
    await tester.tap(find.text('Content 3'));

    

    await tester.pumpAndSettle();



    expect(find.byType(NewsPage), findsNothing);
    expect(find.byType(ArticlePage), findsOneWidget);
    expect(find.text('Title 3'), findsOneWidget);
    expect(find.text('Content 3'), findsOneWidget);
                await Future.delayed(const Duration(seconds: 2));


    
  });
  
}
