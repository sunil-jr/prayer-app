import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ── RevenueCat setup checklist ────────────────────────────────────────────────
// 1. Create a project at https://app.revenuecat.com
// 2. Add iOS app (key starts with appl_) and Android app (key starts with goog_)
// 3. Create an Entitlement named "pro"
// 4. Create products in App Store Connect / Google Play Console:
//      sg_monthly   — Monthly subscription
//      sg_annual    — Yearly subscription
//      sg_lifetime  — Non-consumable one-time purchase
// 5. Add those products to an Offering named "default" in the RC dashboard
// 6. Replace the placeholder keys below with your real keys
// ─────────────────────────────────────────────────────────────────────────────

class PurchaseService {
  PurchaseService._();

  static const String entitlementId = 'pro';

  static const String _iosApiKey = 'test_oARMylNVELesYIgWblPCaofvfcb';
  static const String _androidApiKey = 'test_oARMylNVELesYIgWblPCaofvfcb';

  static Future<void> init() async {
    try {
      final key = defaultTargetPlatform == TargetPlatform.iOS
          ? _iosApiKey
          : _androidApiKey;
      await Purchases.configure(PurchasesConfiguration(key));
    } catch (_) {
      // Init failure is non-fatal; purchase calls will fail gracefully.
    }
  }

  static Future<bool> isEntitled() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }

  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (_) {
      return null;
    }
  }

  /// Returns true if the purchase succeeds and the entitlement is active.
  /// Returns false if the user cancels. Throws on other store errors.
  static Future<bool> purchase(Package package) async {
    try {
      final info = await Purchases.purchasePackage(package);
      return info.entitlements.active.containsKey(entitlementId);
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) ==
          PurchasesErrorCode.purchaseCancelledError) {
        return false;
      }
      rethrow;
    }
  }

  static Future<bool> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }
}
