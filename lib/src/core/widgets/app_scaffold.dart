import 'package:flutter/material.dart';

import 'app_background.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.backgroundMood = AppBackgroundMood.calm,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final AppBackgroundMood backgroundMood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: floatingActionButton == null
          ? null
          : Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              child: floatingActionButton,
            ),
      appBar: AppBar(title: Text(title), actions: actions),
      body: AppBackground(
        mood: backgroundMood,
        child: SafeArea(top: false, child: body),
      ),
    );
  }
}
