import 'package:nb_utils/nb_utils.dart';

import 'Constants.dart';

Future<bool> isLoggedIn() async {
  return getBoolAsync(IS_LOGGED_IN);
}
Future<bool> isGuestUser() async {
  return getBoolAsync(IS_GUEST_USER);
}