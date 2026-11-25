# Zenit Linux – instalator Calamares + tryb live

Konfiguracja Calamares dla **Zenit Linux** (baza: openSUSE Tumbleweed) i pochodnych
(Slowroll, Leap…). Złoto na ciepłej czerni – paleta wzięta z logo.

## Co jest w środku

| Element | Gdzie |
|---|---|
| Tożsamość i baza dystrybucji (jedyny plik do zmiany w pochodnej) | `distro.conf` |
| Katalog **23 środowisk** (pakiety, sesja, DM, opis, podgląd) | `data/desktops.yaml` |
| Konfiguracja Calamares (zypper, GRUB2, dracut, btrfs) | `rootfs/etc/calamares/` |
| Motyw: QSS, slideshow, pełny ekran | `rootfs/etc/calamares/branding/zenit/` |
| Ekran wyboru środowisk z **podglądem** (QML) | `modules/zenitdesktop/` |
| Instalacja wybranych środowisk + display manager (Python) | `modules/zenitdesktopjob/` |
| Sesja Openbox na cały ekran + ekran startowy Instalacja/Live | `rootfs/usr/bin/zenit-*`, `rootfs/etc/zenit/openbox/` |
| Build / instalacja / narzędzia | `build.sh`, `install.sh`, `tools/` |

## Szybki start

```bash
./build.sh                      # wynik: dist/  (overlay na rootfs obrazu)
sudo DESTDIR=/ścieżka/rootfs ./install.sh   # albo skopiuj dist/ do overlaya Zenit Buildera
tools/check-packages.sh         # (na openSUSE) sprawdza, czy pakiety z desktops.yaml istnieją
```

Pochodna: skopiuj `distro.conf` (np. `derivatives/example-leap.conf`), zmień nazwę, `BASE`, ewentualnie logo
w `assets/zenit-logo.png`, i uruchom `./build.sh swoj.conf`. Środowiska niedostępne w danej bazie
(pole `bases:` w `desktops.yaml`) są w instalatorze wyszarzone.

## Jak działa start live

1. SDDM robi autologin do sesji **`zenit-installer`** (`/etc/sddm.conf.d/10-zenit-installer.conf`).
2. Sesja uruchamia **Openbox** (bez menu i skrótów) i pełnoekranowy ekran startowy: **Zainstaluj / Wypróbuj (live)**.
3. *Zainstaluj* → Calamares na cały ekran (`windowExpanding: fullscreen` + reguła w `rc.xml`).
4. *Wypróbuj* → `zenit-live-switch live` ustawia autologin na `LIVE_SESSION_FILE` i restartuje DM –
   startuje istniejące środowisko graficzne obrazu. W live jest skrót „Zainstaluj Zenit Linux”, który wraca do instalatora.

## Wybór środowisk

Ekran `zenitdesktop`: siatka kart z podglądem, klik = zaznacz (można kilka), pierwsze = domyślne (★).
Zapis do Global Storage (`zenit_desktops`), a `zenitdesktopjob` instaluje przez `zypper`
(wzorce `pattern:` lub listy pakietów), dobiera wspólne pakiety X11/Wayland i ustawia display manager
(SDDM; GDM dla GNOME jako domyślnego). **Blue Environment** to placeholder – widoczny, ale niewybieralny.

**Prawdziwe zrzuty ekranu:** wrzuć `assets/previews/<id>.png` (np. `plasma.png`, 640×400) – przy `build.sh`
zastąpią wygenerowane makiety.

## Wymagane pakiety w obrazie live

`calamares` (Qt6, z modułami QML/Python), `python3-PyYAML`, `python3-qt5` (ekran startowy; fallback: `yad`),
`openbox`, `sddm`, `sudo`, `xsetroot`, `NetworkManager-applet` / `nm-connection-editor` (Wi-Fi), `dracut`, `grub2`.

## Uwagi – do weryfikacji przy pierwszym buildzie

Całość nie była uruchamiana w Calamares (brak go w środowisku, w którym powstała paczka). Zweryfikowano składnię
YAML/Python/XML/Bash oraz sam build. Sprawdź kolejno:

* **`LIVE_SQUASHFS`** i `unpackfs` – ścieżka obrazu zależy od tego, jak Builder składa live ISO.
* **Nazwy pakietów/wzorców** (zwłaszcza COSMIC, Wayfire, Hyprland, Budgie, Qtile, Labwc) – `tools/check-packages.sh`.
  Brakujące są pomijane (`zypper --ignore-unknown`), ale środowisko wtedy będzie niepełne.
* **Moduł QML** – ładowany przez `module.desc` (`qmlPath`); jeśli Twoja wersja Calamares oczekuje innych kluczy,
  zajrzyj do `src/modules/README.md` Calamares. Użyto `Global.insert()` (`io.calamares.core`).
* **Instalacja środowisk wymaga internetu** (jest wymóg w `welcome.conf`). Tryb offline = osobna lista pakietów w squashfs.
* Display manager: tylko **SDDM** w sesji live (inne DM wymagają własnego odpowiednika `10-…`/`99-…`).
* UI jest po polsku (stringi w QML/branding); Calamares tłumaczy własne ekrany sam.
