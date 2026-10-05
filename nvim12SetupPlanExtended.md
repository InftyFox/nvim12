# Neovim-0.12-Setup-Plan – Fortsetzung ab Phase 7

## Geltungsbereich und Übergang

Dieser Plan setzt `nvim12SetupPlan.md` **nach Abschluss von Phase 6e** fort.
Die Phasen 1 bis 6e und ihre bereits getroffenen Entscheidungen bleiben dort
dokumentiert. Ab Phase 7 ist **dieser** Plan maßgeblich; die dortigen Phasen 7
bis 11 werden nicht zusätzlich ausgeführt. Die Nummerierung der noch offenen
Phasen wird hier neu festgelegt.

Phase 6b (TypeScript, JavaScript, CSS und Vue) aus dem ursprünglichen Plan wird
als **optionale Phase 15a** fortgeführt. Sie wird mangels repräsentativem
Projekt nicht zum Gate für den Wechsel auf Neovim 0.12. Phase 6c (C#) bleibt
abgeschlossen; Phase 6d (GDScript) entfällt weiterhin. `render-markdown` wird
bereits in der laufenden Phase 6e behandelt und hier nicht nochmals geplant.

Nach dem Stopkriterium von Phase 6e ist der nächste Arbeitsschritt **Phase 7
dieses Plans**. Danach wird jeweils nur eine Phase gleichzeitig bearbeitet.
Jede Phase endet in einem nutzbaren Zustand. Die bisherige Arbeitsweise gilt
weiter: `nvim11` bleibt als Rollback unverändert, Funktionen werden nach
konkretem Bedarf und möglichst zuerst mit Neovim 0.12 geprüft, und neue
externe Voraussetzungen werden beim Einführen in der englischen `README.md`
dokumentiert. Es gibt keine vollständige Migration oder A/B/C-Bewertung der
alten Pluginliste.

## Phase 7 – Syntax, Auswahl und Textbearbeitung

### Ziel

Highlighting, strukturierte Auswahl und häufige Bearbeitungsaktionen mit den
Möglichkeiten von Neovim 0.12 abdecken. Zusätzliche Parser oder Plugins
werden nur für eine im Alltag festgestellte Lücke ergänzt.

### Schritte

- [x] In eingerichteten Sprachen und Markdown Highlighting, Einrückung und
      Parserherkunft prüfen; für noch nicht eingerichtete Sprachen nichts
      vorsorglich installieren. Erkenntnisse aus Phase 6e berücksichtigen.
- [x] Native Textobjekte von Neovim 0.12 in Operator-pending und Visual Mode
      praktisch testen, unter anderem Wörter, Zeilen, Klammern und Blöcke.
- [x] Gewünschte strukturelle Auswahlen für Funktionen, Bedingungen, Schleifen
      und Zuweisungen anhand realer Dateien mit den nativen Möglichkeiten
      vergleichen. Textobjekte, Bewegungen und inkrementelle Auswahl getrennt
      betrachten.
- [x] Native inkrementelle Auswahl von Neovim 0.12 gegen die bisherige
      Treesitter-Auswahl (`gnn`, `grn`, `grc`, `grm`) prüfen; das Verhalten nicht
      aus der Neovim-0.11-Konfiguration ableiten.
- [x] Vor neuen Mappings die nativen und bisherigen Belegungen prüfen,
      insbesondere `al`/`il`, `an`/`in` sowie die Auswahl- und
      Navigations-Mappings. Native Belegungen nur bewusst überschreiben.
- [x] Nur bei konkreten Lücken zusätzliche Parser, `nvim-treesitter`,
      `mini.ai` oder Treesitter-Textobjects einzeln prüfen. Highlighting,
      Einrückung, Textobjekte und inkrementelle Auswahl separat entscheiden.
- [x] Kontext am oberen Fensterrand und Scope-/Einzugsanzeige getrennt auf
      ihren Nutzen prüfen; die Anzeige nicht mit Textobjekt-Mappings koppeln.
- [x] Automatisches Klammer-/Anführungszeichen-Pairing und Surround-Aktionen
      jeweils gegen das vorhandene Bearbeitungsverhalten abwägen.
- [x] Bei der gewählten Syntaxlösung die Bedienbarkeit größerer Dateien
      prüfen; gegebenenfalls nur für problematische Fälle abschalten.
- [x] Zusätzliche Parser, Build-Werkzeuge und Updateabläufe bei Bedarf in der
      README dokumentieren.

Referenzen für die native Prüfung:
`https://neovim.io/doc/user/vimindex/#_2.1-text-objects` und der vom Nutzer
genannte Prüfanlass zur inkrementellen Auswahl:
`https://www.reddit.com/r/neovim/comments/1s9q0pi/incremental_selection_in_neovim_012/`.
Maßgeblich ist die lokale Hilfe der installierten Neovim-Version: In 0.12.5
sind `an`/`in` native inkrementelle Auswahl-Mappings, aber `al`/`il` noch keine
nativen Textobjekte. Die aktuelle Online-Hilfe beschreibt bereits die für
Neovim 0.13 eingeführten Textobjekte `al` (gesamter Buffer) und `il` (Zeileninhalt
ohne umgebenden Whitespace). Die bisherige `mini.ai`-Belegung darf deshalb nicht
ohne Versionsabgleich übernommen werden.

Festgelegte Belegung für Phase 7: `mini.ai` behält `an`/`in` für Next-Object und
`al`/`il` für Last-Object. Die native inkrementelle Auswahl bleibt im Visual Mode
über `<leader>ls` (erweitern) und `<leader>lS` (verkleinern) erreichbar. Die
Praxistests wurden vom Nutzer erfolgreich bestätigt. Für die konkret
festgestellte Lücke bei Funktionsdefinitionen nutzt
`mini.ai` die mitgelieferten Queries von `nvim-treesitter-textobjects` (Branch
`main`): `aF` wählt die Definition inklusive Funktionskopf, `iF` den Funktionsinhalt.
Die bisherigen lokalen Lua-/C#-Queries entfallen. Für weitere Sprachen mit
passenden Function-Captures genügt der jeweilige Parser; die Mappings bleiben
sprachübergreifend gleich. `<leader>ca` ruft native LSP-Code-Actions auf. Enter
bricht Completion ab und nutzt `mini.pairs` zum Aufteilen leerer Klammerpaare.
Auch die ergänzten Mappings wurden vom Nutzer praktisch bestätigt.

### Verifikation

- [x] Typische Auswahl- und Änderungsaufgaben in Lua und C# funktionieren;
      Markdown aus Phase 6e bleibt gut bearbeitbar.
- [x] Die inkrementelle Auswahl lässt sich erweitern und zurücknehmen, ohne
      unbeabsichtigte Konflikte mit nativen Mappings.
- [x] Die gewählte Darstellung und Einrückung funktionieren mit den
      tatsächlich verwendeten Parsern wie erwartet.
- [x] Eine größere Datei lässt sich ohne störende Verzögerung bearbeiten.
- [x] `:checkhealth vim.treesitter`, `:Inspect`, `:InspectTree` und bei
      Mappingzweifeln `:verbose xmap al`, `:verbose xmap il` sowie die
      entsprechenden Operator-pending-Mappings liefern nachvollziehbare
      Ergebnisse.

### Stopkriterium

Für jeden gewünschten Auswahl- und Editing-Workflow ist klar, was nativ
funktioniert und welchen zusätzlichen Nutzen eine gewählte Erweiterung bringt.
Syntax und Auswahl sind alltagstauglich, ohne die noch offenen optionalen
Sprachprofile vorauszusetzen.

### Abschluss – 2026-10-04

**Phase 7 ist abgeschlossen; das Stopkriterium ist erfüllt.**

- Der Nutzer hat die manuellen Praxistests einschließlich der nachträglich
  ergänzten Mappings erfolgreich bestätigt.
- Die finalen StyLua-Checks für `init.lua` und die sieben betroffenen
  Konfigurations-/Pluginmodule sowie `git diff --check` wurden erfolgreich
  ausgeführt. Pluginregistrierung und Lockfile sind stimmig; auch
  `nvim-treesitter-textobjects` ist mit Revision und Branch festgehalten.
- Funktionsdefinitionen nutzen zentrale Plugin-Queries statt eigener
  sprachspezifischer Query-Dateien. Weitere strukturelle Textobjekte werden
  mangels festgestellter Lücke nicht zusätzlich gemappt.
- Die vorhandene Filetype-Einrückung bleibt bestehen; experimentelle
  Treesitter-Einrückung und zusätzliche Scope-/Einzugsguides werden nicht
  aktiviert. Die Kontextanzeige ist auf drei Zeilen begrenzt.
- Voraussetzungen, Parserinstallation, Bedienung und Updateabläufe sind in
  der README dokumentiert. Es sind keine weiteren Phase-7-Lücken bekannt.

Nächster Arbeitsschritt ist **Phase 8 – Coding-Ergänzungen**.

## Phase 8 – Coding-Ergänzungen

### Ziel

Die native Completion bei konkretem Bedarf durch `blink.cmp` ergänzen und nur
die darüber hinaus benötigten Coding-Funktionen einrichten. Der eigene
Snippet-Manager SnipSnap folgt in Phase 13b.

### Schritte

- [x] `blink.cmp` wegen der im Alltag unzureichenden nativen Completion mit
      `vim.pack` einführen; zunächst LSP-, Pfad- und Buffer-Vorschläge
      einrichten.
- [x] Die bisherige native Completion-Aktivierung und ihre Mappings
      (`<C-Space>`, `<Tab>`, `<CR>`) auf Konflikte prüfen und den gewünschten
      Bedienablauf mit `blink.cmp` festlegen.
- [x] Completion in Lua, C#, JSON/YAML und Markdown prüfen, insbesondere
      Checkbox- und Callout-Vorschläge von `render-markdown.nvim`.
      Snippet-Quellen erst bei konkretem Bedarf ergänzen; die Verwaltung
      persönlicher Snippets bleibt Phase 13b.
- [x] Benötigte Refactorings wie Extrahieren und Inline-Änderungen anhand
      realer Beispiele festlegen und zuerst LSP-Code-Actions prüfen.
- [x] Nur für fehlende oder unzureichende Refactorings eine zusätzliche
      Lösung bewerten; gegebenenfalls benötigte Parser aus Phase 7 nutzen.
- [x] Prüfen, ob zusätzliche Lua-Typ- und Completion-Hilfe für die Arbeit an
      Neovim-Plugins gegenüber dem eingerichteten `lua_ls` einen spürbaren
      Vorteil bietet; `lazydev` ist ein Kandidat, keine Vorentscheidung.
- [x] Gewählte Zusatzabhängigkeiten und externe Voraussetzungen in der README
      ergänzen.

### Verifikation

- [x] Automatische und manuell ausgelöste Vorschläge sowie Bestätigen,
      Abbrechen und der Tab-Workflow funktionieren in den eingerichteten
      Sprachen und Markdown ohne doppelte Completion-Menüs.
- [x] Ein repräsentatives Refactoring liefert das erwartete Ergebnis oder
      eine dokumentierte Entscheidung für den bestehenden LSP-Workflow.
- [x] Lua-Completion in der eigenen Config bleibt verständlich und
      funktionsfähig.

### Stopkriterium

Completion, die tatsächlich benötigten Refactorings und Lua-Hilfen sind
abgedeckt; diese Phase setzt weder SnipSnap noch die optionalen Sprachprofile
voraus.

### Abschluss – 2026-10-05

**Phase 8 ist abgeschlossen; das Stopkriterium ist erfüllt.**

Der Nutzer hat Blink einschließlich der Signaturhilfe nach dem Bestätigen einer
Completion und die gewünschten Refactorings erfolgreich geprüft. LazyDev ist
installiert; die zuvor fehlende Plugin-API-Completion funktioniert nun ebenfalls.

- `blink.cmp` ist mit dem stabilen Release `v1.10.2` registriert und vom Nutzer
  über `vim.pack` installiert. Das erzeugte Lockfile enthält den passenden Tag
  und die Release-Revision `78336bc89ee5365633bcf754d93df01678b5c08f`.
- Blink übernimmt automatische Completion aus LSP und Pfaden; Wörter aus
  sichtbaren normalen Buffern dienen als Fallback. Native LSP-Autocompletion
  und deren bisherige Mappings wurden abgelöst.
- Der erste Treffer ist vorausgewählt, wird aber erst beim Bestätigen eingefügt.
  Enter bestätigt den Vorschlag und erzeugt ohne ausgewählten Vorschlag einen
  Zeilenumbruch. Shift-Enter bricht Completion ab und erzeugt immer den bisherigen
  `mini.pairs`-Zeilenumbruch. Tab/Shift-Tab dienen Snippet-Sprüngen; `<C-n>`/`<C-p>`
  und Pfeiltasten navigieren im Menü. `<C-Space>` öffnet Completion beziehungsweise
  schaltet die Dokumentation um; `<C-e>` schließt das Menü.
- Dokumentation erscheint ohne zusätzliche Anzeigeverzögerung und wird mit
  `<C-d>`/`<C-u>` gescrollt; Aktualisierungen behalten Blinks gültigen Standard
  von 50 ms. Automatische kompakte Signaturhilfe wird auch nach dem Bestätigen
  einer Completion angefordert (`signature.trigger.show_on_accept = true`).
  Blinks standardmäßige Funktionsklammern sind aktiviert; Ghost Text ist deaktiviert.
  LSP-Snippets verwenden weiterhin `vim.snippet`, ohne zusätzliche Snippet-Quelle.
- Installation, Bedienung und Praxistests sind in der englischen README erklärt.
  Der Nutzer hat die Tests einschließlich Shift-Enter, Funktionsklammern,
  Snippet-Sprüngen, Dokumentationsscrollen und Markdown-Vorschlägen bestätigt.
- StyLua und Lua-Syntaxprüfungen für die fünf geänderten/neuen Lua-Dateien sowie
  `git diff --check` sind erfolgreich. Ein isolierter Test mit dem vorhandenen
  `mini.pairs` bestätigt Paaraufteilung und normale Zeilenumbrüche über Enter
  und Shift-Enter. Nach einem ungültigen `update_delay_ms = 0` hat der Nutzer
  beide Delay-Overrides entfernt und den erfolgreichen Start bestätigt. Nur
  das zulässige `auto_show_delay_ms = 0` wurde für sofortige Anzeige wieder ergänzt.
- Der Nutzer hat Funktion/Methode extrahieren, Variable extrahieren und Symbol
  umbenennen in Lua/C# erfolgreich geprüft. Der bestehende LSP-Workflow genügt;
  ein zusätzliches Refactoring-Plugin wird nicht benötigt. `<leader>ca` ruft
  Code-Actions auf; natives `grn` verwendet LSP-Rename.
- Neovim-API-Completion funktioniert; die zunächst fehlende Plugin-API-Completion
  nach `local cmp = require("blink.cmp")` wurde durch LazyDevs dynamische
  Bibliotheksverwaltung behoben und vom Nutzer bestätigt.
- LazyDev ist über `vim.pack` registriert und wird vor Blink und der
  LSP-Aktivierung eingerichtet. Es ist gezielt für dieses Config-Workspace
  einschließlich gebündelter eigener Plugins aktiviert; separate Neovim-Plugin-
  Repositories werden bei Bedarf ausdrücklich aufgenommen. Die bisherigen
  statischen LuaJIT-/Runtime-Overrides entfallen zugunsten von LazyDev.
- Die Blink-Quelle `lazydev.integrations.blink` wird nur für Lua ergänzt und
  liefert Modulnamen für `require(...)`/Modulannotationen. API-Member und
  Dokumentation liefert weiterhin `lua_ls`. Installation, Bibliotheksprüfung,
  Wiederholung des `cmp.`-Tests und Ausschluss gewöhnlicher Lua-Projekte sind
  in der README beschrieben. Das geprüfte Lockfile enthält LazyDev mit Repository
  und Revision `ff2cbcba459b637ec3fd165a2be59b7bbaeedf0d`.
- Die fünf betroffenen Lua-Dateien bestehen StyLua- und Syntaxprüfungen;
  `git diff --check` und die Konfigurationsvalidierung mit dem installierten
  Blink bestehen ebenfalls. Die Aktivierungsregel ist isoliert geprüft:
  Config-Root erlaubt, fremde Roots und Single-File-Workspaces ausgeschlossen.
  Die Installation und funktionierende Plugin-API-Completion sind durch den
  Nutzer bestätigt. Es sind keine weiteren Phase-8-Lücken bekannt.

Nächster Arbeitsschritt ist **Phase 9 – Ergänzende Navigation**.

## Phase 9 – Ergänzende Navigation

### Ziel

TODO-Kommentare und schnelle Sprünge innerhalb sichtbaren Texts bewerten,
ohne Picker und Dateibaum aus Phase 4 erneut aufzubauen.

### Schritte

- [ ] TODO/FIX/NOTE-Hervorhebung, projektweite Suche und Navigation an
      echten Kommentaren gegen die vorhandene Projektsuche vergleichen.
- [ ] Schnelles Springen zu sichtbarem Text mit `/`, `f`, `t` und bestehenden
      Bewegungen vergleichen; Flash erst nach dem Praxistest beurteilen.
- [ ] Nur tatsächlich nützliche Abläufe mit eindeutigen Mappings ergänzen.

### Verifikation

- [ ] Relevante Kommentare lassen sich im Projekt finden und unterscheiden.
- [ ] Der gewählte Sprungworkflow funktioniert in einer realen Datei und
      kollidiert nicht mit Such- oder Auswahl-Mappings.

### Stopkriterium

Der Mehrwert jeder ergänzten Navigationsfunktion gegenüber den vorhandenen
Mitteln ist klar; ansonsten bleibt die bestehende Navigation bestehen.

## Phase 10 – UI vervollständigen

### Ziel

Eine ruhige Oberfläche mit Rose Pine, hilfreicher Statusline, gut lesbaren
Diagnostics und verständlichen Meldungen schaffen.

### Schritte

- [ ] Rose Pine als Grundlage beibehalten und native Statusline gegen eine
      spezialisierte Lösung abwägen; nur tatsächlich hilfreiche Informationen
      anzeigen.
- [ ] Icons zentral und ohne doppelte Abhängigkeiten bereitstellen.
- [ ] Picker, Explorer, Completion und Diagnostics auf Lesbarkeit prüfen.
- [ ] Kontextabhängige Keymap-Hilfe (`which-key` als Kandidat) gegen native
      Hilfe und die vorhandene Keymap-Suche vergleichen.
- [ ] Ausführliche Inline-Diagnostics mit der derzeit schlichten nativen
      Darstellung vergleichen, insbesondere bei mehrzeiligen Meldungen.
- [ ] Native Kommandozeile, Meldungen und Notifications praktisch prüfen;
      schwebende Ansichten und lange Meldungen in einem Split nur bei Bedarf
      ergänzen. Einen durchsuchbaren Meldungsverlauf separat prüfen.
- [ ] Weiches Scrollen gegen normales Scrollen testen.
- [ ] Mehrfachanzeigen derselben Meldung vermeiden und UI-Komponenten
      unabhängig von optionalen Sprachprofilen und OpenFlowCode halten.

Bufferline, Dashboard, Bilddarstellung und eigene Befehls-/Undo-Verlaufs-Picker
gehören nicht zum Zielzustand.

### Verifikation

- [ ] Start ohne Datei und mit normaler Datei sowie Darstellung mit und ohne
      aktiven LSP funktionieren.
- [ ] Statusline, Meldungen und Diagnostics sind gut lesbar; der gewünschte
      Meldungsverlauf lässt sich nach einem Neustart gemäß gewähltem Umfang
      nachvollziehen.
- [ ] Fehlende optionale Komponenten erzeugen keine UI-Fehler.

### Stopkriterium

Die Oberfläche ist informativ und ruhig; zusätzliche UX-Lösungen haben je
einen benannten Zweck und überlagern dieselbe Funktion nicht unnötig.

## Phase 11 – Git

### Ziel

Änderungen und Hunks in Neovim bearbeiten, komplexere Git-Aufgaben mit
LazyGit erledigen und bei Bedarf die aktuelle Datei im Hosting-Browser öffnen.

### Schritte

- [ ] Änderungszeichen und Hunk-Aktionen mit einer kleinen Git-Integration
      einrichten; Vorschau, Stage, Reset und optional Blame testen.
- [ ] LazyGit im richtigen Repository-Verzeichnis aus Neovim öffnen.
- [ ] Das Öffnen der aktuellen Datei oder Zeile im Git-Hosting-Browser gegen
      den bisherigen Git-Workflow prüfen; ein Plugin ist nicht vorgegeben.
- [ ] Keine zusätzliche Branch-, Commit- oder History-Oberfläche nachbauen.
- [ ] Benötigte externe Tools, insbesondere Git und LazyGit, in der README
      dokumentieren.

### Verifikation

- [ ] Geänderte, hinzugefügte und entfernte Zeilen sind erkennbar; Hunk-
      Vorschau, Stage und Reset funktionieren in einem Testrepository.
- [ ] LazyGit startet im erwarteten Projekt; ein fehlendes Binary erzeugt
      eine verständliche Meldung.
- [ ] Ein Hosting-Link zeigt auf die richtige Datei und gegebenenfalls Zeile;
      außerhalb eines passenden Remote-Repositories gibt es keinen UI-Fehler.

### Stopkriterium

Der kleine Neovim-Git-Workflow und LazyGit ergänzen sich; der Hosting-Browser
ist bei Bedarf mit einem klaren Ablauf erreichbar.

## Phase 12 – Explizite Projektsessions

### Ziel

Arbeitsstände bewusst pro Projekt speichern und wiederherstellen, ohne
automatisches Laden beim Start.

### Schritte

- [ ] `:mksession` und `:source` zuerst in einem realen Projekt testen.
- [ ] Speicherort und Benennung von Sessions festlegen; nur bei konkreten
      Verwaltungs- oder Zuverlässigkeitslücken ein Plugin ergänzen.
- [ ] Explorer, Yazi und andere spezielle Buffer beim Speichern und Laden
      prüfen; keine automatische Wiederherstellung aktivieren.

### Verifikation

- [ ] Eine Session lässt sich bewusst speichern; Fenster, Tabs und normale
      Dateien werden nachvollziehbar wiederhergestellt.
- [ ] Fehlende Dateien und spezielle Buffer beschädigen den Start nicht.

### Stopkriterium

Eine Projektsession kann zuverlässig mit einem klaren manuellen Ablauf
gespeichert und geladen werden. In Phase 13 werden zusätzlich die dann
hinzukommenden speziellen Buffer berücksichtigt.

## Phase 13 – Eigene Integrationen

OpenFlowCode und SnipSnap sind zwei getrennte Unterphasen und Stopppunkte.
Beide bleiben im Config-Repository gebündelt. Ihre internen Anforderungen
werden jeweils vor der Umsetzung konkretisiert; gemeinsame Infrastruktur wird
nicht vorsorglich geschaffen.

### Phase 13a – OpenFlowCode

#### Ziel

OpenFlowCode als einzige AI-Integration an aktuelle Möglichkeiten von
OpenCode anpassen, statt das bisherige lokale Plugin ungeprüft zu portieren.

#### Schritte

- [ ] Aktuelle OpenCode-Dokumentation zu IDE, Server, ACP und Plugins prüfen;
      den kleinsten gewünschten Neovim-Workflow festlegen.
- [ ] Bisherige Backend- und Terminalverwaltung auf Notwendigkeit prüfen und
      einen minimalen, zuverlässigen TUI-Zugriff umsetzen.
- [ ] Prozessverantwortung für interne und externe Prozesse festlegen;
      Healthcheck, Start, Attach, Reconnect und Shutdown auf aktuelle APIs
      ausrichten. Veraltete Terminal- und Job-APIs nicht übernehmen.
- [ ] Nur nützliche Statusline- und Eventinformationen ergänzen.
- [ ] Kontextübergabe für Datei, Zeile und visuelle Auswahl neu bewerten;
      alte Annahmen über SSE-Endpunkte und Eventtypen prüfen.
- [ ] Credentials ausschließlich über den vorgesehenen externen
      Authentifizierungsweg verwenden und nötige Installation in der README
      dokumentieren.

#### Verifikation

- [ ] OpenCode lässt sich öffnen, schließen und nach Unterbrechung wieder
      erreichen; fehlendes Binary oder Backend beschädigt den Start nicht.
- [ ] Neovim beendet nur Prozesse, die es selbst gestartet hat.
- [ ] Statusline und Sessions funktionieren mit und ohne OpenCode-Buffer.
- [ ] Keine Credentials werden in Config, README oder Logs geschrieben;
      Copilot und CodeCompanion werden nicht benötigt.

#### Stopkriterium

OpenFlowCode ist klein, aktuell und zuverlässig; nicht mehr benötigte Teile
des bisherigen Plugins werden nicht übernommen.

### Phase 13b – SnipSnap

#### Ziel

Ein kleines eigenes Snippet-Plugin für persönliche Snippets schaffen, das
innerhalb der nvim12-Config liegt und aus jeder laufenden nvim12-Instanz
heraus bedienbar ist. Anforderungen und technische Umsetzung werden zu Beginn
dieser Unterphase verbindlich festgelegt.

#### Schritte

- [ ] Bedarf und Bedienabläufe präzisieren: Snippet leer oder aus einer
      visuellen Auswahl anlegen, wiederfinden, bearbeiten und löschen.
- [ ] Speicherort, Sprachzuordnung, Wiederverwendung zwischen Instanzen und
      Verhalten bei gleichzeitig geöffneten Instanzen festlegen.
- [ ] Native `vim.snippet`-Möglichkeiten aus Phase 5 und nötige zusätzliche
      Verwaltung vergleichen; SnipSnap nur für den benannten Bedarf bauen.
- [ ] SnipSnap als eigenes, klar abgegrenztes Plugin im Config-Repository
      anlegen und die nötigen Mappings beim Plugin definieren.
- [ ] Alte Godot-C#-Snippets nicht pauschal migrieren; nur bei tatsächlichem
      Bedarf einzelne Inhalte neu aufnehmen.
- [ ] Installation, Speicherung und gegebenenfalls externe Voraussetzungen
      für einen frischen Clone in der README dokumentieren.

#### Verifikation

- [ ] Ein leeres und ein aus einer Auswahl erstelltes Snippet lassen sich
      später in einer anderen nvim12-Instanz verwenden.
- [ ] Bearbeiten und Löschen wirken nachvollziehbar auch bei erneutem Start;
      gleichzeitig geöffnete Instanzen verlieren nicht unbemerkt Änderungen.
- [ ] SnipSnap funktioniert unabhängig von OpenFlowCode und beschädigt bei
      fehlenden persönlichen Snippets nicht den Start oder eine Session.

#### Stopkriterium

Die gewählten Snippet-Abläufe funktionieren mit einer kleinen, verständlichen
Implementierung; für einen frischen Clone sind alle nötigen Schritte erklärt.

## Phase 14 – Clean Install und finaler Wechsel

### Ziel

Nachweisen, dass ein frischer Clone und die README ausreichen, um den bis
Phase 13 gewählten Zielzustand reproduzierbar zu starten. **Phase 15 ist
optional und gehört nicht zum Wechsel-Gate.**

### Schritte

- [ ] Den vollständigen Aufbau mit getrennten, leeren Config-, Data-, State-
      und Cache-Verzeichnissen prüfen, ohne die bestehende Installation
      unkontrolliert zu verändern.
- [ ] Externe Plugins nur über `vim.pack` und `nvim-pack-lock.json`
      installieren; gebündelte lokale Integrationen mit frischem Clone
      testen.
- [ ] Externe Werkzeuge und SDKs der tatsächlich eingerichteten Profile mit
      der README abgleichen.
- [ ] Core, Navigation, Syntax/Textobjekte, Coding, UI, Git, Sessions,
      OpenFlowCode und SnipSnap mit realen Abläufen prüfen.
- [ ] Alle **eingerichteten** Sprachprofile in repräsentativen Projekten
      testen; TypeScript, JavaScript, CSS, Vue, Python und Swift aus Phase 15
      sind dafür keine Voraussetzung.
- [ ] Einen zweiten Start ohne Netzwerk prüfen; `nvim11` als funktionierenden
      Rollback erneut testen.
- [ ] `nvim12` vor dem finalen Wechsel im Alltag verwenden und ausdrücklich
      als stabil bewerten.
- [ ] Erst danach den separaten Plan `nvim012MigrationPlan.md` für die
      Übernahme als Standard-Config und das Entfernen von Neovim 0.11
      ausführen; dessen konkrete Schritte vor Ausführung an den tatsächlich
      aufgebauten Zustand (insbesondere `vim.pack` und externe Tools)
      anpassen.

### Abschlusschecks

```vim
:checkhealth
:checkhealth vim.deprecated
:checkhealth vim.lsp
:checkhealth vim.treesitter
:messages
```

- [ ] Start ohne Argument, mit Datei und mit Verzeichnis funktioniert.
- [ ] Plugininstallation und Wiederherstellung aus dem Lockfile funktionieren.
- [ ] Navigation, Dateibrowser und gewählte Syntax- und Textobjekt-Funktionen
      funktionieren.
- [ ] Formatting, Linting, Completion und Snippets funktionieren dort, wo
      sie eingerichtet wurden; SnipSnap funktioniert auch nach Neustart.
- [ ] Git, LazyGit, explizite Sessions und OpenFlowCode funktionieren ohne
      gespeicherte Secrets.
- [ ] Die README allein reicht zur Neuinstallation des Zielzustands auf
      macOS Apple Silicon.

### Stopkriterium

Die neue Config ist reproduzierbar und im Alltag stabil und kann die
Neovim-0.11-Config als Standard ersetzen. Keine Aufgabe aus Phase 15 blockiert
dieses Stopkriterium.

## Phase 15 – Optionale Erweiterungen nach dem Wechsel

Jede Unterphase ist eigenständig, kann bei fehlendem Bedarf offenbleiben und
endet mit einer eigenen Verifikation. Die Reihenfolge zwischen den
Unterphasen ist frei; innerhalb von Phase 15c wird zuerst Swift-Editing und
erst danach die Xcodebuild-Integration bewertet. Für neue Sprachprofile gilt
der gemeinsame Ablauf aus Phase 6: repräsentatives Projekt, Installationsweg,
LSP/Diagnostics/Completion/Navigation/Formatierung, nur nötige Linter und
Snippets, README und kurzer Praxistest. Neue Werkzeuge werden erst in der
betreffenden Unterphase dokumentiert und getestet.

### Phase 15a – TypeScript, JavaScript, CSS und Vue

#### Ziel und Schritte

- [ ] Die offene Phase 6b anhand eines repräsentativen Webprojekts
      fortführen; die nvim11-Config nur als Referenz für gewünschte Abläufe
      verwenden.
- [ ] TypeScript- und Vue-Server mit eindeutigem Attach und passender
      Root-Erkennung einrichten; JavaScript und CSS im selben Projekt prüfen.
- [ ] Projektlokale Versionen und Konfigurationen von Formatter und Linter
      bevorzugen; zusätzliche Parser nur für konkrete Lücken aus Phase 7
      ergänzen.
- [ ] Installationswege und verwendete externe Tools in der README ergänzen.

#### Verifikation und Stopkriterium

- [ ] Diagnostics, Completion, Navigation und Formatierung funktionieren in
      TypeScript, JavaScript, CSS und Vue ohne unbeabsichtigte doppelte
      Server-Attaches; ein frischer Start mit dokumentierten Tools gelingt.

Das Webprojekt ist bearbeitbar, ohne die bestehende Config zu beeinträchtigen.

### Phase 15b – Python

#### Ziel und Schritte

- [ ] Python anhand eines realen Projekts als Editing-Profil einrichten;
      Formatter und Linter aus nvim11 nur bei aktuellem Bedarf wählen.
- [ ] Einen Python-LSP nur ergänzen, wenn sein Nutzen im Projekt klar ist;
      externe Werkzeuge und Projektkonfiguration in der README dokumentieren.

#### Verifikation und Stopkriterium

- [ ] Formatierung und gewünschte Diagnostics funktionieren; bei
      eingerichtetem LSP auch Completion und Navigation.

Python lässt sich im gewählten Projekt mit den benötigten Editing-Funktionen
bearbeiten.

### Phase 15c – Swift und Xcodebuild

#### Ziel und Schritte

- [ ] Swift-Editing in einem repräsentativen Projekt mit Sprachserver,
      Formatierung und bei Bedarf Linting aufbauen und dokumentieren.
- [ ] Erst danach Xcode-Build-, Test- und Simulator-Workflows anhand eines
      konkreten Projekts bewerten; nur genutzte Funktionen und Mappings
      einrichten.
- [ ] Xcode- und CLI-Voraussetzungen sowie gegebenenfalls gewählte externe
      Tools in der README ergänzen.

#### Verifikation und Stopkriterium

- [ ] Swift-Dateien lassen sich mit den gewünschten Sprachfunktionen
      bearbeiten; bei gewählter Xcodebuild-Integration funktionieren Build,
      Test und Zielauswahl im repräsentativen Projekt.

Swift-Editing funktioniert eigenständig; Xcodebuild bleibt bei fehlendem
Bedarf optional.

### Phase 15d – .NET-/Godot-Tasks

#### Ziel und Schritte

- [ ] Reale Build-, Run- und Testabläufe für .NET oder Godot festlegen und
      zuerst die externen CLI-Abläufe prüfen.
- [ ] Nur bei konkretem Nutzen eine Taskverwaltung wie Overseer einrichten;
      benötigte Templates und Mappings auf verwendete Projekte beschränken.
- [ ] Externe Voraussetzungen und Projektannahmen in der README ergänzen.

#### Verifikation und Stopkriterium

- [ ] Gewählte Tasks starten im richtigen Projekt, zeigen Fehler verständlich
      an und lassen sich kontrolliert erneut starten oder beenden.

Die tatsächlich benötigten Aufgaben sind reproduzierbar, ohne ein separates
GDScript-Sprachprofil vorauszusetzen.

## Bewusst nicht eingeplant

- Vollständige Migration oder Einzelbewertung aller Neovim-0.11-Plugins
- Harpoon und eine dauerhaft sichtbare Symbolgliederung (Outline)
- Trouble und ein zusätzlicher Schema-Katalog für JSON/YAML
- Tipptraining mit Typr und ein eigenes Scratchpad
- Floaterm, allgemeine Terminal- und tmux-Integration
- Copilot und CodeCompanion neben OpenFlowCode
- Bufferline, Dashboard, Bilddarstellung in Neovim sowie eigene Befehls-
  und Undo-Verlaufs-Picker
- Automatische Wiederherstellung von Projektsessions
- Vollständige Keymap-/Pluginreferenz oder Dokumentation der gesamten
  Terminal- und Desktopumgebung in der README

Diese Abgrenzung schließt die ausdrücklich optionalen Sprachprofile und Tasks
aus Phase 15 nicht aus. Sie werden nur bei Bedarf und unabhängig vom
Wechsel auf Neovim 0.12 bearbeitet.
