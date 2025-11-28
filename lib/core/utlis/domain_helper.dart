class DomainHelper {
  static String getCurrentDomain() {

    return 'localhost:3000';
  }

  static String getClientKeyFromDomain(String domain) {
    if (domain.contains('devnology')) {
      return 'devnology';
    } else if (domain.contains('in8')) {
      return 'in8';
    } else {
      return 'localhost';
    }
  }
}
