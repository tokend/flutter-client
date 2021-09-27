class DrawerState {
  final NavItem selectedItem;

  const DrawerState(this.selectedItem);
}

enum NavItem {
  dashboard,
  movements,
  assets,
  sales,
  polls,
  trade,
  issuance_request,
  limits,
  fees,
  settings,
  log_out,
}
