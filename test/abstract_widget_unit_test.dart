import 'dart:collection';

import 'package:abstract_widget/abstract_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AbstractWidget<Iterable> _widget;
Function _initBlock;

Future get _initBuilders => Future(_initBlock);

void main() {
  setUp(() => _initBlock = null);

  group('assertTypes enabled', () {
    setUp(() => _widget = AbstractWidget([]));

    test('Accepts builders of derived types.', () {
      _initBlock = () {
        _widget
          ..when<List>((_) => Text('list'))
          ..when<Set>((_) => Text('set'))
          ..when((Queue _) => Text('queue'))
          ..when((Runes _) => Text('runes'))
          ..when((_) => Text('dynamic'));
      };

      expect(_initBuilders, completes);
    });

    test('Throws if builder with non-subtype argument is passed.', () {
      _initBlock = () {
        _widget.when((String _) => Text('string'));
      };

      expect(_initBuilders, throwsException);
    });
  });

  group('assertTypes disabled', () {
    setUp(() => _widget = AbstractWidget([], assertTypes: false));

    test('Accepts Null type builders when assertTypes disabled.', () {
      _initBlock = () {
        _widget.when((String _) => Text('string'));
      };

      expect(_initBuilders, completes);
    });

    test('Throws if builder is null.', () {
      _initBlock = () {
        _widget.when(null);
      };

      expect(_initBuilders, throwsException);
    });

    test('Throws if no builder was found for current value type.', () {
      _initBlock = () {
        _widget
          ..when<Set>((_) => Text('set'))
          ..build(null);
      };

      expect(_initBuilders, throwsException);
    });
  });
}
