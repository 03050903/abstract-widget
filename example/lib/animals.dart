import 'dart:math';

abstract class Animal {
  Animal();

  String get imageUrl;

  factory Animal.random() =>
      _animals[Random().nextInt(_animals.keys.length)].call();

  static final _animals = {
    0: () => Doge(),
    1: () => Cate(),
    2: () => Snek(),
    3: () => Birb(),
  };
}

class Doge extends Animal {
  final int badDeeds = 0;
  final int goodDeeds = Random().nextInt(20);

  @override
  String get imageUrl =>
      'https://i.pinimg.com/originals/2b/8d/29/2b8d29c19ca209b35b14e91ef60e9100.jpg';
}

class Cate extends Animal {
  static final _breeds = [
    'Oriental',
    'Birman',
    'Tonkinese',
    'Egyptian Mau',
    'Scottish Fold',
  ];

  final String breed = _breeds[Random().nextInt(_breeds.length)];
  final bool friendly = Random().nextBool();

  @override
  String get imageUrl =>
      'https://i.kym-cdn.com/photos/images/original/001/275/715/010.png';
}

class Snek extends Animal {
  final String inAscii = """
                    oo
. . . __/\\_/\\_/`'
  """;

  @override
  String get imageUrl =>
      'https://assets.change.org/photos/5/dd/yo/qRDDYOBxawsBjar-1600x900-noPad.jpg';
}

class Birb extends Animal {
  static const _MAX_SPEED = 200;

  final int speed = Random().nextInt(_MAX_SPEED);
  final int maxSpeed = _MAX_SPEED;

  @override
  String get imageUrl =>
      'https://i.pinimg.com/236x/d1/0b/38/d10b380698c625c6bfacbf0b9c4aaf2d--ostriches-the-sand.jpg';
}
