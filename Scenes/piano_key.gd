extends TextureButton

@export var note : String = "C"

@onready var asp = $"../AudioStreamPlayer"


func _on_pressed() -> void:
	GlobalVariables.player_note = note
	choose_right_audio()
	GlobalVariables.new_note = true
	
	asp.play()

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
