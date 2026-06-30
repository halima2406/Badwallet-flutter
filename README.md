# BadWallet — Application mobile (Flutter)

Application mobile **« Consumer »** du portefeuille électronique **BadWallet**, à
l'image de Wave / Orange Money / PayPal. L'application consomme la **BadWallet API**
et le **Payment Service** (Spring Boot) exposés sur `http://localhost:8080`, et se
compile en un **APK Android** installable.

> Projet réalisé avec **Flutter · Dart · http · Provider** — architecture *feature-first*.

---

## ✨ Fonctionnalités

- **Onboarding / Auth (simulé)** : splash screen avec logo, connexion par numéro de
  téléphone (identifiant d'interrogation de l'API), mémorisé localement avec
  `flutter_secure_storage`.
- **Tableau de bord (Home)** : solde affiché en grand et **masquable** (icône œil),
  boutons d'actions rapides (Transférer / Payer / Historique), **5 dernières
  transactions**.
- **Transfert d'argent** : saisie du destinataire + **pavé numérique personnalisé**,
  écran de confirmation, reçu de succès.
- **Paiement de factures** : liste des fournisseurs (ISM, Woyafal, Senelec, Rapido…),
  factures impayées du mois, **sélection multiple par checkboxes** et **paiement en
  lot**, reçu détaillé.
- **Historique** : toutes les transactions, **filtres** (Tout / Entrées / Sorties) et
  **code couleur** (vert = entrée, rouge = sortie, gris = échouée).
- Gestion d'état complète **Loading / Loaded / Error** avec écrans de chargement,
  d'erreur (bouton *Réessayer*) et pull-to-refresh.

---

## 🧱 Architecture (feature-first)

```
lib/
├── core/                      # Socle technique partagé
│   ├── constants/             # URL de l'API, catalogue fournisseurs
│   ├── network/               # ApiClient (client HTTP + enveloppe ApiResponse) + exceptions
│   ├── state/                 # ViewStatus (Loading/Loaded/Error)
│   ├── theme/                 # Couleurs + thème Material 3 (Poppins)
│   ├── utils/                 # Formatage monnaie (XOF) et dates (intl)
│   └── widgets/               # Widgets réutilisables (logo, vues d'état, tuile transaction)
├── models/                    # Wallet, Balance, Transaction, Facture, PaymentReceipt
├── features/
│   ├── auth/                  # data (session) · providers · presentation (splash, login)
│   ├── dashboard/             # data (wallet_service) · providers · presentation
│   ├── transfers/             # data · providers · presentation (+ pavé numérique)
│   ├── bills/                 # data · providers · presentation (fournisseurs, détail)
│   ├── history/               # presentation (réutilise WalletProvider)
│   ├── profile/               # presentation (infos session + déconnexion)
│   └── main_shell/            # Navigation principale (bottom navigation)
└── main.dart                  # Point d'entrée + injection des dépendances (MultiProvider)
```

### Principes de conception
- **Responsabilité unique (SRP)** : UI, état (Provider), accès API (Service) et
  données (Model) sont séparés.
- **Inversion de dépendances (DIP)** : les `Provider` **reçoivent** leurs services par
  le constructeur ; les services reçoivent le `ApiClient`. Tout est câblé dans
  `main.dart` via `MultiProvider`.
- **Singleton** : un **unique** `ApiClient` est partagé par tous les services.
- **Ouvert/fermé (OCP)** : ajouter un fournisseur de factures = ajouter une entrée
  dans `kBillProviders` (aucun autre code à modifier).

### Gestion d'état

| État | Description |
|------|-------------|
| `loading` | Requête API en cours (loader affiché) |
| `loaded`  | Données reçues (solde / transactions / factures) |
| `error`   | Échec (message contextuel + bouton *Réessayer*) |

---

## 📦 Packages

| Package | Usage |
|---------|-------|
| `provider` | Gestion d'état et injection des services |
| `http` | Requêtes vers la BadWallet API |
| `intl` | Formatage de la monnaie (`50 000 XOF`) et des dates |
| `google_fonts` | Typographie moderne (Poppins) |
| `flutter_secure_storage` | Sauvegarde locale du numéro de téléphone |
| `flutter_launcher_icons` | Icône d'application personnalisée (build APK) |

---

## 🔌 Endpoints consommés

| Fonction | Méthode & route |
|----------|-----------------|
| Portefeuille | `GET /api/wallets/{phone}` |
| Solde | `GET /api/wallets/{phone}/balance` |
| Transactions | `GET /api/wallets/{phone}/transactions` |
| Transfert | `POST /api/wallets/transfer` |
| Factures impayées | `GET /api/external/factures/{code}/current` |
| Paiement de factures | `POST /api/wallets/pay-factures` |

Toutes les réponses suivent l'enveloppe `{ success, message, data, errors }` ;
`ApiClient` extrait automatiquement le champ `data`.

---

## ⚙️ Configuration du backend

`lib/core/constants/app_constants.dart` calcule l'URL de base selon la cible :

| Cible | URL |
|-------|-----|
| Navigateur web | `http://localhost:8080` |
| Émulateur Android | `http://10.0.2.2:8080` *(mettre `kUseAndroidEmulator = true`)* |
| Téléphone Android physique | `http://<IP_DU_PC>:8080` *(même réseau WiFi)* |

> Adapter `kPcLanIp` à l'adresse IP locale du PC qui héberge le backend.

---

## ▶️ Lancer l'application

```bash
flutter pub get
flutter run            # appareil / émulateur / -d chrome pour le web
```

Numéro de démo pré-rempli : **`+221770000003`** (présent dans le seeder du backend).

---

## 📲 Générer l'APK

```bash
flutter build apk --release
```

L'APK est généré dans :

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 👤 Auteur

- **Nom & Prénom :** Halima Camara
- **Classe :** L3 — S2 (2026)
