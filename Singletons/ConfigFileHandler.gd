extends Node

const CONFIG_PATH = "user://settings.ini"

signal settings_loaded

var video_settings := {
	"fullscreen": false,
}

var audio_settings := {
	"sfx": 1.0,
	"mute": false,
}

var game_settings := {
	"show_notes": false,
	"clef": 0,
	"theme": 6,
	"difficulty": 3,
}

func _ready() -> void:
	load_settings()
	apply_audio_settings()
	apply_video_settings()
	apply_game_settings()
	
	settings_loaded.emit()

func save_settings():
	var config := ConfigFile.new()
	
	#Set values for each setting in each dictionary
	for key in video_settings:
		config.set_value("video", key, video_settings[key])
		
	for key in audio_settings:
		config.set_value("audio", key, audio_settings[key])
		
	for key in game_settings:
		config.set_value("game", key, game_settings[key])
		
	config.save(CONFIG_PATH)

func load_settings():
	var config := ConfigFile.new()
	#load config file
	var err := config.load(CONFIG_PATH)
	
	#If the path doesn't exist, end function and set default variables
	if err != OK:
		return
	
	#Get each variable from the dictionary
	for section in ["video", "audio", "game"]:
		if not config.has_section(section):
			continue
			
		var target_dict = get(section + "_settings")
		for key in target_dict.keys():
			if config.has_section_key(section, key):
				target_dict[key] = config.get_value(section, key)
				
func apply_video_settings():
	var v = video_settings
	#If fullscreen, change to fullscreen mode. If we get any other option, change to windowed
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if v["fullscreen"] else DisplayServer.WINDOW_MODE_WINDOWED)
	if v["fullscreen"]:
		GlobalVariables.fullscreen = true
	
func apply_audio_settings():
	#Applying audio settings
	var sfx = linear_to_db(clamp(audio_settings["sfx"], 0.0, 1.0))
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx)
	#If muted, set volume to 0. If not, set volume to sfx value stored in config file
	var a = audio_settings
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0.0 if a["mute"] else sfx)

func apply_game_settings():
	#Apply show notes setting
	var g = game_settings
	if g["show_notes"]:
		GlobalVariables.show_note_letters = true
	#Apply clef settings through a match statement
	match g["clef"]:
		0:
			GlobalVariables.is_bass = true
			GlobalVariables.is_treble = true
		1:
			GlobalVariables.is_bass = false
			GlobalVariables.is_treble = true
		2:
			GlobalVariables.is_bass = true
			GlobalVariables.is_treble = false
		_:
			GlobalVariables.is_bass = true
			GlobalVariables.is_treble = true
	#Apply difficult settings through a match statement. If an unexpected value is chosen, default to very easy
	match g["difficulty"]:
		0:
			GlobalVariables.current_difficulty = GlobalVariables.Difficulty.HARD
		1:
			GlobalVariables.current_difficulty = GlobalVariables.Difficulty.LANDMARK
		2:
			GlobalVariables.current_difficulty = GlobalVariables.Difficulty.EASY
		3:
			GlobalVariables.current_difficulty = GlobalVariables.Difficulty.VERY_EASY
		_:
			GlobalVariables.current_difficulty = GlobalVariables.Difficulty.VERY_EASY
	
