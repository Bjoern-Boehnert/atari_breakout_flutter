import 'package:atari_breakout_flutter/view/SettingsWidget.dart';
import 'package:atari_breakout_flutter/view/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

final GameController controller = GameController();

void main() async {
  Flame.device.fullScreen();
  Settings.init(cacheProvider: SharePreferenceCache());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Atari Breakout',
      home: const _MyStatefulWidget(),
    );
  }
}

class _MyStatefulWidget extends StatefulWidget {
  const _MyStatefulWidget();

  @override
  State<_MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<_MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _tabController.index != 0) {
        // Game --> Settings. Spiel stoppen!
        controller.stopGame();
      } else if (!_tabController.indexIsChanging && _tabController.index != 1) {
        // Settings --> Game. Settings wirksam machen
        controller.applySettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Atari Breakout'),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.play_arrow)),
            Tab(icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          GameWidget(game: controller),
          SettingsWidget(),
        ],
      ),
    );
  }
}
