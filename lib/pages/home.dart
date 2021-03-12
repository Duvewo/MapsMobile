import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class HomePageClass extends StatefulWidget {
  @override
  _HomePageClassState createState() => _HomePageClassState();
}

class _HomePageClassState extends State<HomePageClass> {
  MapController controller;
  GlobalKey<ScaffoldState> scaffoldKey;
  ValueNotifier<bool> zoomNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> advPickerNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    );
    scaffoldKey = GlobalKey<ScaffoldState>();
    Future.delayed(Duration(seconds: 10), () async {
      await controller.drawRect(RectOSM(
        key: "rect",
        centerPoint: GeoPoint(latitude: 47.4333594, longitude: 8.4680184),
        distance: 1200.0,
        color: Colors.red,
        strokeWidth: 0.3,
      ));
    });
    Future.delayed(Duration(seconds: 20), () async {
      await controller.removeAllShapes();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
        title: Text("Maps"),
      ),
      body: OrientationBuilder(
        builder: (ctx, orientation) {
          return Container(
            child: Stack(
              children: [
                OSMFlutter(
                  controller: controller,
                  //trackMyPosition: trackingNotifier.value,
                  useSecureURL: false,
                  showDefaultInfoWindow: false,
                  defaultZoom: 3.0,

                  onLocationChanged: (myLocation) {
                    print(myLocation);
                  },
                  onGeoPointClicked: (geoPoint) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${geoPoint.toMap().toString()}",
                        ),
                        action: SnackBarAction(
                          onPressed: () => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(),
                          label: "hide",
                        ),
                      ),
                    );
                  },
                  staticPoints: [
                    StaticPositionGeoPoint(
                      "line 1",
                      MarkerIcon(
                        icon: Icon(
                          Icons.train,
                          color: Colors.green,
                          size: 48,
                        ),
                      ),
                      [
                        GeoPoint(latitude: 47.4333594, longitude: 8.4680184),
                        GeoPoint(latitude: 47.4317782, longitude: 8.4716146),
                      ],
                    ),
                    StaticPositionGeoPoint(
                      "line 2",
                      MarkerIcon(
                        icon: Icon(
                          Icons.train,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      [
                        GeoPoint(latitude: 47.4433594, longitude: 8.4680184),
                        GeoPoint(latitude: 47.4517782, longitude: 8.4716146),
                      ],
                    )
                  ],
                  road: Road(
                    startIcon: MarkerIcon(
                      icon: Icon(
                        Icons.person,
                        size: 64,
                        color: Colors.brown,
                      ),
                    ),
                    roadColor: Colors.red,
                  ),
                  markerIcon: MarkerIcon(
                    icon: Icon(
                      Icons.home,
                      color: Colors.orange,
                      size: 64,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: zoomNotifierActivation,
                    builder: (ctx, visible, child) {
                      return AnimatedOpacity(
                        opacity: visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        ElevatedButton(
                          child: Icon(Icons.add),
                          onPressed: () async {
                            controller.zoomIn();
                          },
                        ),
                        ElevatedButton(
                          child: Icon(Icons.remove),
                          onPressed: () async {
                            controller.zoomOut();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: advPickerNotifierActivation,
                    builder: (ctx, visible, child) {
                      return AnimatedOpacity(
                        opacity: visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: child,
                      );
                    },
                    child: FloatingActionButton(
                      key: UniqueKey(),
                      child: Icon(Icons.arrow_forward),
                      heroTag: "confirmAdvPicker",
                      onPressed: () async {
                        advPickerNotifierActivation.value = false;
                        GeoPoint p =
                        await controller.selectAdvancedPositionPicker();
                        print(p);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!trackingNotifier.value) {
            await controller.currentLocation();
            await controller.enableTracking();
          } else {
            await controller.disabledTracking();
          }
          trackingNotifier.value = !trackingNotifier.value;
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: trackingNotifier,
          builder: (ctx, isTracking, _) {
            if (isTracking) {
              return Icon(Icons.gps_off_sharp);
            }
            return Icon(Icons.my_location);
          },
        ),
      ),
    );
  }
}
