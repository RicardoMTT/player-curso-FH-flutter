import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/models/audioplayer_model.dart';
import 'package:flutter_application_2/src/pages/music_player.dart';
import 'package:flutter_application_2/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new AudioPlayerModel(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: miTema,
          title: 'Audio App',
          home: MusicPlayerPage()),
    );
  }
}
