extends Node2D

@onready var sublevel_menu := $SublevelMenu
var current_location = Global.current_location
#1 = Halstein City, 2 = Wild West, 3 = Galloway Grove, 4 = Happy Hoof Ranch
#5 = Camoolot, 6 = Mt. Aberdeen, 7 = Mt. Ayrshire, 8= Milky Way

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sublevel_menu.visible = false
	var num_components = 8
	for i in range(1, num_components +1):
		var node_name = "map_component" + str(i) #making node name
		var map_component = get_node(node_name)
		if map_component: #checking if the node exists
			map_component.mouse_has_entered.connect(mouse_entered.bind(node_name))
			map_component.mouse_has_exited.connect(mouse_exited.bind(node_name))
			map_component.sublevels_requested.connect(on_sublevels_requested)
			mouse_exited(node_name)
		if map_component:
			$CowFace.position = get_node("map_component" + str(current_location)).position

func mouse_entered(node_name) -> void:
	get_node(node_name + "/Polygon2D").modulate = Color8(255, 255, 255, 45)
	get_node(node_name +"/Label").modulate = Color8(255, 255, 255, 255)
	$Chime.play()

func mouse_exited(node_name) -> void:
	get_node(node_name + "/Polygon2D").modulate = Color8(255, 255, 255, 0)
	get_node(node_name +"/Label").modulate = Color8(255, 255, 255, 0)

func on_sublevels_requested(options: Dictionary) -> void:
	print("THIS HAS BEEN CALLED")
	sublevel_menu.visible = true
	for child in sublevel_menu.get_children():
		child.queue_free()
	
	for name in options.keys():
		var scene_path = options[name]
		var btn = Button.new()
		btn.text = name
		btn.add_theme_font_override("font", preload("res://assets/retro.ttf"))
		btn.add_theme_font_size_override("font_size", 10)
	
		btn.pressed.connect(func():
			sublevel_menu.visible = false
			get_tree().change_scene_to_file(scene_path))
		sublevel_menu.add_child(btn)
