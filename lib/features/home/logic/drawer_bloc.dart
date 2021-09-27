import 'package:flutter_template/base/base_bloc.dart';
import 'package:flutter_template/features/home/logic/drawer_event.dart';
import 'package:flutter_template/features/home/logic/drawer_state.dart';

class DrawerBloc extends BaseBloc<DrawerEvent, DrawerState> {
  DrawerBloc(DrawerState initialState) : super(initialState);

  @override
  Stream<DrawerState> mapEventToState(DrawerEvent event) async* {
    if (event is NavigateTo) {
      // only route to a new location if the new location is different
      if (event.destination != state.selectedItem) {
        yield DrawerState(event.destination);
      }
    }
  }
}
