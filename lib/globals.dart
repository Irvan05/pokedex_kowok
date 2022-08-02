import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Color(0xFF)
const hp = Color(0xFFff0000);
const hpBg = Color(0xFFff5959);
const atk = Color(0xFFf08030);
const atkBg = Color(0xFFf5ac78);
const def = Color(0xFFf8d030);
const defBg = Color(0xFFfae078);
const sAtk = Color(0xFF6890f0);
const sAtkBg = Color(0xFF9db7f5);
const sDef = Color(0xFF78c850);
const sDefBg = Color(0xFFa7db8d);
const spd = Color(0xFFf85888);
const spdBg = Color(0xFFfa92b2);

const darkModeBg = Color(0XFF303030);
const background = Color(0xFF706f6b);
const abilities = Color(0xFF303538);
const backgroundFade = Color(0x99706f6b);

const deviceMainColor = Color(0xFFdc092d);

const colorTag = {
  'normal': 0xFF9099a1,
  'fighting': 0xFFce4069,
  'flying': 0xFF8fa8dd,
  'poison': 0xFFab6ac8,
  'ground': 0xFFd97746,
  'rock': 0xFFc7b78b,
  'bug': 0xFF90c12c,
  'ghost': 0xFF5269ac,
  'steel': 0xFF5a8ea1,
  'fire': 0xFFff9c54,
  'water': 0xFF4d90d5,
  'grass': 0xFF63bb5b,
  'electric': 0xFFf3d23b,
  'psychic': 0xFFf97176,
  'ice': 0xFF74cec0,
  'dragon': 0xFF0a6dc4,
  'dark': 0xFF5a5366,
  'fairy': 0xFFec8fe6,
  'background': 0xFF706f6b,
  'abilities': 0xFF303538,
  'unknown': 0xFF303538,
};

class OutlineTitle extends StatelessWidget {
  OutlineTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Text(
        '$title',
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 1.0,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5
            ..color = backgroundFade,
        ),
      ),
      Text('$title',
          style:
              TextStyle(letterSpacing: 1.0, fontSize: 20, color: Colors.white)),
    ]);
  }
}

// run on web flutter run -d Chrome --release
