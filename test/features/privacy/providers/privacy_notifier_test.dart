/// Unit tests for PrivacyNotifier.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/privacy/data/datasources/privacy_local_data_source.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/fake_privacy_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePrivacyRepository fakeRepository;
  late ProviderContainer container;
  late PrivacyNotifier privacyNotifier;
  late SharedPreferences mockPrefs;
  late PrivacyLocalDataSource mockLocalDataSource;

  setUp(() async {
    // Initialize mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();

    fakeRepository = FakePrivacyRepository();
    mockLocalDataSource = PrivacyLocalDataSource(sharedPreferences: mockPrefs);

    // Create container with all necessary overrides
    container = ProviderContainer(
      overrides: [
        privacyRepositoryProvider.overrideWithValue(fakeRepository),
        privacyLocalDataSourceProvider.overrideWithValue(mockLocalDataSource),
      ],
    );

    // Wait for initial build
    await container.read(privacyProvider.future);
    privacyNotifier = container.read(privacyProvider.notifier);
  });

  tearDown(() {
    container.dispose();
    fakeRepository.reset();
  });

  group('initial state', () {
    test('should start with default state', () async {
      // Assert
      final state = container.read(privacyProvider);
      expect(state.value?.hasConsented, isFalse);
      expect(state.value?.region, MarketRegion.international);
    });
  });

  group('saveConsent', () {
    test('should return true and update state on success', () async {
      // Act
      final success = await privacyNotifier.saveConsent(
        hasConsented: true,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
      );

      // Assert
      expect(success, isTrue);
      final state = container.read(privacyProvider);
      expect(state.value?.hasConsented, isTrue);
      expect(fakeRepository.lastSavedConsent, isTrue);
    });

    test('should return false and set error state on failure', () async {
      // Arrange
      fakeRepository.setupFailedOperation(
        const CacheFailure(message: 'Failed to save consent'),
      );

      // Act
      final success = await privacyNotifier.saveConsent(hasConsented: true);

      // Assert
      expect(success, isFalse);
      expect(fakeRepository.methodCalls, contains('saveConsent'));
    });

    test('should call repository with correct parameters', () async {
      // Act
      await privacyNotifier.saveConsent(
        hasConsented: false,
        privacyPolicyVersion: '2.0.0',
        termsOfServiceVersion: '2.0.0',
      );

      // Assert
      expect(fakeRepository.lastSavedConsent, false);
      expect(fakeRepository.methodCalls, contains('saveConsent'));
    });

    test('should set consentedAt timestamp when accepting', () async {
      // Act
      final beforeConsent = DateTime.now();
      await privacyNotifier.saveConsent(
        hasConsented: true,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
      );
      final afterConsent = DateTime.now();

      // Assert
      final state = container.read(privacyProvider);
      expect(state.value?.hasConsented, isTrue);
      expect(state.value?.consentedAt, isNotNull);
      final consentedAt = state.value!.consentedAt!;
      expect(
          consentedAt.isAtSameMomentAs(beforeConsent) ||
              consentedAt.isAtSameMomentAs(afterConsent) ||
              (consentedAt.isAfter(beforeConsent) &&
                  consentedAt.isBefore(afterConsent)),
          isTrue);
    });
  });

  group('updateDataCollection', () {
    test('should enable data collection', () async {
      // Act
      final success = await privacyNotifier.updateDataCollection(true);

      // Assert
      expect(success, isTrue);
      final state = container.read(privacyProvider);
      expect(state.value?.dataCollectionEnabled, isTrue);
      expect(fakeRepository.lastDataCollectionEnabled, isTrue);
    });

    test('should disable data collection', () async {
      // Act
      final success = await privacyNotifier.updateDataCollection(false);

      // Assert
      expect(success, isTrue);
      final state = container.read(privacyProvider);
      expect(state.value?.dataCollectionEnabled, isFalse);
      expect(fakeRepository.lastDataCollectionEnabled, isFalse);
    });

    test('should call repository with correct parameter', () async {
      // Act
      await privacyNotifier.updateDataCollection(true);

      // Assert
      expect(fakeRepository.methodCalls, contains('updateDataCollection'));
    });
  });

  group('updateAnalytics', () {
    test('should enable analytics', () async {
      // Act
      final success = await privacyNotifier.updateAnalytics(true);

      // Assert
      expect(success, isTrue);
      final state = container.read(privacyProvider);
      expect(state.value?.analyticsEnabled, isTrue);
      expect(fakeRepository.lastAnalyticsEnabled, isTrue);
    });

    test('should disable analytics', () async {
      // Act
      final success = await privacyNotifier.updateAnalytics(false);

      // Assert
      expect(success, isTrue);
      final state = container.read(privacyProvider);
      expect(state.value?.analyticsEnabled, isFalse);
      expect(fakeRepository.lastAnalyticsEnabled, isFalse);
    });

    test('should call repository with correct parameter', () async {
      // Act
      await privacyNotifier.updateAnalytics(true);

      // Assert
      expect(fakeRepository.methodCalls, contains('updateAnalytics'));
    });
  });

  group('updateRegion', () {
    test('should update region to China', () async {
      // Act
      final success = await privacyNotifier.updateRegion(MarketRegion.china);

      // Assert
      expect(success, isTrue);
      final state = container.read(privacyProvider);
      expect(state.value?.region, MarketRegion.china);
      expect(fakeRepository.lastRegion, MarketRegion.china);
    });

    test('should update region to International', () async {
      // Act
      final success =
          await privacyNotifier.updateRegion(MarketRegion.international);

      // Assert
      expect(success, isTrue);
      final state = container.read(privacyProvider);
      expect(state.value?.region, MarketRegion.international);
      expect(fakeRepository.lastRegion, MarketRegion.international);
    });

    test('should call repository with correct parameter', () async {
      // Act
      await privacyNotifier.updateRegion(MarketRegion.china);

      // Assert
      expect(fakeRepository.methodCalls, contains('updateRegion'));
    });
  });

  group('deleteAccount', () {
    test('should call repository with password', () async {
      // Act
      final success = await privacyNotifier.deleteAccount('password123');

      // Assert
      expect(success, isTrue);
      expect(fakeRepository.methodCalls, contains('deleteAccount'));
    });

    test('should return false on failure', () async {
      // Arrange
      fakeRepository.setupFailedOperation(
        const AuthFailure(message: 'Wrong password'),
      );

      // Act
      final success = await privacyNotifier.deleteAccount('wrong');

      // Assert
      expect(success, isFalse);
    });
  });

  group('clearPrivacyData', () {
    test('should call repository and return true', () async {
      // Act
      final success = await privacyNotifier.clearPrivacyData();

      // Assert
      expect(success, isTrue);
      expect(fakeRepository.methodCalls, contains('clearPrivacyData'));
    });

    test('should reset state to default', () async {
      // Arrange
      await privacyNotifier.saveConsent(
        hasConsented: true,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
      );

      // Act
      await privacyNotifier.clearPrivacyData();

      // Assert
      final state = container.read(privacyProvider);
      expect(state.value?.hasConsented, isFalse);
    });

    test('should return false on failure', () async {
      // Arrange
      fakeRepository.setupFailedOperation(
        const CacheFailure(message: 'Failed to clear data'),
      );

      // Act
      final success = await privacyNotifier.clearPrivacyData();

      // Assert
      expect(success, isFalse);
    });
  });

  group('loading state', () {
    test('should complete saveConsent and update state', () async {
      // Act
      await privacyNotifier.saveConsent(
        hasConsented: true,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
      );

      // Assert - state should not be loading after completion
      final state = container.read(privacyProvider);
      expect(state.isLoading, isFalse);
      expect(state.hasValue, isTrue);
      expect(state.value?.hasConsented, isTrue);
    });

    test('should complete updateDataCollection and update state', () async {
      // Act
      await privacyNotifier.updateDataCollection(false);

      // Assert
      final state = container.read(privacyProvider);
      expect(state.isLoading, isFalse);
      expect(state.hasValue, isTrue);
      expect(state.value?.dataCollectionEnabled, isFalse);
    });

    test('should complete updateAnalytics and update state', () async {
      // Act
      await privacyNotifier.updateAnalytics(false);

      // Assert
      final state = container.read(privacyProvider);
      expect(state.isLoading, isFalse);
      expect(state.hasValue, isTrue);
      expect(state.value?.analyticsEnabled, isFalse);
    });

    test('should complete updateRegion and update state', () async {
      // Act
      await privacyNotifier.updateRegion(MarketRegion.china);

      // Assert
      final state = container.read(privacyProvider);
      expect(state.isLoading, isFalse);
      expect(state.hasValue, isTrue);
      expect(state.value?.region, MarketRegion.china);
    });
  });

  group('integration tests', () {
    test('should handle complete privacy flow', () async {
      // Arrange - Check initial state
      var state = container.read(privacyProvider);
      expect(state.value?.hasConsented, isFalse);

      // Act - User accepts consent
      await privacyNotifier.saveConsent(
        hasConsented: true,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
      );
      state = container.read(privacyProvider);
      expect(state.value?.hasConsented, isTrue);
      expect(state.value?.consentedAt, isNotNull);

      // Act - User disables data collection
      await privacyNotifier.updateDataCollection(false);
      state = container.read(privacyProvider);
      expect(state.value?.dataCollectionEnabled, isFalse);

      // Act - User changes region
      await privacyNotifier.updateRegion(MarketRegion.china);
      state = container.read(privacyProvider);
      expect(state.value?.region, MarketRegion.china);

      // Act - User clears privacy data
      await privacyNotifier.clearPrivacyData();
      state = container.read(privacyProvider);
      expect(state.value?.hasConsented, isFalse);
      expect(state.value?.consentedAt, isNull);
      expect(state.value?.region, MarketRegion.international);
    });
  });
}
