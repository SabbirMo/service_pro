import 'package:flutter_test/flutter_test.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/home/model/service_model.dart';

void main() {
  group('Router parameter extraction & ServiceModel resilience', () {
    test('ServiceModel.fromJson parses map safely with string or int ids and null fields', () {
      final json = <String, dynamic>{
        '_id': '12345',
        'name': 'AC Repair',
        'category': 'Appliance',
        'price': 40,
        'durationMinutes': 60,
      };

      final service = ServiceModel.fromJson(json);
      expect(service.id, '12345');
      expect(service.name, 'AC Repair');
      expect(service.price, 40.0);
      expect(service.durationMinutes, 60);
      expect(service.isFeatured, false);
      expect(service.rating, 0.0);
    });

    test('ServiceModel.fromJson parses fallback "id" when "_id" is absent', () {
      final json = <String, dynamic>{
        'id': 'fallback_id',
        'name': 'Plumbing',
      };

      final service = ServiceModel.fromJson(json);
      expect(service.id, 'fallback_id');
      expect(service.name, 'Plumbing');
    });

    test('BookingServiceModel converts to ServiceModel structure safely', () {
      const bookingService = BookingServiceModel(
        id: 'book_srv_1',
        name: 'Refrigerator Cleaning',
        category: 'Cleaning',
        price: 55.0,
        durationMinutes: 90,
        rating: 4.8,
      );

      final service = ServiceModel(
        id: bookingService.id,
        name: bookingService.name,
        description: bookingService.description,
        category: bookingService.category,
        price: bookingService.price,
        durationMinutes: bookingService.durationMinutes,
        image: bookingService.image,
        isFeatured: false,
        rating: bookingService.rating,
        reviewCount: 0,
      );

      expect(service.id, 'book_srv_1');
      expect(service.name, 'Refrigerator Cleaning');
      expect(service.price, 55.0);
      expect(service.rating, 4.8);
    });
  });
}
