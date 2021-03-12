import 'package:flutter/material.dart';

class DonatePageClass extends StatefulWidget {
  @override
  _DonatePageClassState createState() => _DonatePageClassState();
}

class _DonatePageClassState extends State<DonatePageClass> {
  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.symmetric(horizontal: 1.3),
              child: Row(
                children: [
                  FlutterLogo(),
                  Text("User"),
                  Icon(Icons.settings_applications)
                ],
              ),
            ),
            Divider(color: Colors.grey[400], thickness: 0.3),
            ListTile(
              title: Text("Главная"),
              onTap: () {
                Navigator.pushReplacementNamed(ctx, "/");
              },
            ),
            ListTile(
              title: Text("Об авторе"),
              onTap: () {
                Navigator.pushReplacementNamed(ctx, "/about");
              },
            ),
            ListTile(
              title: Text("Поддержать"),
              onTap: () {
                Navigator.pushReplacementNamed(ctx, "/donate");
              },
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 1.5,
            ),
            ListTile(
              title: Text("Версия: 0.1 alpha"),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Donate"),
      ),
      body: Center(
        child: Text("Ладно"),
      ),
    );
  }
}
