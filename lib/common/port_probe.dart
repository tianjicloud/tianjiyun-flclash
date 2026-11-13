import 'dart:io';

const _reservedMixedPorts = <int>{
  53,
  80,
  443,
  1080,
  7890,
  7891,
  7892,
  8080,
  9090,
  9091,
};

bool isReservedMixedPort(int port) => _reservedMixedPorts.contains(port);

bool isPortConflictError(Object error) => RegExp(
  r'(address already in use|bind:|listen tcp|only one usage of each socket)',
  caseSensitive: false,
).hasMatch(error.toString());

Future<int> findAvailableMixedPort() async {
  for (var attempt = 0; attempt < 32; attempt++) {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = socket.port;
    await socket.close();
    if (!isReservedMixedPort(port)) return port;
  }
  throw const SocketException('No available mixed port was found');
}
