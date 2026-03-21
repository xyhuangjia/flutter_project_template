/// Unit tests for PrivacyLocalDataSource.
library;

import 'package:flutter_project_template/features/privacy/data/datasources/privacy_local_data_source.dart';
import 'package:flutter_project_template/features/privacy/data/models/privacy_consent_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PrivacyLocalDataSource dataSource;
  late SharedPreferences mockPrefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();
    dataSource = PrivacyLocalDataSource(sharedPreferences: mockPrefs);
  });

  group('getPrivacyConsent', () {
    test('should return null when no consent is stored', () {
      // Act
      final consent = dataSource.getPrivacyConsent();

      // Assert
      expect(consent, isNull);
    });

    test('should return stored consent', () async {
      // Arrange
      const expectedConsent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: null,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: true,
        analyticsEnabled: true,
      );
      await dataSource.savePrivacyConsent(expectedConsent);

      // Act
      final consent = dataSource.getPrivacyConsent();

      // Assert
      expect(consent, isNotNull);
      expect(consent!.hasConsented, expectedConsent.hasConsented);
      expect(
          consent.privacyPolicyVersion, expectedConsent.privacyPolicyVersion);
      expect(
          consent.termsOfServiceVersion, expectedConsent.termsOfServiceVersion);
      expect(consent.region, expectedConsent.region);
      expect(
          consent.dataCollectionEnabled, expectedConsent.dataCollectionEnabled);
      expect(consent.analyticsEnabled, expectedConsent.analyticsEnabled);
    });

    test('should return consent with consentedAt timestamp', () async {
      // Arrange
      final consentedAt = DateTime.now();
      final expectedConsent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: consentedAt,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: true,
        analyticsEnabled: true,
      );
      await dataSource.savePrivacyConsent(expectedConsent);

      // Act
      final consent = dataSource.getPrivacyConsent();

      // Assert
      expect(consent, isNotNull);
      expect(consent!.hasConsented, isTrue);
      expect(consent.consentedAt, isNotNull);
      expect(consent.consentedAt!.toIso8601String(),
          consentedAt.toIso8601String());
    });

    test('should return null when stored data is corrupted', () async {
      // Arrange - save invalid JSON
      await mockPrefs.setString('privacy_consent', 'invalid json');

      // Act
      final consent = dataSource.getPrivacyConsent();

      // Assert
      expect(consent, isNull);
    });
  });

  group('savePrivacyConsent', () {
    test('should save consent to SharedPreferences', () async {
      // Arrange
      const consent = PrivacyConsentDto(
        hasConsented: false,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: false,
        analyticsEnabled: false,
      );

      // Act
      await dataSource.savePrivacyConsent(consent);

      // Assert
      expect(mockPrefs.getString('privacy_consent'), isNotNull);
    });

    test('should overwrite existing consent', () async {
      // Arrange
      const firstConsent = PrivacyConsentDto(
        hasConsented: false,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: false,
        analyticsEnabled: false,
      );
      await dataSource.savePrivacyConsent(firstConsent);

      const secondConsent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: null,
        privacyPolicyVersion: '1.0.1',
        termsOfServiceVersion: '1.0.1',
        region: 'china',
        dataCollectionEnabled: true,
        analyticsEnabled: true,
      );

      // Act
      await dataSource.savePrivacyConsent(secondConsent);

      // Assert
      final savedConsent = dataSource.getPrivacyConsent();
      expect(savedConsent!.hasConsented, isTrue);
      expect(savedConsent.privacyPolicyVersion, '1.0.1');
      expect(savedConsent.region, 'china');
    });

    test('should save consent with different settings', () async {
      // Arrange
      const consent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: null,
        privacyPolicyVersion: '2.0.0',
        termsOfServiceVersion: '2.0.0',
        region: 'china',
        dataCollectionEnabled: false,
        analyticsEnabled: false,
      );

      // Act
      await dataSource.savePrivacyConsent(consent);

      // Assert
      final savedConsent = dataSource.getPrivacyConsent();
      expect(savedConsent, isNotNull);
      expect(savedConsent!.hasConsented, isTrue);
      expect(savedConsent.privacyPolicyVersion, '2.0.0');
      expect(savedConsent.region, 'china');
      expect(savedConsent.dataCollectionEnabled, isFalse);
      expect(savedConsent.analyticsEnabled, isFalse);
    });
  });

  group('clearPrivacyConsent', () {
    test('should clear stored consent', () async {
      // Arrange
      const consent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: null,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: true,
        analyticsEnabled: true,
      );
      await dataSource.savePrivacyConsent(consent);

      // Act
      await dataSource.clearPrivacyConsent();

      // Assert
      final savedConsent = dataSource.getPrivacyConsent();
      expect(savedConsent, isNull);
    });

    test('should work when no consent is stored', () async {
      // Act & Assert - should not throw
      await dataSource.clearPrivacyConsent();
    });
  });

  group('integration tests', () {
    test('should handle complete consent flow', () async {
      // Arrange & Act - Initial state
      var consent = dataSource.getPrivacyConsent();
      expect(consent, isNull);

      // Act - User accepts
      final acceptedConsent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: null,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: true,
        analyticsEnabled: true,
      );
      await dataSource.savePrivacyConsent(acceptedConsent);
      consent = dataSource.getPrivacyConsent();
      expect(consent!.hasConsented, isTrue);

      // Act - User updates settings
      final updatedConsent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: consent.consentedAt,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: false,
        analyticsEnabled: false,
      );
      await dataSource.savePrivacyConsent(updatedConsent);
      consent = dataSource.getPrivacyConsent();
      expect(consent!.dataCollectionEnabled, isFalse);
      expect(consent.analyticsEnabled, isFalse);

      // Act - Clear consent
      await dataSource.clearPrivacyConsent();
      consent = dataSource.getPrivacyConsent();
      expect(consent, isNull);
    });

    test('should persist consent across data source instances', () async {
      // Arrange - Save consent with first instance
      const consent = PrivacyConsentDto(
        hasConsented: true,
        consentedAt: null,
        privacyPolicyVersion: '1.0.0',
        termsOfServiceVersion: '1.0.0',
        region: 'international',
        dataCollectionEnabled: true,
        analyticsEnabled: true,
      );
      await dataSource.savePrivacyConsent(consent);

      // Act - Create new instance and retrieve consent
      final newDataSource =
          PrivacyLocalDataSource(sharedPreferences: mockPrefs);
      final retrievedConsent = newDataSource.getPrivacyConsent();

      // Assert
      expect(retrievedConsent, isNotNull);
      expect(retrievedConsent!.hasConsented, isTrue);
      expect(retrievedConsent.privacyPolicyVersion, '1.0.0');
    });
  });
}
