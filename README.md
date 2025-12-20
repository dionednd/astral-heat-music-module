
# Astral Heat Music for OHMSBY Style Characters v0.0.2


This module enables custom **Astral Heat BGM** for OHMSBY-style characters in **IKEMEN GO**, using parameters defined in `select.def`.

---

## Credits

Commissioned by **SkeleJ64**

---

## Installation

1. Download the module.
2. Drag and drop the **.lua** file into:


external/mods/

````

---

## Usage

To define Astral Heat music for an OHMSBY-style character, open your `select.def` and add the following to the character entry:

```ini
, astral.music = sound/astral_music.mp3
````

Your character entry should look like this:

```ini
Ragna, astral.music = chars/Ragna/Ragna.mp3
```

---

## Optional Parameters

You can also define additional music parameters:

```ini
astral.volume
astral.loop
astral.loopstart
astral.loopend
astral.startposition
astral.freqmul
astral.loopcount
```

Example:

```ini
Ragna,
    astral.music = chars/Ragna/Ragna.mp3,
    astral.volume = 100,
    astral.loop = -1
```

---

## Notes

* The Astral Heat music **does not play immediately** when the Astral Heat is attempted.
* The music will play **only after the Astral Heat successfully lands**.
* Multiple characters can share the same Astral Heat BGM (e.g. RWBY characters).
