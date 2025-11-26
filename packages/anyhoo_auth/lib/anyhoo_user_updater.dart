import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/updatable_for_anyhoo_user.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';

class AnyhooUserUpdater {
  final List<UpdatableForAnyhooUser> classes;
  final AnyhooAuthCubit<AnyhooUser> anyhooAuthCubit;

  AnyhooUserUpdater({required this.classes, required this.anyhooAuthCubit});

  void listen() {
    anyhooAuthCubit.stream.listen((authState) {
      final user = authState.user;
      for (var clazz in classes) {
        clazz.updateUser(user);
      }
    });
  }
}
