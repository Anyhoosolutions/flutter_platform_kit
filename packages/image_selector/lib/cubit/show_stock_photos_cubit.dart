import 'package:flutter_bloc/flutter_bloc.dart';

class ShowStockPhotosCubit extends Cubit<bool> {
  ShowStockPhotosCubit() : super(false);

  void showStockPhotos() {
    emit(true);
  }

  void hideStockPhotos() {
    emit(false);
  }
}
