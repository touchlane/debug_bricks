import 'package:debug_bricks_easy_localization/debug_bricks_easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const localeEn = Locale('en');
const localeRu = Locale('ru');

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpWidgetWithMaterialEasyLocalization(Widget widget) {
    return pumpWidget(wrapEasyLocalization(wrapMaterial(widget)));
  }

  Future<void> pumpWidgetWithMaterial(Widget widget) {
    return pumpWidget(wrapMaterial(widget));
  }
}

Widget wrapMaterial(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}

Widget wrapEasyLocalization(Widget child) {
  return EasyLocalization(
    supportedLocales: const [localeEn, localeRu],
    path: 'assets/translations',
    saveLocale: false,
    useOnlyLangCode: true,
    assetLoader: const TestLoader(),
    fallbackLocale: localeEn,
    child: child,
  );
}

class TestLoader extends AssetLoader {
  const TestLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    const Map<String, dynamic> en = {
      'value': 'en',
    };
    const Map<String, dynamic> ru = {
      'value': 'ru',
    };
    final Map<String, Map<String, dynamic>> mapLocales = {'en': en, 'ru': ru};
    return Future.value(mapLocales[locale.toString()]);
  }
}

class ContextConsumer extends StatelessWidget {
  final Function(BuildContext context) consumer;

  const ContextConsumer({Key? key, required this.consumer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    consumer(context);
    return const EasyLocalizationBrick(
      title: 'T',
    );
  }
}
