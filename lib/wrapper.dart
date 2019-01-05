import 'package:abstract_widget/abstract_widget.dart';
import 'package:flutter/widgets.dart';

abstract class Wrapper<T, R extends T, S> {
  Wrapper(this._builder);

  final S _builder;

  Type get type => R;

  bool isDerived(T value) => value is R;

  Widget buildWidget(BuildContext context, R value);
}

class BuilderWrapper<T, R extends T> extends Wrapper<T, R, DerivedBuilder<R>> {
  BuilderWrapper(DerivedBuilder<R> builder) : super(builder);

  @override
  Widget buildWidget(BuildContext context, R value) => _builder(value);
}

class ContextBuilderWrapper<T, R extends T>
    extends Wrapper<T, R, ContextDerivedBuilder<R>> {
  ContextBuilderWrapper(ContextDerivedBuilder<R> builder) : super(builder);

  @override
  Widget buildWidget(BuildContext context, R value) => _builder(context, value);
}
