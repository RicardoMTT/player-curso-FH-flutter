import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/helpers/helper.dart';
import 'package:flutter_application_2/src/models/audioplayer_model.dart';
import 'package:flutter_application_2/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Background(),
        Column(
          children: [
            CustomAppBar(),
            ImageDiscoDuration(),
            TituloPlay(),
            Expanded(child: Lyrics())
          ],
        ),
      ],
    ));
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [Color(0xff33333E), Color(0xff201E28)])),
    );
  }
}

class Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Container(
        child: ListWheelScrollView(
      itemExtent: 42,
      diameterRatio: 1.5,
      physics: BouncingScrollPhysics(),
      children: lyrics
          .map((e) => Text(e,
              style: TextStyle(
                  fontSize: 20, color: Colors.white.withOpacity(0.6))))
          .toList(),
    ));
  }
}

class TituloPlay extends StatefulWidget {
  @override
  _TituloPlayState createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay>
    with SingleTickerProviderStateMixin {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool firstTime = true;
  bool isPlaying = false;
  AnimationController playAnimation;
  @override
  void initState() {
    this.playAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    this.playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);

    assetsAudioPlayer.open(
      Audio("assets/new_life.mp3"),
    );

    assetsAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    assetsAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio.audio.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      margin: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Fire away',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                'Breaking Benjamin',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
          Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioPlayerModel =
                  Provider.of<AudioPlayerModel>(context, listen: false);
              if (this.isPlaying) {
                playAnimation.reverse();
                this.isPlaying = false;

                audioPlayerModel.controller.stop();
              } else {
                playAnimation.forward();

                this.isPlaying = true;
                audioPlayerModel.controller.repeat();
              }
              if (firstTime) {
                this.open();

                firstTime = false;
              } else {
                assetsAudioPlayer.playOrPause();
              }
            },
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
                icon: AnimatedIcons.play_pause, progress: playAnimation),
          )
        ],
      ),
    );
  }
}

class ImageDiscoDuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: [ImageDisco(), BarraProgreso()],
        ));
  }
}

class BarraProgreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;
    return Container(
      child: Column(
        children: [
          Text(
            '${audioPlayerModel.sontTotalDuration}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Container(
                width: 3,
                height: 200,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 200 * porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${audioPlayerModel.currentSecond}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
            ),
          )
        ],
      ),
    );
  }
}

class ImageDisco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayModel = Provider.of<AudioPlayerModel>(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: LinearGradient(begin: Alignment.topLeft, colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ])),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              manualTrigger: true,
              controller: (animationController) =>
                  audioPlayModel.controller = animationController,
              child: Image(
                image: AssetImage('assets/aurora.jpg'),
              ),
              infinite: true,
              duration: Duration(seconds: 10),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(100)),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                  color: Color(0xff1C1C25),
                  borderRadius: BorderRadius.circular(100)),
            ),
          ],
        ),
      ),
    );
  }
}
