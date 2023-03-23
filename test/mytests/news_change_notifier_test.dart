import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

//Dont do this...
// class BadMockNewsService implements NewsService {
//   bool getArticlesLoaded = false;
//   @override
//   Future<List<Article>> getArticles() async {
//     getArticlesLoaded = true;
//     return [
//       Article(title: 'Test 1', content: 'Test 1 Content'),
//       Article(title: 'Test 2', content: 'Test 2 Content'),
//       Article(title: 'Test 3', content: 'Test 3 Content'),
//     ];
//   }
// }

// //Instead do this.
// class MockNewsService extends Mock implements NewsService {}

// void main() {
//   late NewsChangeNotifier sut;

//   late MockNewsService mockNewsService;

//   setUp(() {
//     mockNewsService = MockNewsService();

//     sut = NewsChangeNotifier(mockNewsService);
//   });

//   test('Check initial values are correct', () {
//     //Expect has initial setup for values and final values. [expect(initial(actual), final (expected))]

//     expect(sut.articles, []);
//     expect(sut.isLoading, false);
//   });

//   group('getArticles', () {
//     final articlesFromService = <Article>[
//       Article(title: 'Title 1', content: 'Content 1 Description'),
//       Article(title: 'Title 2', content: 'Content 2 Description'),
//       Article(title: 'Title 3', content: 'Content 3 Description'),
//     ];

//     void fetchOnlyThreeArticles() {
//       when(() => mockNewsService.getArticles()).thenAnswer((invocation) async {
//         return articlesFromService;
//       });
//     }

//     test('gets articles using the news service', () async {
//       // when(() => mockNewsService.getArticles())
//       //     .thenAnswer((invocation) async => []);
//       fetchOnlyThreeArticles();

//       await mockNewsService.getArticles();

//       verify(() => mockNewsService.getArticles()).called(1);
//     });
//     test("""Loading indicator,
//          binds the right articles from service, verify fields,
//          Indicated no more loading
//          """, () async {
//       fetchOnlyThreeArticles();

//       final result = sut.getArticles();
//       expect(sut.isLoading, true);
//       await result;
//       expect(sut.articles, articlesFromService);
//       expect(sut.isLoading, false);
//     });
//   });
// }

// // Tscaffold :
//  void main() {

//   late ClassName className;
//   setUp(() {
//     className = className();

//   });

//   test('Ensure all initial inputs added', () {

//     expect(actual, matcher);

//   });
// }

class MockNewsService extends Mock implements NewsService {}

void main() {
  // All tests must have a starting point.

  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  // Setup initial [Params]/[Classes] just before we begin testing.

  setUp(() {
    //Create a  new instance of MockNewsService.
    mockNewsService = MockNewsService();
    //Our change notifier expects an instance of the News Service.
    sut = NewsChangeNotifier(mockNewsService);
  });

//We perform group tests so we can assert a feature/Features/ Components of a feature.
  group('Test News Feature', () {
    final threeArticles = [
      Article(title: 'Title 1', content: 'Content 1'),
      Article(title: 'Title 2', content: 'Content 2'),
      Article(title: 'Title 3', content: 'Content 3'),
    ];

    //Function to trigger service to get News from a simulated server.
    void fetchAtleastThreeArticles(){
      when(() => mockNewsService.getArticles())
          .thenAnswer((invocation) async => threeArticles);
    }

    // Check if the initial values are correct .
    test('Check if initial values are correct', () async {
      // Expect a list of ariticles initially to be empty.
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    });

    //Verify that the service locator was just called once.
    test('Ensure articles service called once', () async{
     fetchAtleastThreeArticles();

      await mockNewsService.getArticles();

      verify(() => mockNewsService.getArticles(),).called(1);
    });

    // Test the status of initial locading, articles loaded and verify that loading stopped.
    test('''Test initial status is loading, get data that was fetched, status no more loading.''', () async{

      fetchAtleastThreeArticles();

      final result = sut.getArticles();
      expect(sut.isLoading, true);
      await result;
      expect(sut.articles.length,3);
      expect(sut.isLoading, false);

    });
  });
}
