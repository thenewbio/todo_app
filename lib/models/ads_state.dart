// import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState{
  Future<InitializationStatus> initialize;

  AdState(this.initialize);

  String get bannerAd => "ca-app-pub-2576798913742126~2861440515";


  AdListener get adListener => _adListener;

  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) => print('Ad failed to load: ${ad.adUnitId}., $error'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAppEvent: (ad, name, data) => print('Ad opened: ${ad.adUnitId}, $name, $data'),
    onApplicationExit: (ad) => print('App Exit: ${ad.adUnitId}.'),
    onNativeAdClicked: (nativeAd) => print('Native ad clicked: ${nativeAd.adUnitId}.'),
    onNativeAdImpression: (nativeAd) => print('Native ad impression: ${nativeAd.adUnitId}.'),
    onRewardedAdUserEarnedReward: (ad , reward) => print(
      'User rewarded: ${ad.adUnitId}, ${reward.amount} ${reward.type}'),
  );
  
}