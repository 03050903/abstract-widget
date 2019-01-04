import 'package:abstract_widget/abstract_widget.dart';
import 'package:flutter/material.dart';

import 'animals.dart';

void main() => runApp(AnimalsPage(animalCount: 20));

class AnimalsPage extends StatelessWidget {
  AnimalsPage({int animalCount})
      : _animals = List.generate(animalCount, (_) => Animal.random());

  final List<Animal> _animals;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('AbstractWidget example')),
        body: Builder(
          builder: (subContext) => ListView.builder(
                itemCount: _animals.length,
                itemBuilder: (_, index) =>
                    _buildAnimalItem(subContext, _animals[index]),
              ),
        ),
      ),
    );
  }

  Widget _buildAnimalItem(BuildContext context, Animal animal) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        leading: Image.network(
          animal.imageUrl,
          width: 48.0,
        ),
        title: Text(animal.runtimeType.toString()),
        subtitle: AbstractWidget(animal)
          ..when<Doge>(_buildDoge)
          ..when<Cate>(_buildCate)
          ..contextWhen<Birb>(_buildBirb)
          ..when<Snek>((it) => Text(it.inAscii)),
        trailing: IconButton(
          icon: Icon(Icons.call),
          onPressed: () {},
        ),
        onTap: () => _showAnimalInfo(context, animal),
      ),
    );
  }

  Widget _buildDoge(Doge doge) {
    final style = TextStyle(fontSize: 12.0);
    return Row(children: [
      Expanded(child: Text('Bad deeds: ${doge.badDeeds}', style: style)),
      Expanded(child: Text('Good deeds: ${doge.goodDeeds}', style: style)),
    ]);
  }

  Widget _buildCate(Cate cate) {
    final style = TextStyle(fontSize: 12.0);
    final height = 20.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height,
                child: Text(cate.breed),
              ),
              Text('Breed', style: style),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: height,
                      child: Icon(
                        cate.friendly ? Icons.check : Icons.clear,
                        color: Colors.black54,
                        size: height,
                      ),
                    ),
                    Text('Likes birbs', style: style),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildBirb(BuildContext context, Birb birb) {
    final height = 20.0;
    return GestureDetector(
      onTap: () => _showBirbSpeedDialog(context, birb.speed),
      child: Stack(children: [
        Center(
          child: Container(
            height: height,
            child: LinearProgressIndicator(value: birb.speed / birb.maxSpeed),
          ),
        ),
        Container(
          height: height,
          child: Center(
            child: Text(
              '${birb.speed} kph',
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
        ),
      ]),
    );
  }

  void _showBirbSpeedDialog(BuildContext context, int speed) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '$speed kph equals to ${(speed * 0.6214).toInt()} mph.',
              ),
            ),
          ),
    );
  }

  void _showAnimalInfo(BuildContext context, Animal animal) {
    final animalName = animal.runtimeType.toString().toLowerCase();
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Text("It's a $animalName!"),
    ));
  }
}
