import 'dart:async';
import 'package:flutter/material.dart';

class HelpPageClass extends StatefulWidget {
  @override
  _HelpPageClassState createState() => _HelpPageClassState();
}

int _ticker = 15;
Timer _timer;

class _HelpPageClassState extends State<HelpPageClass> {
  void _startTimer() {
    const Duration dur = const Duration(seconds: 1);
    _timer = new Timer.periodic(dur, (Timer _timer) {
      setState(() {
        _ticker--;
      });

      if (_ticker <= 0) {
        setState(() {
          _timer.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    _startTimer();
    return new Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: FlutterLogo(),
              title: Text(
                  "Ставь метки об постах ДПС, авариях и прочих важных аспектах на дорогах своего города."),
            ),
            ListTile(
              leading: FlutterLogo(),
              title: Text(
                  "Просматривай метки других пользователей, обсуждай, оценивай."),
            ),
            ListTile(
              leading: FlutterLogo(),
              title: Text("Пока думаю"),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_ticker > 0) {
                    _showAlert(ctx);
                  } else {
                    return Navigator.pushReplacementNamed(ctx, "/");
                  }
                },
                child: Text("Понял! ($_ticker)")),
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Ошибка"),
              content: Text("Подождите еще $_ticker секунд!"),
            ));
  }
}
