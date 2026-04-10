extends Node2D
class_name MusicScene

var note_number := GlobalVariables.note_number

var note_pos : int

var note_array: Array[String] = []

signal notes_generated(m_note_array: Array)

@onready var music_box = $BackgroundControl/Sprite2D

func _ready() -> void:
	#new_game()
	GlobalVariables.random_clef_chosen.connect(new_game)
	GlobalVariables.theme_changed.connect(_load_theme)

func new_game():
	note_pos = -300
	note_array.clear()
	#for child in $NotesContainer.find_children("*"):
		#child.queue_free()
	#Call queue free on all existing notes, then create new ones
	get_tree().call_group("notes", "queue_free")
	for x in GlobalVariables.note_number:
		var scene = load("res://Scenes/note.tscn")
		#Add a new note through instantiation and then adding a child of NotesContainer
		var instance = scene.instantiate()
		instance.add_to_group("notes")
		$NotesContainer.add_child(instance)
		
		#Move the note 200 pixels to the right
		instance.position.x = note_pos
		note_pos = note_pos + 200
		
		#Append the note to note_array
		note_array.append(instance.note)
	notes_generated.emit(note_array)
	print(note_array)
	if GlobalVariables.generate_new_notes == true:
		GlobalVariables.generate_new_notes = false
		
func show_note_names():
	if GlobalVariables.show_note_letters == true:
		%KeyNotesText.visible = true
	if GlobalVariables.show_note_letters == false:
		%KeyNotesText.visible = false

func _physics_process(_delta: float) -> void:
	#Generate new notes if this bool is true
	if GlobalVariables.generate_new_notes == true:
		new_game()
	#Change note names to visible if toggled
	show_note_names()

func _load_theme():
	var control = $BackgroundControl
	if GlobalVariables.current_theme == GlobalVariables.Themes.CHOCOLATE_MINT:
		var minty_choc = load("res://Themes/chocoloate_mint_theme.tres")
		control.theme = minty_choc
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.STRAWBERRY:
		var strawberry = load("res://Themes/strawberry_theme.tres")
		control.theme = strawberry
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.DARK_CHOCOLATE:
		var chocolate = load("res://Themes/dark_chocolate_theme.tres")
		control.theme = chocolate
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.LEMON:
		var lemon = load("res://Themes/lemon_theme.tres")
		control.theme = lemon
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.BIRTHDAY_CAKE:
		var birthday = load("res://Themes/birthday_cake_theme.tres")
		control.theme = birthday
	
	if GlobalVariables.current_theme == GlobalVariables.Themes.RED_VELVET:
		var red_velvet = load("res://Themes/red_velvet_theme.tres")
		control.theme = red_velvet
		
	if GlobalVariables.current_theme == GlobalVariables.Themes.CHOCOLATE_CHIP:
		var chocolate_chip = load("res://Themes/chocolate_chip_theme.tres")
		control.theme = chocolate_chip
