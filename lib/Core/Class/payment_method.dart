/// Enum representing supported payment methods.
/// Replaces brittle string comparisons with type-safe values.
enum PaymentMethod {
  cash,
  instapay,
  card,
  vodafoneCash;

  /// Converts the enum to the API-expected string value.
  String get apiValue {
    switch (this) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.instapay:
        return 'instapay';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.vodafoneCash:
        return 'vfCash';
    }
  }

  /// Human-readable display label.
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash on Delivery';
      case PaymentMethod.instapay:
        return 'InstaPay';
      case PaymentMethod.card:
        return 'Credit / Debit Card';
      case PaymentMethod.vodafoneCash:
        return 'Vodafone Cash';
    }
  }

  /// Parses a display string back to enum (for backward compat from args).
  static PaymentMethod? fromDisplayName(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final lower = raw.toLowerCase().trim();
    if (lower == 'cash' || lower == 'cash on delivery') {
      return PaymentMethod.cash;
    } else if (lower == 'instapay') {
      return PaymentMethod.instapay;
    } else if (lower.contains('credit') || lower.contains('card')) {
      return PaymentMethod.card;
    } else if (lower.contains('vodafone') || lower.contains('vf')) {
      return PaymentMethod.vodafoneCash;
    }
    return null;
  }
}
