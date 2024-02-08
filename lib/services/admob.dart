import 'package:flutter/material.dart' show Widget, debugPrint, SizedBox;
import 'package:google_mobile_ads/google_mobile_ads.dart'
    show BannerAd, AdRequest, AdSize, BannerAdListener, AdWidget;

//TODO: Convert to provider

class AdMob {
  static BannerAd? initializeAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  static Widget getAdWidget(BannerAd ad) {
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
