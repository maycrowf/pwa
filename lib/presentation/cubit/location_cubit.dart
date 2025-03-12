import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_oper_app/core/services/location_service.dart';
import 'package:road_oper_app/core/services/web_view_service.dart';

class LocationCubit extends Cubit<void> {
  final LocationService _locationService;
  final WebViewService _webViewService;

  LocationCubit(this._locationService, this._webViewService) : super(null);

  void startUpdateAndSendLocation() {
    _locationService.startLocationUpdates((lat, lon, heading) {
      _webViewService.sendLocationToWeb(
        lat: lat,
        lon: lon,
        heading: heading,
      );
    });
  }

  void cancel() => _locationService.cancel();
}
