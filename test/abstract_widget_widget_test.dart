import 'package:abstract_widget/abstract_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AbstractWidget<Iterable> _widget;

void main() {
  setUp(() => _widget = AbstractWidget([2, 3, 6]));

  testWidgets('Throws if no builders are passed.', (WidgetTester tester) async {
    await tester.pumpWidget(_widget);

    expect(tester.takeException(), isException);
  });

  testWidgets('Builds if builder of derived type argument is added.',
      (WidgetTester tester) async {
    final listText = 'list';
    _widget.when<List>((_) => _buildText(listText));

    await tester.pumpWidget(_widget);

    expect(tester.takeException(), isNull);
    expect(find.text(listText), findsOneWidget);
  });

  testWidgets('Only last registered builder for given type is used.',
      (WidgetTester tester) async {
    final listTexts = ['list1', 'list2', 'list3'];
    listTexts.forEach((it) => _widget.when<List>((_) => _buildText(it)));

    await tester.pumpWidget(_widget);

    expect(tester.takeException(), isNull);
    expect(find.text(listTexts.last), findsOneWidget);
    expect(find.text(listTexts.first), findsNothing);
  });

  testWidgets(
      'Different builders of the same type argument override themselves.',
      (WidgetTester tester) async {
    final contextText = 'list built with context';
    final noContextText = 'list built without context';
    _widget
      ..when<List>((_) => _buildText(contextText))
      ..contextWhen<List>((context, _) => _buildText(noContextText));

    await tester.pumpWidget(_widget);

    expect(find.text(contextText), findsNothing);
    expect(find.text(noContextText), findsOneWidget);
  });
}

Widget _buildText(String text) => Text(text, textDirection: TextDirection.ltr);
