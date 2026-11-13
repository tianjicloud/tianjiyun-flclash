import 'dart:ffi';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';

Future<bool> exportSupportReportFile(String error, List<Log> logs) async {
  final logTail = logs
      .skip(logs.length > maxLogsLength ? logs.length - maxLogsLength : 0)
      .map(
        (entry) => '${entry.dateTime} ${entry.logLevel.name} ${entry.payload}',
      )
      .join('\n');
  String? version;
  try {
    version = globalState.packageInfo.version;
  } catch (_) {}
  final report = redactReport(
    [
      'Error: $error',
      if (logTail.isNotEmpty) 'Application log tail:\n$logTail',
      if (version != null) 'App version: $version',
      'Platform: ${Platform.operatingSystem}',
      'Architecture: ${Abi.current()}',
    ].join('\n\n'),
  );
  final path = await appPath.tempFilePath;
  await File(path).safeWriteAsString(report);
  return await picker.saveFileWithPath('flclash-support-report.txt', path) !=
      null;
}
