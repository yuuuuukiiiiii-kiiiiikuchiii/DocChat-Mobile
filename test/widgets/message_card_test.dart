import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rag_faq_document/pages/widgets/message_card.dart';


void main() {
  group('Message Cards', () {
    testWidgets('MyMessageCard displays message, date, and icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MyMessageCard(
              message: 'Hello!',
              date: '10:00 AM',
            ),
          ),
        ),
      );

      // メッセージ表示確認
      expect(find.text('Hello!'), findsOneWidget);

      // 日付表示確認
      expect(find.text('10:00 AM'), findsOneWidget);

      // 既読アイコンがあるか確認
      expect(find.byIcon(Icons.done_all), findsOneWidget);
    });

    testWidgets('SenderMessageCard displays message and date', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SenderMessageCard(
              message: 'Hi there!',
              date: '10:01 AM',
            ),
          ),
        ),
      );

      // メッセージ表示確認
      expect(find.text('Hi there!'), findsOneWidget);

      // 日付表示確認
      expect(find.text('10:01 AM'), findsOneWidget);

      // 既読アイコンがないことを確認
      expect(find.byIcon(Icons.done_all), findsNothing);
    });
  });
}
