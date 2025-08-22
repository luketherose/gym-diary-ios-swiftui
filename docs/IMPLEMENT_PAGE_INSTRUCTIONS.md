# Implementazione pagina "Add Exercise" (iOS, SwiftUI + Firestore)

## Obiettivo
Realizzare una **modale "Add Exercise"** che consenta di:
1) Cercare un **archetipo** di esercizio (per testo e per gruppo muscolare).
2) Selezionare l'archetipo.
3) Visualizzare dinamicamente un **form di attributi** consentiti per quell'archetipo (senza chip).
4) Applicare **regole di compatibilità** del catalogo per abilitare/negare valori.
5) Mostrare l'**anteprima del nome** dell'esercizio risultante.
6) Salvare come **preset** utente (documento in `/users/{uid}/exercise_presets`).

Il catalogo arriva da `seed/exercise_catalog_seed.json`.

## Stack
- Swift 5.x, **SwiftUI**
- Firebase **Firestore** (SDK iOS) — per ora lasciamo un flag per mock in-memory.
- Nessuna immagine, nessuna chip. UI base con `TextField`, `Picker`, `Toggle`.

## Navigazione
- Presentazione come **sheet**.
- NavBar: `Cancel` (sinistra), `Add Exercise` (destra – attivo solo se la combinazione è valida).
- Corpo con `Form`/`ScrollView`.

## Layout
1. **SearchField** (sempre visibile): "Search archetype or muscle (e.g. bench, chest)".
2. **Results List**: elenco archetipi filtrati → tap per selezionare.
3. **Attributes Form**: render dinamico degli attributi (solo quelli previsti dall'archetipo).
   - enum → `Picker` con valori permessi.
   - boolean → `Toggle`.
   - number (non usato ora) → `TextField` numerico.
   - Valori non validi per le regole: **disabilitati**.
4. **Preview**: stringa nome generata live + motivi invalidità se presenti.
5. **Save preset**: toggle + `TextField` alias (opzionale).

## Dati Firestore (mock)
- Catalogo globale (seed): `/attributes`, `/exercise_archetypes`, `/compatibility_rules` (può restare in locale ora).
- Preset utente: `/users/{uid}/exercise_presets/{docId}`

Schema preset:
{
  "archetype": "bench_press",
  "attributes": { "equipment": "dumbbells", "bench_angle": "incline", "grip_type": "neutral" },
  "alias": "Panca manubri 30°",
  "created_at": 1730000000000
}

## API richieste (ViewModel)
- `ExerciseCatalog` (in-memory dal JSON):
  - `searchArchetypes(query: String) -> [Archetype]`
  - `allowedValues(for attributeKey: String, archetype: Archetype?, current: [String: Any]) -> [String]`
  - `isCombinationValid(archetypeKey: String, attrs: [String: Any]) -> (ok: Bool, reasons: [String])`
  - `buildDisplayName(archetypeKey: String, attrs: [String: Any]) -> String`

- `AddExerciseViewModel` con stato pubblicato:
  - `query`, `filtered`, `selectedArchetype`, `selectedAttrs`, `isValid`, `reasons`, `previewName`, `saveAlias`, `alias`
  - metodi: `onQueryChanged()`, `onPick(key:value)`, `onToggle(key:value)`, `validate()`, `buildName()`, `savePreset(uid:, completion:)`

## Algoritmo regole
- Filtra regole con `scope=global` + `scope=archetype` coerenti con archetype selezionato e `if` soddisfatta.
- `allowedValues`: parte da `attributes[attributeKey].values`, poi INTERSECA con `allow[target]` e SOTTRAE `deny[target]`.
- `isCombinationValid`: attributi scelti ⊆ `allowed_attributes`; applica `require`/`allow`/`deny` alle scelte correnti.

## Vista SwiftUI (sintesi minima)
- Form con:
  - Search
  - Results (se `selectedArchetype == nil`)
  - Sezione "Archetype" selezionato
  - Sezione "Attributes" → Picker/Toggle dinamici da catalogo
  - Sezione "Preview" con nome e motivi invalidità
  - Sezione "Save" (toggle + alias)
- Toolbar: `Cancel` e `Add Exercise` (disabled se invalid)

## Integrazione in `WorkoutDetailView`
- La pagina esiste già con `sheet(isPresented: $showingAddExercise) { AddExerciseView(...) }`.
- Implementare `AddExerciseView` usando il ViewModel sopra.
- Su conferma, creare un `Exercise` dal preset scelto e appenderlo a `workout.exercises`.

## Definition of Done
- Ricerca client-side per archetipi funzionante.
- Form attributi mostra solo quelli previsti e gestisce le regole.
- Nome anteprima aggiornato live.
- Bottone "Add Exercise" attivo solo se combinazione valida.
- Salvataggio preset mock (flag) e struttura pronta per Firestore.
- UI compatibile con Dark Mode e Dynamic Type.
