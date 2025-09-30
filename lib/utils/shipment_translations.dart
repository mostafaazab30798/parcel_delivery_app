/// Helper functions for translating shipment properties to Arabic

class ShipmentTranslations {
  /// Translates shipment type to Arabic
  /// Normal -> "طرد" (Package)
  /// Document -> "وثيقة" (Document)
  static String translateShipmentType(String? type) {
    if (type == null || type.isEmpty) return 'غير محدد';
    
    switch (type.toLowerCase()) {
      case 'normal':
        return 'طرد';
      case 'document':
        return 'وثيقة';
      default:
        return type; // Return as-is if not recognized
    }
  }
  
  /// Translates shipment nature to Arabic
  /// Normal -> "عادي" (Normal)
  /// Fragile -> "قابل للكسر" (Fragile)
  static String translateShipmentNature(String? nature) {
    if (nature == null || nature.isEmpty) return 'غير محدد';
    
    switch (nature.toLowerCase()) {
      case 'normal':
        return 'عادي';
      case 'fragile':
        return 'قابل للكسر';
      default:
        return nature; // Return as-is if not recognized
    }
  }
  
  /// Translates shipment status to Arabic
  static String translateShipmentStatus(String? status) {
    if (status == null || status.isEmpty) return 'غير محدد';
    
    switch (status.toLowerCase()) {
      case 'pending':
        return 'في الانتظار';
      case 'in_transit':
        return 'جاري الشحن';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      case 'returned':
        return 'مرتجع';
      case 'assigned':
        return 'تم التعيين';
      case 'picked_up':
        return 'تم الاستلام';
      case 'out_for_delivery':
        return 'خرج للتسليم';
      default:
        return 'غير محدد';
    }
  }
}