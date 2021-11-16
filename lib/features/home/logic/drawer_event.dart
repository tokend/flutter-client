import 'drawer_state.dart';

abstract class DrawerEvent {
  const DrawerEvent();
}

class NavigateTo extends DrawerEvent {
  final NavItem destination;

  const NavigateTo(this.destination);
}
