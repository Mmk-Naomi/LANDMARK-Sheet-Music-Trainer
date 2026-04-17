extends Node
class_name Game
#Create a note number variable that is equal to GlobalVariables note number
@export var note_number := GlobalVariables.note_number
var note_array: Array[String] = []
var current_score : int = 0

#High score variables
var high_score : int
var easy_high_score : int
var very_easy_high_score : int
var hard_high_score : int
var landmark_high_score : int

#Basic functinoality variables
var note_check_no : int
var menu_up : bool = false

var cursor_pos : int

const SAVE_PATH: String = "user://piano_high_score.save"



# Preloading the note scene
var mynote = preload("res://Scenes/note.tscn")

var settings_scene = preload("res://Scenes/settings_menu.tscn")
var settings_instance = settings_scene.instantiate()

@onready var treble_sprite = preload("res://Assets/treble-clef.png")
@onready var bass_sprite = preload("res://Assets/bass-clef.png")

@onready var active_panel_label = $Control/ActiveNotePanel/Label

func _ready() -> void:
	current_score = 0
	add_child(settings_instance)
	load_score()
	new_game()
	_load_theme()
	#set high score equal to loaded the value
	%MusicScene.notes_generated.connect(_on_notes_generated)
	GlobalVariables.theme_changed.connect(_load_theme)
	GlobalVariables.difficulty_changed.connect(_load_difficulty)
	
	
func _test():
	print("Connected!")

func _on_notes_generated(m_note_array: Array):
	print("Notes Generated!")
	note_array = m_note_array

func new_game():
	#Resetting note_check_no to 0
	note_check_no = 0
	settings_instance.visible = false
	
	#Load score in case difficulty has been changed
	load_score()
	#Set cursor equal to the NoteMarker global position to start the game
	#%Cursor.position.x = %MusicScene/NoteMarker.global_position.x
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(%Cursor, "position:x", %MusicScene/NoteMarker.global_position.x, 0.3)
	var clef_sprite = %ClefSprite
	
	#Some variables so that we can play animations when there's a new clef
	var random_clef : int = 1
	
	#Choose random value between 0 and 1, treble being 1 and bass being 0
	random_clef = randi_range(0, 1)

	# If either bass or treble is false, set to correct value
	if GlobalVariables.is_bass == false:
		random_clef = 1
	if GlobalVariables.is_treble == false:
		random_clef = 0
		
	clef_sprite.modulate.a = 0.0
	var clef_tween = create_tween()
	clef_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	clef_tween.tween_property(clef_sprite, "modulate:a", 1.0, 0.3)
		
	# if it is 1 then set current clef to treble
	if random_clef == 1:
		GlobalVariables.current_clef = GlobalVariables.Clefs.TREBLE
		print("Current clef is treble")
		clef_sprite.texture = treble_sprite
		clef_sprite.scale = Vector2(0.30, 0.30)
		clef_sprite.position = Vector2(-10, -5)
		
	#Set sprite to correct sprite, and rescale based on which sprite it is
	if random_clef == 0:
		GlobalVariables.current_clef = GlobalVariables.Clefs.BASS
		print("Current clef is bass")
		clef_sprite.texture = bass_sprite
		clef_sprite.scale = Vector2(0.25, 0.25)
		clef_sprite.position = Vector2(0, 45)
		
	GlobalVariables.random_clef_chosen.emit()
		
	note_array = %MusicScene.note_array
	active_panel_label.text = note_array[note_check_no] 
	active_panel_label.visible = false
	
func _physics_process(_delta: float) -> void:
	#If player presses a key, check if the note matches
	if(GlobalVariables.new_note == true):
		check_notes()
	
func check_notes():
	note_array = %MusicScene.note_array
	
	if(GlobalVariables.player_note == note_array[note_check_no] and GlobalVariables.new_note == true):
		#Check the current note against the generated notes. If correct, add to current score and move up the array.
		current_score += 1
		%ScoreLabel.text = str(current_score)
		note_check_no += 1
		print("Correct" + str(current_score))
		print("Note check number" + str(note_check_no))
		# Move cursor 200 pixels to the right
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(%Cursor, "position:x", %Cursor.position.x + 200, 0.2)
		#%Cursor.position.x += 200
		
		#Animate the score label
		var score_tween: Tween
		if score_tween: score_tween.kill()
		score_tween = create_tween()
		score_tween.set_trans(Tween.TRANS_BACK)
		score_tween.set_ease(Tween.EASE_IN)
		score_tween.tween_property(%ScoreLabel, "scale", Vector2(1.2, 1.2), 0.2)
		score_tween.tween_property(%ScoreLabel, "scale", Vector2(1.0, 1.0), 0.2)
		
		#Save the current score if it is higher than existing score, but do not update screen until player gets one wrong
		update_high_score()
	
		#Set new_note to false for when the player next clicks
		GlobalVariables.new_note = false
		#If note_check_no is equal to our max number of notes, reset by running new_game()
		if (note_check_no == GlobalVariables.note_number):
			GlobalVariables.generate_new_notes = true
			new_game()
			
		active_panel_label.text = note_array[note_check_no]
		active_panel_label.hide()
	else:
		GlobalVariables.new_note = false
		
		
		#Set a tween or shader that will make the score flash red when a note is pressed incorrectly
		var minus_tween: Tween
		if minus_tween: minus_tween.kill()
		minus_tween = create_tween()
		minus_tween.set_trans(Tween.TRANS_BACK)
		minus_tween.set_ease(Tween.EASE_IN)
		minus_tween.tween_property(%ScorePic.material, "shader_parameter/amount", 1.0, 0.1)
		minus_tween.tween_property(%ScorePic.material, "shader_parameter/amount", 0.0, 0.1)
		minus_tween.tween_property(%ScorePic.material, "shader_parameter/amount", 1.0, 0.1)
		minus_tween.tween_property(%ScorePic.material, "shader_parameter/amount", 0.0, 0.1)
	
		current_score = 0
		print("Incorrect" + str(current_score))
		%ScoreLabel.text = str(current_score)
			
func _load_difficulty():
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.EASY:
		high_score = easy_high_score
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.VERY_EASY:
		high_score = very_easy_high_score
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.HARD:
		high_score = hard_high_score
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.LANDMARK:
		high_score = landmark_high_score
	current_score = 0
	%HiScoreLabel.text = str(high_score)
	new_game()
		
func save_score() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(very_easy_high_score)
	file.store_var(easy_high_score)
	file.store_var(hard_high_score)
	file.store_var(landmark_high_score)

func load_score() -> void:
	#If file exists, get the high score
	if FileAccess.file_exists(SAVE_PATH):
		print("file found")
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		very_easy_high_score = file.get_var(very_easy_high_score)
		easy_high_score = file.get_var(easy_high_score)
		hard_high_score = file.get_var(hard_high_score)
		landmark_high_score = file.get_var(landmark_high_score)
		match GlobalVariables.current_difficulty:
			GlobalVariables.Difficulty.EASY:
				high_score = easy_high_score
			GlobalVariables.Difficulty.VERY_EASY:
				high_score = very_easy_high_score
			GlobalVariables.Difficulty.HARD:
				high_score = hard_high_score
			GlobalVariables.Difficulty.LANDMARK:
				high_score = landmark_high_score
			_:
				high_score = 0
		%HiScoreLabel.text = str(high_score)
	#If it doesn't set, high_score to 0
	else:
		print("file not found")
		high_score = 0
		
func update_high_score() -> void:
	if current_score > high_score:
		high_score = current_score
		
		# Play an animation so that the player sees they have hit a new high score
		%HiScoreLabel.text = str(high_score)
		var score_tween: Tween
		if score_tween: score_tween.kill()
		score_tween = create_tween()
		score_tween.set_trans(Tween.TRANS_BACK)
		score_tween.set_ease(Tween.EASE_IN)
		score_tween.tween_property(%HiScoreLabel, "scale", Vector2(1.2, 1.2), 0.2)
		score_tween.tween_property(%HiScoreLabel, "scale", Vector2(1.0, 1.0), 0.1)
		
		match GlobalVariables.current_difficulty:
			GlobalVariables.Difficulty.VERY_EASY:
				very_easy_high_score = high_score
			GlobalVariables.Difficulty.EASY:
				easy_high_score = high_score
			GlobalVariables.Difficulty.HARD:
				hard_high_score = high_score
			GlobalVariables.Difficulty.LANDMARK:
				landmark_high_score = high_score
		save_score()
		

func _on_menu_button_pressed() -> void:
	settings_instance.visible = true
	
func _load_theme() -> void:
	var control = $Control
	if GlobalVariables.current_theme == GlobalVariables.Themes.CHOCOLATE_MINT:
		var minty_choc = load("res://Themes/chocoloate_mint_theme.tres")
		control.theme = minty_choc
		%BackgroundRect.color = Color(0.051, 0.012, 0.141)
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.STRAWBERRY:
		var strawberry = load("res://Themes/strawberry_theme.tres")
		control.theme = strawberry
		%BackgroundRect.color = Color(0.984, 0.968, 0.887, 1.0)
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.DARK_CHOCOLATE:
		var chocolate = load("res://Themes/dark_chocolate_theme.tres")
		control.theme = chocolate
		%BackgroundRect.color = Color(0.06, 0.02, 0.002, 1.0)
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.LEMON:
		var lemon = load("res://Themes/lemon_theme.tres")
		control.theme = lemon
		%BackgroundRect.color = Color(0.792, 0.987, 0.988, 1.0)
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.BIRTHDAY_CAKE:
		var birthday = load("res://Themes/birthday_cake_theme.tres")
		control.theme = birthday
		%BackgroundRect.color = Color(0.994, 0.838, 0.74, 1.0)
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.RED_VELVET:
		var red_velvet = load("res://Themes/red_velvet_theme.tres")
		control.theme = red_velvet
		%BackgroundRect.color = Color(0.366, 0.0, 0.095, 1.0)
	
	if GlobalVariables.current_theme == GlobalVariables.Themes.CHOCOLATE_CHIP:
		var chocolate_chip = load("res://Themes/chocolate_chip_theme.tres")
		control.theme = chocolate_chip
		%BackgroundRect.color = Color(0.017, 0.004, 0.069, 1.0)

func _on_show_active_note_pressed() -> void:
	active_panel_label.visible = true
	
	#Reset score to zero if the player shows note
	current_score = -1
