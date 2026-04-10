extends Node

signal random_clef_chosen
signal theme_changed
signal difficulty_changed

# Core functionality variables
var note_number : int = 4
var player_note : String = ""
var new_note : bool = false
var generate_new_notes : bool = false

# Settings menu variables
var is_treble : bool = true
var is_bass : bool = true
var game_res : Vector2
var show_note_letters : bool = false
var fullscreen : bool = false

#User-selectable themes
enum Themes {CHOCOLATE_MINT, STRAWBERRY, DARK_CHOCOLATE, LEMON, CHOCOLATE_CHIP, BIRTHDAY_CAKE, RED_VELVET}

var current_theme: Themes = Themes.CHOCOLATE_MINT

enum Difficulty {EASY, VERY_EASY, HARD, LANDMARK}

var current_difficulty: Difficulty = Difficulty.VERY_EASY

enum Clefs {BASS, TREBLE, NONE}

var current_clef: Clefs = Clefs.NONE
