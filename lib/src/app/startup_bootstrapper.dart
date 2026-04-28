import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/notification_scheduler.dart';
import '../core/services/notification_service.dart';

class StartupBootstrapper extends ConsumerStatefulWidget {
  const StartupBootstrapper({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<StartupBootstrapper> createState() =>
      _StartupBootstrapperState();
}

class _StartupBootstrapperState extends ConsumerState<StartupBootstrapper> {
  bool _startBackgroundServices = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(NotificationService.instance.initialize().catchError((_) {}));
      setState(() => _startBackgroundServices = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_startBackgroundServices) {
      ref.watch(notificationSchedulerProvider);
    }
    return widget.child;
  }
}
