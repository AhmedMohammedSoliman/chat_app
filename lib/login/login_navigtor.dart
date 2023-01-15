import '../dataBase/userModel.dart';

abstract class LoginNavigator {
  showMessage (String message);
  hideLoading();
  showLoading();
  navigateToHome (MyUser user);
}