import 'package:flutter_template/data/storage%20/persistence/object_persistence.dart';
import 'package:flutter_template/data/storage%20/repository/single_item_repository.dart';
import 'package:flutter_template/di/providers/api_provider.dart';
import 'package:flutter_template/features/system_info/model/system_info_record.dart';

class SystemInfoRepository extends SingleItemRepository {
  ApiProvider _apiProvider;
  ObjectPersistence<SystemInfoRecord> persistence;

  SystemInfoRepository(this._apiProvider, this.persistence);

  @override
  Future<SystemInfoRecord> getItem() async {
    return SystemInfoRecord.fromHorizonState(
        await _apiProvider.getApi().info.getSystemInfo());
  }

//TODO add getNetworkParams function
}
