# Gym Diary iOS

Un'app iOS moderna e intuitiva per gestire i tuoi allenamenti e tenere traccia dei tuoi progressi in palestra.

## 🏋️‍♂️ Funzionalità

### Workout Management
- **Sezioni di allenamento**: Organizza i tuoi workout in sezioni logiche (es. Push/Pull/Legs, Upper Body, Cardio)
- **Workout personalizzati**: Crea e gestisci workout con esercizi multipli
- **Drag & Drop**: Sposta facilmente i workout tra le sezioni
- **Categorie di esercizi**: Supporto per diversi tipi di esercizi (barbell, dumbbell, bodyweight, machine, etc.)

### Tracking degli Esercizi
- **Set e ripetizioni**: Registra serie, ripetizioni e pesi per ogni esercizio
- **Varianti di esercizi**: Supporto per diverse varianti (incline, decline, wide grip, etc.)
- **Storia degli allenamenti**: Tieni traccia di quando hai eseguito l'ultimo workout
- **Note personali**: Aggiungi note per ogni esercizio

### Profilo e Impostazioni
- **Informazioni personali**: Gestisci i tuoi dati personali e foto profilo
- **Impostazioni di allenamento**: Configura tempi di riposo predefiniti
- **Unità di misura**: Scegli tra kg e lbs
- **Tema**: Supporto per tema chiaro e scuro
- **Notifiche**: Configura notifiche per i timer di allenamento

### Design System
- **UI moderna**: Interfaccia pulita e intuitiva con SwiftUI
- **Gradienti e colori**: Design system completo con palette di colori e gradienti
- **Componenti riutilizzabili**: Sistema di componenti modulare e consistente
- **Responsive**: Ottimizzato per diverse dimensioni di schermo iOS

## 🚀 Tecnologie

- **SwiftUI**: Framework UI moderno di Apple
- **Swift 5**: Linguaggio di programmazione nativo
- **iOS 18.5+**: Supporto per le versioni più recenti di iOS
- **Xcode 16**: Sviluppato con l'ultima versione di Xcode
- **Firebase**: Integrazione preparata per autenticazione e database (attualmente commentata)

## 📱 Requisiti

- iOS 18.5 o superiore
- Xcode 16 o superiore
- Swift 5.0+

## 🛠️ Installazione

### Prerequisiti
1. Assicurati di avere Xcode 16 installato
2. Clona il repository

### Setup del Progetto
1. Apri il file `gym-diary-ios.xcodeproj` in Xcode
2. Seleziona il target `gym-diary-ios`
3. Scegli un simulatore iOS o dispositivo fisico
4. Premi ⌘+R per buildare e eseguire l'app

### Clonazione del Repository
```bash
git clone https://github.com/tuo-username/gym-diary-ios.git
cd gym-diary-ios
open gym-diary-ios.xcodeproj
```

## 🏗️ Struttura del Progetto

```
gym-diary-ios/
├── gym-diary-ios/
│   ├── ContentView.swift          # Vista principale con TabView
│   ├── PersonalInfoViews.swift    # Viste per il profilo utente
│   ├── DesignSystem.swift         # Sistema di design e componenti
│   ├── Models.swift              # Modelli dati dell'app
│   ├── FirebaseManager.swift     # Gestione Firebase (attualmente commentata)
│   └── Assets.xcassets/         # Asset grafici
├── gym-diary-ios.xcodeproj/     # Progetto Xcode
├── .gitignore                   # File da ignorare in Git
└── README.md                    # Questo file
```

## 🎯 Utilizzo

### Creare un Nuovo Workout
1. Vai alla tab "Workout"
2. Tocca il pulsante "+" in alto a destra
3. Inserisci il nome del workout
4. Seleziona la sezione di destinazione
5. Tocca "Create"

### Creare una Nuova Sezione
1. Vai alla tab "Workout"
2. Tocca il pulsante cartella con "+" in alto a sinistra
3. Inserisci il nome della sezione
4. Tocca "Create"

### Gestire il Profilo
1. Vai alla tab "Profile"
2. Tocca sulla sezione account per modificare le informazioni personali
3. Configura le impostazioni di allenamento
4. Personalizza le notifiche e il tema

## 🔧 Configurazione Firebase (Opzionale)

Per abilitare Firebase:

1. Aggiungi il tuo `GoogleService-Info.plist` nella cartella del progetto
2. Decommenta le importazioni Firebase in `FirebaseManager.swift`
3. Decommenta la configurazione Firebase in `gym_diary_iosApp.swift`
4. Aggiungi le dipendenze Firebase al progetto

## 🤝 Contribuire

1. Fai un fork del progetto
2. Crea un branch per la tua feature (`git checkout -b feature/AmazingFeature`)
3. Committa le tue modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Pusha al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## 📄 Licenza

Questo progetto è sotto licenza MIT. Vedi il file `LICENSE` per i dettagli.

## 👨‍💻 Autore

**Luca La Rosa**
- GitHub: [@tuo-username](https://github.com/tuo-username)

## 🙏 Ringraziamenti

- Apple per SwiftUI e le tecnologie iOS
- La community Swift per l'ispirazione e il supporto
- Tutti i contributori che hanno aiutato con questo progetto

---

⭐ Se ti piace questo progetto, considera di dargli una stella su GitHub!
