// les etats d'une requete : rien, en cours, fini, erreur
enum ViewStatus { idle, loading, loaded, error }

extension ViewStatusX on ViewStatus {
  bool get isLoading => this == ViewStatus.loading;
  bool get isLoaded => this == ViewStatus.loaded;
  bool get isError => this == ViewStatus.error;
}
