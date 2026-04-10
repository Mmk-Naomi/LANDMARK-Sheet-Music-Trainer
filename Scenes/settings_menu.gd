extends CanvasLayer

var audio_bus_name: String = "Master"

signal letter_notes_visible_changed

var chocolate_mint = preload("res://Themes/chocoloate_mint_theme.tres")

var last_volume : float

func _ready() -> void:
	#ConfigFileHandler.settings_loaded.connect(_load_settings)
	#ConfigFileHandler.theme_chosen.connect(_load_theme)
	load_theme()
	load_settings()
	%AudioControl.value = ConfigFileHandler.audio_settings["sfx"]
	last_volume = ConfigFileHandler.audio_settings["sfx"]
	
func _on_back_button_pressed() -> void:
	ConfigFileHandler.save_settings()
	visible = false

func _on_audio_control_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index(audio_bus_name)
	last_volume = value
	AudioServer.set_bus_volume_linear(bus_index, value)
	ConfigFileHandler.audio_settings["sfx"] = value
	print(last_volume)

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#If fullscreen is enabled in video_settings, toggled_on
	ConfigFileHandler.video_settings["fullscreen"] = toggled_on

func _on_note_letter_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		GlobalVariables.show_note_letters = true
		letter_notes_visible_changed.emit()
	else:
		GlobalVariables.show_note_letters = false
		letter_notes_visible_changed.emit()
	ConfigFileHandler.game_settings["show_notes"] = toggled_on
	
func load_theme():
	var control = $Control
	var index = ConfigFileHandler.game_settings["theme"]
	print(index)
	#Load in themes based on what user selects
	if index == 0:
		GlobalVariables.current_theme = GlobalVariables.Themes.CHOCOLATE_MINT
		control.theme = chocolate_mint
	if index == 1:
		var strawberry = load("res://Themes/strawberry_theme.tres")
		GlobalVariables.current_theme = GlobalVariables.Themes.STRAWBERRY
		control.theme = strawberry
	if index == 2:
		var chocolate = load("res://Themes/dark_chocolate_theme.tres")
		GlobalVariables.current_theme = GlobalVariables.Themes.DARK_CHOCOLATE
		control.theme = chocolate
	if index == 3:
		var lemon = load("res://Themes/lemon_theme.tres")
		control.theme = lemon
		GlobalVariables.current_theme = GlobalVariables.Themes.LEMON
	if index == 4:
		var birthday = load("res://Themes/birthday_cake_theme.tres")
		control.theme = birthday
		GlobalVariables.current_theme = GlobalVariables.Themes.BIRTHDAY_CAKE
	if index == 5:
		var red_velvet = load("res://Themes/red_velvet_theme.tres")
		control.theme = red_velvet
		GlobalVariables.current_theme = GlobalVariables.Themes.RED_VELVET
	if index == 6:
		var chocolate_chip = load("res://Themes/chocolate_chip_theme.tres")
		control.theme = chocolate_chip
		GlobalVariables.current_theme = GlobalVariables.Themes.CHOCOLATE_CHIP
	if index > 6 or index < 0:
		GlobalVariables.current_theme = GlobalVariables.Themes.CHOCOLATE_MINT
		control.theme = chocolate_mint
		print("index #")
		print(index)
		
	GlobalVariables.theme_changed.emit()
	
func change_theme(index):
	var control = $Control
	#Load in themes based on what user selects
	if index == 0:
		GlobalVariables.current_theme = GlobalVariables.Themes.CHOCOLATE_MINT
		control.theme = chocolate_mint
	if index == 1:
		var strawberry = load("res://Themes/strawberry_theme.tres")
		GlobalVariables.current_theme = GlobalVariables.Themes.STRAWBERRY
		control.theme = strawberry
	if index == 2:
		var chocolate = load("res://Themes/dark_chocolate_theme.tres")
		GlobalVariables.current_theme = GlobalVariables.Themes.DARK_CHOCOLATE
		control.theme = chocolate
	if index == 3:
		var lemon = load("res://Themes/lemon_theme.tres")
		control.theme = lemon
		GlobalVariables.current_theme = GlobalVariables.Themes.LEMON
	if index == 4:
		var birthday = load("res://Themes/birthday_cake_theme.tres")
		control.theme = birthday
		GlobalVariables.current_theme = GlobalVariables.Themes.BIRTHDAY_CAKE
	if index == 5:
		var red_velvet = load("res://Themes/red_velvet_theme.tres")
		control.theme = red_velvet
		GlobalVariables.current_theme = GlobalVariables.Themes.RED_VELVET
	if index == 6:
		var chocolate_chip = load("res://Themes/chocolate_chip_theme.tres")
		control.theme = chocolate_chip
		GlobalVariables.current_theme = GlobalVariables.Themes.CHOCOLATE_CHIP
	if index > 6 or index < 0:
		GlobalVariables.current_theme = GlobalVariables.Themes.CHOCOLATE_MINT
		control.theme = chocolate_mint
		print("index #")
		print(index)
	
	ConfigFileHandler.game_settings["theme"] = index
	GlobalVariables.theme_changed.emit()

func _on_themes_item_selected(index: int):
	#Load in themes based on what user selects
	change_theme(index)

func _on_quit_button_pressed() -> void:
	ConfigFileHandler.save_settings()
	get_tree().quit()

func _on_treble_bass_item_selected(index: int) -> void:
	if index == 0:
		GlobalVariables.is_bass = true
		GlobalVariables.is_treble = true
	if index == 1:
		GlobalVariables.is_bass = false
		GlobalVariables.is_treble = true
	if index == 2:
		GlobalVariables.is_bass = true
		GlobalVariables.is_treble = false
	ConfigFileHandler.game_settings["clef"] = index
	GlobalVariables.difficulty_changed.emit()

func _on_difficulty_item_selected(index: int) -> void:
	if index == 1:
		GlobalVariables.current_difficulty = GlobalVariables.Difficulty.LANDMARK
	if index == 3:
		GlobalVariables.current_difficulty = GlobalVariables.Difficulty.VERY_EASY
	if index == 2:
		GlobalVariables.current_difficulty = GlobalVariables.Difficulty.EASY
	if index == 0:
		GlobalVariables.current_difficulty = GlobalVariables.Difficulty.HARD
	ConfigFileHandler.game_settings["difficulty"] = index
	GlobalVariables.difficulty_changed.emit()

func _on_mute_button_toggled(toggled_on: bool) -> void:
	var bus_index = AudioServer.get_bus_index(audio_bus_name)
	if toggled_on:
		AudioServer.set_bus_volume_linear(bus_index, 0)
		print("Muted")
	elif last_volume == null:
		AudioServer.set_bus_volume_linear(bus_index, 1)
	else:
		AudioServer.set_bus_volume_linear(bus_index, last_volume)
		print(last_volume)
	ConfigFileHandler.audio_settings["mute"] = toggled_on
	
func load_settings():
	#Set all checkboxes and option menus to the correct selection
	if ConfigFileHandler.video_settings["fullscreen"]:
		%FullscreenToggle.button_pressed = true
	%MuteButton.button_pressed = ConfigFileHandler.audio_settings["mute"]
	%NoteLetterButton.button_pressed = ConfigFileHandler.game_settings["show_notes"]
	%Difficulty.selected = ConfigFileHandler.game_settings["difficulty"]
	%Themes.selected = ConfigFileHandler.game_settings["theme"]
	%TrebleBass.selected = ConfigFileHandler.game_settings["clef"]
	
	
