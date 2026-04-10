extends Sprite2D

@export var note_name : String
@export var note : String

var difficulty : String = "VeryEasyNotes/"
var clef : String = "None/"
#Mickey_offset is the offset between the first and second generated bars on high (off-scale) notes
var mickey_offset : int = 150

var flipped_note = preload("res://Assets/music-note-2.png")

func _ready() -> void:
	print_notes()
	
func _physics_process(_delta: float) -> void:
	# If the generate_new_notes variable is true, queue_free and print new notes
	#if(GlobalVariables.generate_new_notes == true):
		#queue_free()
		#print_notes()
	pass
	
func print_notes() -> void:
	#Pass in all the values from the resources
	var new_random = random_note()
	
	#Create file path with randomly chosen file from the right difficulty and clef
	var file_name : String = "res://Resources/Notes/" + difficulty + clef + new_random
	
	#Load the music note in as noteType
	var noteType: MusicNote = load(file_name)
	
	#Change all variables to noteType variables
	note_name = noteType.noteName
	note = noteType.note
	texture = noteType.texture
	
	#Scale textures in and set global position to y_pos
	scale = scale * 0.25
	position.y = ((noteType.y_pos * -18) + -60)
	
	#Flip the note if it is higher than y_pos 6
	if noteType.y_pos >= 6:
		texture = flipped_note
		position.y = ((noteType.y_pos * -18) + 50)
	
	#TODO: Swap in note with a line on and below, to reflect notes off of the chart
	#Odd numbers are on the line
	if noteType.y_pos == 11 or noteType.y_pos == 13 or noteType.y_pos == 15 or noteType.y_pos == 17:
		var bar = load("res://Scenes/note_bar.tscn")
		var instance = bar.instantiate()
		add_child(instance)
		instance.position = position
		instance.position.y -= 47
		if noteType.y_pos > 12:
			var mickey : int = (noteType.y_pos -10) / 2
			for i in mickey:
				print("mickey" + str(mickey))
				var instance2 = bar.instantiate()
				add_child(instance2)
				instance2.position = instance.position
				instance2.position.y += mickey_offset
		
	#Even numbers are off the line
	if noteType.y_pos == 12 or noteType.y_pos == 14 or noteType.y_pos == 16 or noteType.y_pos == 18:
		var bar = load("res://Scenes/note_bar.tscn")
		var instance = bar.instantiate()
		add_child(instance)
		instance.position = position
		instance.position.y += 47
		#Add extra lines for notes off the bar
		if noteType.y_pos > 12:
			var mickey : int = (noteType.y_pos -10) / 2
			for i in mickey:
				var instance2 = bar.instantiate()
				add_child(instance2)
				instance2.position = instance.position
				instance2.position.y += mickey_offset
		
	#For low numbers now, off the line
	if noteType.y_pos == -1 or noteType.y_pos == -3 or noteType.y_pos == -5 or noteType.y_pos == -7:
		var bar = load("res://Scenes/note_bar.tscn")
		var instance = bar.instantiate()
		add_child(instance)
		instance.position = position
		instance.position.y += 230
		if noteType.y_pos <= -2:
			var mickey : int = (noteType.y_pos * -1) / 2
			for i in mickey:
				var instance2 = bar.instantiate()
				add_child(instance2)
				instance2.position = instance.position
				instance2.position.y -= mickey_offset

		
	#Even numbers on the line
	if noteType.y_pos == -2 or noteType.y_pos == -4 or noteType.y_pos == -6 or noteType.y_pos == -8:
		var bar = load("res://Scenes/note_bar.tscn")
		var instance = bar.instantiate()
		add_child(instance)
		instance.position = position
		instance.position.y += 140

	# Tween animation to spawn in notes, go from alpha zero to fully visible
	modulate.a = 0.0
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(self, "scale:y", 0.25, 0.2).from(0.5)

		
func set_difficulty():
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.VERY_EASY:
		difficulty = "VeryEasyNotes/"
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.EASY:
		difficulty = "EasyNotes/"
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.HARD:
		difficulty = "HardNotes/"
	if GlobalVariables.current_difficulty == GlobalVariables.Difficulty.LANDMARK:
		difficulty = "LandmarkNotes/"
		
func set_clef():
	# Recursively run the function if a clef has not been chosen yet
	if GlobalVariables.current_clef == GlobalVariables.Clefs.NONE:
		print("waiting...")
		set_clef()
	#Change the clef resource folder to pull from based on current clef
	if GlobalVariables.current_clef == GlobalVariables.Clefs.TREBLE:
		clef = "Treble/"
	if GlobalVariables.current_clef == GlobalVariables.Clefs.BASS:
		#set resource_files to BASS folder
		clef = "Bass/"
		
func random_note():
	set_difficulty()
	set_clef()
	
	#Access all the Note files
	var resource_files = DirAccess.get_files_at("res://Resources/Notes/" + difficulty + clef)
	#Select a random note file
	var randy = resource_files[randi() % resource_files.size()]
	return randy
