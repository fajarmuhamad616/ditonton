import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _testWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Should displaying image', (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(_testWidget(AboutPage()));
    expect(find.image(AssetImage('assets/circle-g.png')), findsOneWidget);
  });
}
