import 'package:flutter_test/flutter_test.dart';
import 'package:cortex/domain/usecases/sm2_algorithm.dart';

void main() {
  const sm2 = Sm2Algorithm();

  group('SM-2 Algorithm', () {
    test('successful recall with quality 5 increases interval', () {
      final result = sm2.calculate(
        quality: 5,
        easeFactor: 2.5,
        interval: 1,
        repetitions: 0,
      );

      expect(result.interval, 1);
      expect(result.repetitions, 1);
      expect(result.easeFactor, greaterThan(2.5));
    });

    test('second successful recall sets interval to 6', () {
      final result = sm2.calculate(
        quality: 4,
        easeFactor: 2.5,
        interval: 1,
        repetitions: 1,
      );

      expect(result.interval, 6);
      expect(result.repetitions, 2);
    });

    test('third successful recall multiplies interval by ease factor', () {
      final result = sm2.calculate(
        quality: 4,
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
      );

      expect(result.interval, 15); // round(6 * 2.5) = 15
      expect(result.repetitions, 3);
    });

    test('failed recall resets interval and repetitions', () {
      final result = sm2.calculate(
        quality: 2,
        easeFactor: 2.5,
        interval: 15,
        repetitions: 5,
      );

      expect(result.interval, 1);
      expect(result.repetitions, 0);
    });

    test('ease factor never drops below 1.3', () {
      final result = sm2.calculate(
        quality: 0,
        easeFactor: 1.3,
        interval: 1,
        repetitions: 0,
      );

      expect(result.easeFactor, 1.3);
    });

    test('overconfidence rate reduces interval', () {
      final withoutCalibration = sm2.calculate(
        quality: 4,
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
      );

      final withCalibration = sm2.calculate(
        quality: 4,
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
        overconfidenceRate: 0.5,
      );

      expect(withCalibration.interval, lessThan(withoutCalibration.interval));
    });
  });
}
