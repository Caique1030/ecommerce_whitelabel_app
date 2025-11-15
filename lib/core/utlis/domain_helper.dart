class DomainHelper {
  static String getCurrentDomain() {
    // Em produção, você pegaria o domínio real
    // Por enquanto, retorna localhost para desenvolvimento
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
