import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<List<Placemark>> getAddress(Position position) async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    return placemark;
  }

  Future<String> getCurrentAddress(Position position) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String current = placemark.subLocality + ', ' + placemark.locality;
    return current.length > 0 ? current : 'Malaysia';
  }

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<double> getDistance(Position from, Position to) async {
    if(from == null || to == null){
      return 0.0;
    }
    double distanceInMeters = await Geolocator().distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);
    return distanceInMeters;
  }

  Future<List<DocumentSnapshot>> getMatchedDistance(Position position, List<DocumentSnapshot> workers, int distance) async {
    List<DocumentSnapshot> nearby = new List();
    Position _position = position;

    for (var worker in workers) {
      Position workerPosition = new Position(
          latitude: worker.data['currentLocation'].latitude,
          longitude: worker.data['currentLocation'].longitude);
      double calculatedDistance =
          await this.getDistance(_position, workerPosition);

      if (calculatedDistance / 1000 <= distance) {
        nearby.add(worker);
      }
    }

    return nearby;
  }
}

GeolocatorService geoLocator = new GeolocatorService();
