import 'dart:math';

import 'package:dart_sdk/api/v3/info/model/HorizonStateResource.dart';
import 'package:dart_wallet/network_params.dart';

class SystemInfoRecord {
  String passphrase;
  int precisionMultiplier;
  int timeOffsetSeconds;
  int latestBlock;

  SystemInfoRecord(this.passphrase, this.precisionMultiplier,
      this.timeOffsetSeconds, this.latestBlock);

  int get precision => log(precisionMultiplier) ~/ log(10);

  /// @param source fresh [HorizonStateResource], if it's outdated then
  /// [timeOffsetSeconds] will be wrong
  SystemInfoRecord.fromHorizonState(HorizonStateResource source)
      : passphrase = source.data.networkPassphrase,
        precisionMultiplier = source.data.precision,
        timeOffsetSeconds =
            (DateTime.parse(source.data.currentTime).millisecondsSinceEpoch -
                    DateTime.now().millisecondsSinceEpoch) ~/
                1000,
        latestBlock = source.data.core.latest;

  NetworkParams toNetworkParams() {
    return NetworkParams(passphrase,
        precision: precision, timeOffsetSeconds: timeOffsetSeconds.toInt());
  }
}
