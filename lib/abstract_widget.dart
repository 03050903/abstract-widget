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

  final Map<Type, dynamic> _builders = Map();
  final Map<Type, dynamic> _contextBuilders = Map();

  Type get _currentType => value.runtimeType;

  List<Type> get _types =>
      []..addAll(_builders.keys)..addAll(_contextBuilders.keys);

  /// Registers derived class builder that builds the widget depending
  /// on current value of [T].
  void when<R extends T>(DerivedBuilder<R> builder) {
    _assertType(R);
    _contextBuilders.remove(R);
    _builders[R] = builder;
  }

  /// Registers derived class builder that builds the widget depending
  /// on [BuildContext] and current value of [T].
  void contextWhen<R extends T>(ContextDerivedBuilder<R> builder) {
    _assertType(R);
    _builders.remove(R);
    _contextBuilders[R] = builder;
  }

  void _assertType(Type derivedType) {
    if (assertTypes) {
      assert(derivedType != Null, _incompatibleTypeMsg);
    }
  }

  @override
  Widget build(BuildContext context) =>
      _builders[_currentType]?.call(value) ??
      _contextBuilders[_currentType]?.call(context, value) ??
      _throwUnknownType;

  get _throwUnknownType =>
      throw Exception("Attempted to build AbstractBuilder for unknown type: " +
          "${value.runtimeType}. Available types were: ${_types.toString()}.");

  String get _incompatibleTypeMsg =>
      "Attempted to register DerivedBuilder of type argument that is not " +
      "subtype of $T. Either make sure all AbstractWidget builders have " +
      "correct type or disable type checking by setting \'assertTypes\' " +
      "parameter to false.";
}
