# Mission To Fission
This game/simulator started out as a simulation to explain fission on the YouTube channel Higgsino Physics. 

Feel free to clone this project, load width Godot and play for free. It will also be on steam later.

This game is currently under development.

## Contributing 
Feel free to submit code changes! I would love the help. Everyone who submits code will be included under the credits tab in the game. 
**!! Please notice !!** While the game is free and open source for everyone able to compile it, it's for sale on steam. The income is for further development of the game and new videos. 

You can also help by submitting bugs, or ideas on how to enhance the game. 

## Godot 
This game is made with Godot 4.3, and scripted width GDScript.
Probably it should have been made width C# for better performance. 

## Known Issues: 
- Only runs on 1920*1080 screen
- Game stops at 1000 neutrons

## Big Todo's:
- Add "options" settings, for sound music and such.
- make screen responsive.
- Optimize performance.


## Todo now
- fix settings physics chganges
- tutorial: add game actually
- change to percentages not decimals 


## Small Todo's 
- Tween animations (such as color changes and deletions)

# Feedback:
1: 
- screen resolution for mac is off
- I think it would help to have more instructions on what's happening
during the Game Mode and more clear objectives. It's definitely fun playing
around with. But if you had certain objectives to obtain and certain levels to pass,
it would make it way cooler Idk what you have in mind, but one idea would be that
you need to produce a certain amount of energy to power something without destroying it.
I think you mentioned a kettle in the tutorial. So level 1 could be a kettle, level 2, a whole room,
level 3 an entire house, ... etc.

2: 
--------------------------------------------------------------------------------
Bugs:
--------------------------------------------------------------------------------
- None of the reactors were screen-centered for me; the reactor in Simulation Mode was cut off on the right side 
  of the screen.
- If more than 1000 neutrons are on screen, the game ends as intended. However, the "Main Menu" button loops you 
  back to the game over screen, as long as there are still more than 1000 neutrons active.
- In Simulation Mode, I occasionally get a neutron counter of 150+ even if there are fewer than 30 on screen, and 
  I don't hear that much fission happening. Maybe this has something to do with parts of the reactor being off-screen? 
  The "offset" of 150+ neutrons from the real value seems relatively consistent, as far as I can tell.
- I cannot move the control rods upward in Simulation Mode at the beginning. This only works once all control rods 
  have been fully inserted at least once.

--------------------------------------------------------------------------------
Inconveniences:
--------------------------------------------------------------------------------
- The fission sound becomes quite distorted when 500+ neutrons are active. Maybe limit the gain or apply some audio 
  filtering when too many neutrons are present?
- The sound of the control rods loops in a relatively annoying way and continues even when the rods are fully inserted 
  or withdrawn.

- Wording issue: "Increases the speed of random neutrons released by waste material" sounds like the actual speed of 
  the neutrons is being modified, which may be misleading.
- The speed of delayed neutrons and the speed of enrichment increases the lower the corresponding value is set 
  in the settings tab.
