import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'PressStart'
      ),
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  @override
  _ColorGameState createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {

    final Map<String,bool> score={};

    final Map choices ={
      '💙' : Colors.blue,
      '🌷' : Colors.pink,
      '🌟' : Colors.yellow,
      '❤️' : Colors.red,
      '🐻' : Colors.brown,
      '🖤' : Colors.black
    };
    int seed = 0;

    AudioCache _audioController = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score ${score.length} / 6'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: (){
          setState(() {
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choices.keys.map((emoji){
              return Draggable<String>(
                data: emoji,
                child: Emoji(emoji: score[emoji] == true ? '☑':emoji,),
                feedback: Emoji(emoji: emoji,),
                childWhenDragging: Emoji(emoji: '🌱',),
              );
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys.map((emoji)=>_buildDragTarget(emoji)).toList()
            ..shuffle(Random(seed)),
          )
        ],
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context , List<String> incoming , List rejected){
        if(score[emoji] == true){
          return Container(
            color: Colors.white,
            child: Text('Correct !'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        }else{
          return Container(color:choices[emoji],height: 80,width: 200,);
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data){
        setState(() {
          score[emoji] = true;
        });
        _audioController.play('success.mp3.mp3');
      },
      
      onLeave: (data){},
    );
  }
}

class Emoji extends StatelessWidget {

  Emoji({Key key,this.emoji}): super(key:key);
  final String emoji;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black , fontSize: 50),
        ),
      ),
    );
  }
}
