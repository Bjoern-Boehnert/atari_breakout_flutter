import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ColorPickerSettingsTile(
          title: 'Farbe des Paddle',
          settingKey: 'paddleColor',
          defaultValue: Colors.green,
          onChange: (value) {
            debugPrint('paddleColor: $value');
          },
        ),
        ColorPickerSettingsTile(
          title: 'Farbe der Bricks',
          settingKey: 'brickColor',
          defaultValue: Colors.red,
          onChange: (value) {
            debugPrint('brickColor: $value');
          },
        ),
        ColorPickerSettingsTile(
          title: 'Farbe des Balls',
          settingKey: 'ballColor',
          defaultValue: Colors.blue,
          onChange: (value) {
            debugPrint('ballColor: $value');
          },
        ),
        SliderSettingsTile(
          title: 'Anzahl der Reihen der Bricks',
          settingKey: 'rowCount',
          defaultValue: 4,
          min: 1,
          max: 8,
          step: 1,
          leading: Icon(Icons.table_rows),
          onChange: (value) {
            debugPrint('rowCount: $value');
          },
        ),
        SliderSettingsTile(
          title: 'Anzahl der Spalten der Bricks',
          settingKey: 'columnCount',
          defaultValue: 4,
          min: 1,
          max: 8,
          step: 1,
          leading: Icon(Icons.view_column),
          onChange: (value) {
            debugPrint('columnCount: $value');
          },
        ),
        SliderSettingsTile(
          title: 'Außenabstand der Bricks',
          settingKey: 'margin',
          defaultValue: 1,
          min: 1,
          max: 4,
          step: 1,
          leading: Icon(Icons.crop_square),
          onChange: (value) {
            debugPrint('margin: $value');
          },
        ),
        SliderSettingsTile(
          title: 'Zwischenabstand der Bricks',
          settingKey: 'spacing',
          defaultValue: 8,
          min: 1,
          max: 8,
          step: 1,
          leading: Icon(Icons.compare_arrows),
          onChange: (value) {
            debugPrint('spacing: $value');
          },
        ),
      ],
    );
  }
}
