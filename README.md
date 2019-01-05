# AbstractWidget

[![pub package](https://img.shields.io/pub/v/abstract_widget.svg)](https://pub.dartlang.org/packages/abstract_widget)

Generic widget that builds itself depending on the derived class of current value.

![AbstractWidget example](https://thumbs.gfycat.com/DeadlyGiganticHog-small.gif)

## Usage

1. Define classes hierarchy:
```Dart
abstract class Animal {
  static Animal get random => Random().nextBool() ? Doge() : Cate();
}

class Doge extends Animal {
  final int badDeeds = 0;
  final int goodDeeds = Random().nextInt(20);
}


class Cate extends Animal {
  static final _breeds = ['Oriental', 'Birman', 'Tonkinese'];

  final String breed = _breeds[Random().nextInt(_breeds.length)];
  final bool friendly = Random().nextBool();
}

```
2. Create widget and pass it necessary builder functions:

```Dart
// ...
  child: AbstractWidget<Animal>(Animal.random)
    ..when<Doge>((doge) => Text('wow. such widget.'))
    // It's also correct to omit type parameters as they will 
    // be inferred depending on argument type of the builder.
    ..when((Doge doge) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Bad deeds: ${doge.badDeeds}'),
            Text('Good deeds: ${doge.goodDeeds}'),
          ]),
        ))
    ..when<Cate>(_buildCate),
  
  
Widget _buildCate(Cate cate) {
  // build cate widget here
}
```

### Note

Be cautious when passing builder functions without explicitly specifying generic type argument (like `..when((Doge doge) => ...)` in the example above). In case of an incompatible type, Dart analyzer won't mark it as error, which will **result in runtime exception**.
