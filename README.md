
# Astral Heat Music for OHMSBY Style Characters v0.0.4a


This module enables custom **Astral Heat BGM** for OHMSBY-style characters in **IKEMEN GO**, using parameters defined in `select.def`.

---

## Credits

Commissioned by **SkeleJ64**

---

## Installation

1. Download the module.
2. Drag and drop the **.lua** file into:

```ini
external/mods/
```

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
astral.btartposition
astral.freqmul
astral.loopcount

rival[1-9]name
rival[1-9].music
rival[1-9].volume
rival[1-9].loop
rival[1-9].loopstart
rival[1-9].loopend
rival[1-9].btartposition
rival[1-9].freqmul
rival[1-9].loopcount
```

Example:

```ini
Ragna,
    astral.music = chars/Ragna/Ragna.mp3,
    astral.volume = 100,
    astral.loop = 0,
    rival1name=Jin Kisaragi,
    rival1.music = chars/Ragna/vsJin.mp3
```

---

## Notes

* The Astral Heat music **does not play immediately** when the Astral Heat is attempted.
* The music will play **only after the Astral Heat successfully lands**.
* Multiple characters can share the same Astral Heat BGM (e.g. RWBY characters).
* The Rival's Name should be the character's **name**, not **displayname**.
