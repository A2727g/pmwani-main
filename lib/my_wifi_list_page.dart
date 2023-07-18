import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pmwani/my_url_launcher.dart';
import 'package:pmwani/my_web_View.dart';
import 'package:wifi_scan/wifi_scan.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);


  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  bool get isStreaming => subscription != null;

  Future<void> _startScan(BuildContext context) async {
    // check if "can" startScan
    {
      // check if can-startScan
      final can = await WiFiScan.instance.canStartScan();
      // if can-not, then show error
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    // call startScan API
    final result = await WiFiScan.instance.startScan();
    if (mounted) kShowSnackBar(context, "startScan: $result");
    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable
          .listen((result) => setState(() => accessPoints = result));
    }
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
    setState(() => subscription = null);
  }

  @override
  void dispose() {
    super.dispose();
    // stop subscription for scanned results
    _stopListeningToScanResults();
  }

  // build toggle with label
  Widget _buildToggle({
    String? label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
  }) =>
      Row(
        children: [
          if (label != null) Text(label),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PM Wani'),
        actions: [
          IconButton(onPressed: () async => _getScannedResults(context),
              icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton.icon(
              //       icon: const Icon(Icons.perm_scan_wifi),
              //       label: const Text('SCAN'),
              //       onPressed: () async => _startScan(context),
              //     ),
              //     ElevatedButton.icon(
              //       icon: const Icon(Icons.refresh),
              //       label: const Text('GET'),
              //       onPressed: () async => _getScannedResults(context),
              //     ),
              //     _buildToggle(
              //       label: "STREAM",
              //       value: isStreaming,
              //       onChanged: (shouldStream) async => shouldStream
              //           ? await _startListeningToScanResults(context)
              //           : _stopListeningToScanResults(),
              //     ),
              //   ],
              // ),
              const Divider(),
              Flexible(
                child: Center(
                  child: accessPoints.isEmpty
                      ? const Text("NO SCANNED RESULTS")
                      : ListView.builder(
                      itemCount: accessPoints.length,
                      itemBuilder: (context, i) =>
                          _AccessPointTile(accessPoint: accessPoints[i])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Show tile for AccessPoint.
///
/// Can see details when tapped.
class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey)),
    ),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value.toString()))
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = getWifiBar(accessPoint.level);
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon, color: Colors.blueGrey,),
      title: Text("SSID : ${title}"),
      subtitle: Text("BSSID : ${accessPoint.bssid}"),
     trailing: IconButton(
       onPressed: () {
         showDialog(
           context: context,
           builder: (context) => AlertDialog(
             title: Text(title),
             content: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 _buildInfo("SSDI", accessPoint.ssid),
                 _buildInfo("BSSDI", accessPoint.bssid),
                 _buildInfo("Capability", accessPoint.capabilities),
                 _buildInfo("frequency", "${accessPoint.frequency}MHz"),
                 _buildInfo("level", accessPoint.level),
                 _buildInfo("standard", accessPoint.standard),
                 _buildInfo(
                     "centerFrequency0", "${accessPoint.centerFrequency0}MHz"),
                 _buildInfo(
                     "centerFrequency1", "${accessPoint.centerFrequency1}MHz"),
                 _buildInfo("channelWidth", accessPoint.channelWidth),
                 _buildInfo("isPasspoint", accessPoint.isPasspoint),
                 _buildInfo(
                     "operatorFriendlyName", accessPoint.operatorFriendlyName),
                 _buildInfo("venueName", accessPoint.venueName),
                 _buildInfo("is80211mcResponder", accessPoint.is80211mcResponder),
               ],
             ),
           ),
         );
         return;

         /// pm wani -> home page webview
         Navigator.push(context, MaterialPageRoute(builder: (c) =>
         // const MyWebView()
         const MyUrlLauncherPage()
         ));
       },
         icon: const Icon(Icons.info_outline)
     ),
      onTap: () {
        /// pm wani -> home page webview
        Navigator.push(context, MaterialPageRoute(builder: (c) =>
        const MyWebView()
        // const MyUrlLauncherPage()
        ));
      },
    );
  }

  getWifiBar(int c) {
    if(c < -90) {
      return Icons.signal_wifi_0_bar;
    }
    if(c < -60) {
      return Icons.network_wifi_2_bar;
    }
    if(c < -50) {
      return Icons.network_wifi_3_bar;
    }
    return Icons.signal_wifi_4_bar;

  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

