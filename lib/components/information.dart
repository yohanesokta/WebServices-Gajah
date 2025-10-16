

import 'package:flutter/material.dart';
import 'package:gajahweb/utils/process.dart';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/terminal_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final ScrollController _scrollController = ScrollController();
  late Terminalcontext _terminalContext;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkingUsedPort();

    // The listener is added after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _terminalContext = context.read<Terminalcontext>();
      _terminalContext.addListener(_scrollToBottom);
    });
  }

  @override
  void dispose() {
    // The listener must be removed when the widget is disposed.
    _terminalContext.removeListener(_scrollToBottom);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkingUsedPort() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String nginxPort = preferences.getString("nginxPort") ?? "80";
    String mariadbPort = preferences.getString("mariadbPort") ?? "3306";

    if (!mounted) return;

    final terminalContext = Provider.of<Terminalcontext>(
      context,
      listen: false,
    );
    final bool mariadbStatus = await isPortAvailable(mariadbPort);
    final bool nginxStatus = await isPortAvailable(nginxPort);

    if (!nginxStatus) {
      terminalContext.add("$nginxPort : port nginx telah di gunakan!");
    }
    if (!mariadbStatus) {
      terminalContext.add("$mariadbPort : port mariadb telah di gunakan");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final terminal = context.watch<Terminalcontext>();

    return Container(
      height: 120, // Increased height
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Use theme color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5),),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Added padding
        child: ListView.builder(
          itemCount: terminal.terminalContext.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            return Text(
              terminal.terminalContext[index],
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                height: 1.2,
              ),
            );
          },
        ),
      ),
    );
  }
}
