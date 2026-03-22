/// Region provider for managing market region settings.
library;

import 'package:flutter_project_template/features/privacy/data/models/region_config.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'region_provider.g.dart';

/// Region config provider.
@riverpod
RegionConfig regionConfig(Ref ref) {
  final privacyState = ref.watch(privacyProvider);

  return privacyState.when(
    data: (state) => RegionConfig.forRegion(state.region),
    loading: () => RegionConfig.international,
    error: (_, __) => RegionConfig.international,
  );
}

/// Region notifier provider for managing region selection.
@riverpod
class RegionNotifier extends _$RegionNotifier {
  @override
  Future<MarketRegion> build() async {
    final privacyState = ref.watch(privacyProvider);

    return privacyState.when(
      data: (state) => state.region,
      loading: () => MarketRegion.international,
      error: (_, __) => MarketRegion.international,
    );
  }

  /// Sets the market region.
  Future<bool> setRegion(MarketRegion region) async {
    final success =
        await ref.read(privacyProvider.notifier).updateRegion(region);

    if (success) {
      state = AsyncValue.data(region);
    }

    return success;
  }

  /// Detects region from device locale.
  Future<void> detectFromLocale(String languageCode) async {
    final detectedRegion = RegionConfig.detectRegionFromLocale(languageCode);
    await setRegion(detectedRegion);
  }
}
