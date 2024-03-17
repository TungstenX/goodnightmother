# Goodnight Mother

## THIS IS HOW YOU WENT INSANE
As the paranormal realm continues to deliberate on how to deal with the half-attached zombie spirits, the entities within that realm are now concentrating their efforts on the humans who remain. And yes, that includes you!

Currently there are 7 paranormal activities that a player can experience. The idea is to expand these activities and experiences.  Six, of the 7 activities, occurs when the player's character sleeps. Furthermore; these activities are weighted and the weighted values changes over time. Currently it will level off after 10 days (game days). These weighted values are not persisted, thus the level of activities will reset each time the game loads.

The 7 paranormal activities are:
- **Corpse:** Player wakes up with a corpse in bed. File: GMCorpse.lua
  - *TODO:* Properly place corpse on top of bed. The offset is wrong as well as showing the corpse above all the sprites of the bed
- **Naked:** Player wakes up naked. It respects the favourite selection on items.  File: GMNaked.lua
  - *TODO:* See file
- **Night Noises:** Player hears noises while sleeping. File: GMNightNoises.lua
  - *TODO:* See file
- **Poltergeists:** Poltergeists can move furniture around, shuffles containers' items (in current building), unpack all containers (in current building) or open and close windows and doors. Files: GMPoltergeists.lua and GMDoors.lua
  - *TODO:* See file
- **Scarecrow:** Player wakes up with a mannequin in the same room. This mannequin will also change facing direction (rotate) to face the player as the player moves around. File: GMScarecrow.lua
  - *TODO:* See file
- **Sleep Walker:** Player wakes up in a different room. File: GMSleepWalker
  - *TODO:* See file
- **Devices:** (Wakeful activities) Devices such a TVs and Radios are cursed. A TV will spawn a crawling Samara type zombie when player is facing the TV. A radio in the room will play spooky audio when the player is in range.
  - *TODO:* Not working properly. See file for to do list

Many thanks to developers of other mods that I studied to understand how this process works and how to do certain things.
Shout out to mods:
- Fred (https://steamcommunity.com/sharedfiles/filedetails/?id=2866782076)
- VISUAL SOUNDS EXTENSION (https://steamcommunity.com/sharedfiles/filedetails/?id=3141868620)
- RainWash (https://steamcommunity.com/sharedfiles/filedetails/?id=2657661246)
