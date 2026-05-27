extends TextureButton

@export var note : String = "C"

@onready var asp = $"../AudioStreamPlayer"

func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func _process(delta: float) -> void:
	key_pressed()
	
func _input(input_event):
	if input_event is InputEventMIDI:
		_midi_pressed(input_event)

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
	note = GlobalVariables.player_note
	GlobalVariables.new_note = true
	
	choose_right_audio()
	
	asp.play()
	
func _midi_pressed(midi_event):
	#TODO: Add MIDI functionality
	print(midi_event)
	
	var all_notes : Dictionary = {59 : "B", 57: "A", 55 : "G", 53: "F", 52: "E", 50: "D", 48: "C",
		#Starting middle C
		60 : "C", 62 : "D", 64: "E", 65: "F", 67: "G", 69: "A", 71: "B", 72: "C",}
	
	#If note is in dictionary, store in midi_note. Otherwise, return and don't cause an error
	if all_notes.has(midi_event.pitch):
		if midi_event.message == 9: 
			var midi_note = all_notes[midi_event.pitch]
			print("Pitch ", midi_note)
			# Code to play audio and move to next note
			note = midi_note
			GlobalVariables.player_note = note
			GlobalVariables.new_note = true
			choose_right_audio()
			asp.play()
			
		# Do nothing unless a new note is being pressed
		elif midi_event.message == 8:
			return
			
	else:
		return

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
