extends Node2D

var current_location = Global.current_location
#1 = Halstein City, 2 = Wild West, 3 = Galloway Grove, 4 = Happy Hoof Ranch
#5 = Camoolot, 6 = Mt. Aberdeen, 7 = Mt. Ayrshire, 8= Milky Way

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var num_components = 8
	for i in range(1, num_components +1):
		var node_name = "map_component" + str(i) #making node name
		var map_component = get_node(node_name)
		if map_component: #checking if the node exists
			map_component.mouse_has_entered.connect(mouse_entered.bind(node_name))
			map_component.mouse_has_exited.connect(mouse_exited.bind(node_name))
			mouse_exited(node_name)
		if map_component:
			$CowFace.position = get_node("map_component" + str(current_location)).position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func mouse_entered(node_name) -> void:
	get_node(node_name + "/Polygon2D").modulate = Color8(255, 255, 255, 45)
	get_node(node_name +"/Label").modulate = Color8(255, 255, 255, 255)
	$Chime.play()

func mouse_exited(node_name) -> void:
	get_node(node_name + "/Polygon2D").modulate = Color8(255, 255, 255, 0)
	get_node(node_name +"/Label").modulate = Color8(255, 255, 255, 0)
