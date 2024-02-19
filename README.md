# Dinocolorus

A video game made using [LÖVE](https://www.love2d.org/).

## Username

Thecaligarmo

## Project

This project is the capstone project for Harvard's GD50: <https://cs50.harvard.edu/games/2018/>

### Game Idea Specifics

The idea for my game was to take a platformer and try and make a puzzle out of it. The initial idea was to have two different worlds ("red" and "green") which you can go from one to the other. Your path is blocked by locked doors and you have to traverse both worlds in order to get the required keys. This is different from the platformer we made in the class specifically because it is combining a platformer with a puzzle world where you have to manage two worlds at once. In addition to this, I created a menu screen which allows for both mouse and keyboard input to start playing around with different things we can do. It also incorporates overlays/interactables to help the player find their way around the world and adds a goal to each level to complete the level. The complexity of this project was having two worlds at once as the player needs to only interact with some objects at a time but all objects need to be displayed. This required new ways of handling game play, updates and rendering to correctly work in a way that is intuitive and expected.

#### Two worlds, one screen

I decided to have two worlds be on one screen in order to give the user minor hints as to where they should go. Otherwise, you're just walking aimlessly and it feels less fun. By allowing little hints, it gives the user a "wait, how do I get there?" question which pushes their drive to try and find something. It also presented a nice challenge for me in order to see how I can get two worls showing up at once without presenting to much clutter and also making it interesting.

#### States

In class, we had done a unique object for each state of a player. Instead, in this project I decided to put all the state logic into one object. This for me made more sense as a player that is "falling", "jumping", etc. is still just a player and so a "falling player" is just a "player". So I constructed the `Entity` class (see below) which handles different moveable objects and that incorporates states into it.

#### Scenes/Overlays

At first I thought about making a traditional scene stack, but instead I decided to do an overlay stack instead where there is always some scene present and an overlay present on top of it. The overlays then allowed a quick construction of things that need to go "on top" of the current scene and that pause the scene whenever needed. This made it so that there were 4 scenes and 4 overlays. This required combining/altering the scene manager/stack that we used in the game to handle a more complex construction.

##### Scenes

1. `StartScene` - Handles the beginning of the game. A fun little introduction
2. `MainMenuScene` - Shows all possible levels the user can start from. I left enough space for future "save" locations in case other levels are added.
3. `CharSelectScene` - The graphics I used came with multiple color options for the dinosaurs, so I thought it would be cute to let the user customize who they play as.
4. `PlayScene` - The main scene that handles all game play logic.

There is also an `AbstractScene` which abstractifies the scene to make a more object oriented approach to scenes.

##### Overlays

1. `PauseOverlay` - An overlay to show the game is paused
2. `TextOverlay` - An overlay that just shows some text
3. `QuitOverlay` - An overlay for when the user wants to quit (currently only accessible from start scene)
4. `DialogueOverlay` - An overlay which has a "speaker" and "text" optioon for allowing to show a dialogue at the top of the screen.

As before, there is also an `AbstractOverlay` file which abstractifies overlays.

#### Objects

In `src/objects` I have all of the objects associated with this project. In order to work with object oriented programming, I created a base file (`GameObject`) which has the basics of any object and then built from there. There are three main types of objects which came out of this.

##### Entities

Entities are objects which move around. For this I created the `Entity` base object and then the `Enemy` object for automated entities and `Player` object for user/keyboard controlled objects. In order to simplify the different animations (due to stylesheets) I also made a `EnemyGreen` and `EnemyRed` to handle the two different animation grids for the enemy. (This was an arbitrary choice and I could have done this in `Enemy` itself)

##### Hover

Hovers are mostly UI types of objects that allow user interaction/hover with a mouse. For this I made a `HoverBox` which was the main hovering rectangular box object and the `HoverTile` (for tiles/images) and `HoverText` (for text).

#### Tiles/Blocks

From here, the objects in the world then had additional things I had to add. Originally I started with a `Block` object for the tiles in the world, but then quickly realised that sometimes I wanted a tile to be not collidable. So I made `Tiles` be tiles that came from the tilesheet that were inherently not collidable and `Block` (which extended from `Tile`) which were collidable. From here, this allowed for much more objects based on their purposes:

1. `Pickup` - A tile the user can pickup (which then adds/alters the player in some way)
2. `GoalPickup` - A pickup which specifically ends the level. It increases the player's level number.
3. `InteractableTile` - A tile that you can't collide with, but you can interact with (by pressing up)
4. `LockedBlock` - A block which is locked until the player gets a key to unlock it
5. `HitableBlock` - A block which the player can hit from below to generate a pick up.

### Level Generation

By choice, I did not want randomly generated levels as I wanted to construc a more puzzle level. For this, I needed to first make a tutorial to show the user all the possible options (in particular, interacting with doors, locks, keys) and then the level itself. To simplify this, I used the program Tiled which allows you to "draw" your level and then export it as a CSV. This let me use the CSV data to automatically generate the level by just going tile by tile and creating the appropriate object based off the number at that spot. This simplified level generation and makes it so that in the future if I want to add more levels there is not to much to do.

### Audio/graphics

As I'm not good with graphics and, personally, I don't like audio in games, I used external sources for audio and graphics (see below). Once I saw the dino graphics I knew I wanted a cutsie type of vibe for the game, and so I found graphics/sounds which matched the ambiance I was going for. All credits are found below.

## Credits

### Graphics

+ Kenney.nl - Abstract Platformer - <https://opengameart.org/content/abstract-platformer>
+ @ScissorMarks - Dino Characters - <https://arks.itch.io/dino-characters>
+ @DemChing - Dino Family - <https://demching.itch.io/dino-family>
+ Octav Codrea - Font - <https://www.1001freefonts.com/dinomouse.font>

### Scripts

+ Class - <https://github.com/HDictus/hump>
+ Camera - <https://github.com/HDictus/hump>
+ Timer - <https://github.com/HDictus/hump>
+ slam - <https://github.com/vrld/slam>
+ StateMachine - <https://github.com/kyleconroy/lua-state-machine/>
+ anim8 - <https://github.com/kikito/anim8>
+ bump - <https://github.com/kikito/bump.lua>

### Audio

Background Music:

Daisy by Sakura Girl | <https://soundcloud.com/sakuragirl_official>

Music promoted by <https://www.chosic.com/free-music/all/>

Creative Commons CC BY 3.0

<https://creativecommons.org/licenses/by/3.0/>

All other music/sound effects:
<https://mixkit.co>
