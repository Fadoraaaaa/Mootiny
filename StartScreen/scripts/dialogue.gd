extends Node2D

@onready var sprite = $Sprite
@onready var label = $Character
@onready var label_text = $RichTextLabel

@export var dialog = [
	#[text, sprite name, character name, character direction, character emotion]
	["Text #1", "Unknown", "Unknown", "", ""], 
	["Text #2", "You", "You", "right", "curious"], 
	["Text 3", "Cocoa_Happy", "Cocoa", "left", "surprise"]]
var page = 0

signal finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	page = 0
	label_text.text = dialog[page][0]
	label_text.visible_characters = 0
	set_process_input(true)
	sprite.stop()
	sprite.play(dialog[page][1])
	label.text = dialog[page][2] 
	#changes character animation (direction & emotion)
	if dialog[page][3] != "":
		get_parent().get_node(dialog[page][2]).is_speaking(dialog[page][3], dialog[page][4])
	
func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if label_text.visible_characters > label_text.get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				label_text.text = dialog[page][0]
				sprite.play(dialog[page][1])
				label.text = dialog[page][2]
				label_text.visible_characters = 0
				if dialog[page][3] != "":
					get_parent().get_node(dialog[page][2]).is_speaking(dialog[page][3], dialog[page][4])
			else:
				visible = false
				emit_signal("finished")
		else:
			label_text.visible_characters = label_text.get_total_character_count()

func change_dialog(input):
	dialog = input
	_ready()

func get_page():
	return page

func _on_timer_timeout():
	label_text.visible_characters += 1
