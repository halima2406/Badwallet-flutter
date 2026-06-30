enum ViewStatus { idle, loading, loaded, error }

extension ViewStatusX on ViewStatus {
  bool get isLoading => this == ViewStatus.loading;
  bool get isLoaded => this == ViewStatus.loaded;
  bool get isError => this == ViewStatus.error;
}
