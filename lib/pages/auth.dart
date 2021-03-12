import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';

class AuthPageClass extends StatefulWidget {
  @override
  _AuthPageClassState createState() => _AuthPageClassState();
}

class _AuthPageClassState extends State<AuthPageClass> {
  String _platformImei = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext ctx) {
    final _usernameController = TextEditingController();
    final _usernameKey = GlobalKey<FormState>();

    return new Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(5)),
          Text("Введите никнейм"),
          TextFormField(
            key: _usernameKey,
            controller: _usernameController,
            decoration: InputDecoration(
                labelText: "Username", icon: Icon(Icons.account_box_outlined)),
            validator: (value) {
              if (value.length > 10 || value.length < 2 || value.isEmpty) {
                return 'Ваш никнейм должен быть больше двух и меньше 10 символов!';
              }
              return null;
            },
          ),
          Padding(padding: EdgeInsets.all(2)),
          ElevatedButton(
              onPressed: () {
                if (_usernameKey.currentState.validate()) {
                  final snackBar = SnackBar(
                    content: Text("Обработка данных..."),
                  );
                  ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                }
              },
              child: Text("Далее")),
        ],
      ),
    );
  }

  Future<void> initPlatformState() async {
    String platformImei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    } on MissingPluginException {
      platformImei = 'Missing plugin';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
  }
}
