extends TextureButton

@export var note : String = "C"

@onready var asp = $"../AudioStreamPlayer"

func _process(delta: float) -> void:
	key_pressed()

func _on_pressed() -> void:
	GlobalVariables.player_note = note
	choose_right_audio()
	GlobalVariables.new_note = true
	
	asp.play()
	
func key_pressed() -> void:
	if Input.is_action_just_pressed("A"):
		GlobalVariables.player_note = "A"
		key_pressed_aux()
	if Input.is_action_just_pressed("B"):
		GlobalVariables.player_note = "B"
		key_pressed_aux()
	if Input.is_action_just_pressed("C"):
		GlobalVariables.player_note = "C"
		key_pressed_aux()
	if Input.is_action_just_pressed("D"):
		GlobalVariables.player_note = "D"
		key_pressed_aux()
	if Input.is_action_just_pressed("E"):
		GlobalVariables.player_note = "E"
		key_pressed_aux()
	if Input.is_action_just_pressed("F"):
		GlobalVariables.player_note = "F"
		key_pressed_aux()
	if Input.is_action_just_pressed("G"):
		GlobalVariables.player_note = "G"
		key_pressed_aux()
		
func key_pressed_aux() -> void:
	GlobalVariables.new_note = true
	choose_right_audio()

func choose_right_audio():
	#Play the right audio depending on which key has been pressed
	match note:
		"C":
			asp.stream = load("res://Sound/C4.mp3")
		"D":
			asp.stream = load("res://Sound/D4.mp3")
		"E":
			asp.stream = load("res://Sound/E4.mp3")
		"F":
			asp.stream = load("res://Sound/F4.mp3")
		"G":
			asp.stream = load("res://Sound/G4.mp3")
		"A":
			asp.stream = load("res://Sound/A4.mp3")
		"B":
			asp.stream = load("res://Sound/B4.mp3")
		_:
			asp.stream = load("res://Sound/C4.mp3")
