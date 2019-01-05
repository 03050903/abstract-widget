import 'package:abstract_widget/wrapper.dart';
import 'package:flutter/widgets.dart';

typedef Widget DerivedBuilder<T>(T value);
typedef Widget ContextDerivedBuilder<T>(BuildContext context, T value);

class AbstractWidget<T> extends StatelessWidget {
  AbstractWidget(this.value, {this.assertTypes = true});

  /// Current value of the generic type [T].
  final T value;

  /// Indicates whether widget should verify that reified type arguments of
  /// registered builders are subtypes of [T].
  final bool assertTypes;

  final Map<Type, dynamic> _builders = {};

  /// Registers derived class builder that builds the widget depending
  /// on current type of [value].
  void when<R extends T>(DerivedBuilder<R> builder) {
    _validateBuilder(R, builder);
    _builders[R] = BuilderWrapper<T, R>(builder);
  }

  /// Registers derived class builder that builds the widget depending
  /// on [BuildContext] and current type of [value].
  void contextWhen<R extends T>(ContextDerivedBuilder<R> builder) {
    _validateBuilder(R, builder);
    _builders[R] = ContextBuilderWrapper<T, R>(builder);
  }

  void _validateBuilder(Type derivedType, dynamic builder) {
    if (builder == null) {
      _throwNullBuilder(derivedType);
    }
    if (assertTypes && derivedType == Null) {
      _throwIncompatibleType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final builder = _builders.values.cast<Wrapper>().firstWhere(
        (it) => it.isDerived(value),
        orElse: () => _throwUnknownType);
    return builder.buildWidget(context, value) ?? _throwNullWidget();
  }

  get _throwUnknownType =>
      throw Exception("Attempted to build AbstractBuilder for unknown type: " +
          "${value.runtimeType}. Registered types were: ${_builders.keys}.");

  get _throwIncompatibleType => throw Exception(
      "Attempted to register DerivedBuilder of type argument that is not " +
          "subtype of $T. Either make sure all AbstractWidget builders have " +
          "correct type or disable type checking by setting \'assertTypes\' " +
          "parameter to false.");

  get _throwNullWidget => throw Exception(
      "DerivedBuilder of type ${value.runtimeType} has returned null widget.");

  void _throwNullBuilder(Type derivedType) =>
      throw Exception("Attempted to register for derived type: $derivedType.");
}
