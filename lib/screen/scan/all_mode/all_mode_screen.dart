import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanera/manager/scan_all_manager.dart';
import 'package:scanera/screen/scan/home_screen_controller.dart';
import 'package:scanera/widget/scan_controller.dart';

class AllModeScreen extends StatefulWidget {
  const AllModeScreen({
    Key? key,
    required this.scanAllManager,
  }) : super(key: key);

  final ScanAllManager scanAllManager;

  @override
  State<AllModeScreen> createState() => _AllModeScreenState();
}

class _AllModeScreenState extends State<AllModeScreen> {
  final ScrollController _controller = ScrollController();

  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAllScan();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startAllScan() {
    isScanning = true;
    widget.scanAllManager.setListener(displayData);
    widget.scanAllManager.startAllScan(context: context);
  }

  void stopAllScan() {
    isScanning = false;
    widget.scanAllManager.stopAllScan();
  }

  void resumeAllScan() {
    isScanning = true;
    widget.scanAllManager.resumeAllScan(context: context);
  }

  void displayData() {
    if (mounted) {
      setState(() {});
      _controller.jumpTo(_controller.position.maxScrollExtent + 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<HomeController>(
              builder: (_, controller, ___) => ScanController(
                onPressedSecond: () {
                  isScanning ? stopAllScan() : resumeAllScan();
                },
                coordinates: controller.state.coordinates,
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider(
                create: (_) => ScanAllManager(),
                child: Consumer<ScanAllManager>(builder: (_, controller, ___) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.scanAllManager.logs.length,
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        widget.scanAllManager.logs[index],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
