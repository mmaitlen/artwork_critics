enum PersonaId { buyer, admirer, skeptic }

extension PersonaIdLabel on PersonaId {
  String get label {
    switch (this) {
      case PersonaId.buyer:
        return 'The Buyer';
      case PersonaId.admirer:
        return 'The Admirer';
      case PersonaId.skeptic:
        return 'The Skeptic';
    }
  }

  String get apiValue {
    switch (this) {
      case PersonaId.buyer:
        return 'buyer';
      case PersonaId.admirer:
        return 'admirer';
      case PersonaId.skeptic:
        return 'skeptic';
    }
  }
}
