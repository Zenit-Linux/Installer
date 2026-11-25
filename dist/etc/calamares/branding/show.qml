/* Zenit Linux – slideshow podczas instalacji (Calamares slideshow API 2) */
import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function nextSlide() { presentation.goToNextSlide() }

    Timer {
        id: advanceTimer
        interval: 12000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: nextSlide()
    }

    ZSlide { title: "Witaj w Zenit Linux";       body: "System oparty na openSUSE – stabilny fundament, nowoczesny wygląd i pełna swoboda wyboru środowiska graficznego." }
    ZSlide { title: "Wybierz swój pulpit";       body: "Plasma, GNOME, Xfce, COSMIC, Sway, Hyprland i ponad dwadzieścia innych. Możesz je zainstalować obok siebie i przełączać na ekranie logowania." }
    ZSlide { title: "Bezpieczeństwo i migawki";  body: "Domyślnie Btrfs z kompresją zstd – gotowy na migawki systemu i szybki powrót do poprzedniego stanu." }
    ZSlide { title: "Zaraz kończymy";            body: "Instalator pobiera wybrane środowiska i konfiguruje system. Zaparz kawę – to nie potrwa długo." }
}
