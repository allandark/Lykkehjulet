extends Node2D

@export var wedge_scene: PackedScene
@export var circle_node: PackedScene
@onready var radius: float = WheelConfig.radius
@onready var wedges_data: Array = WheelConfig.wedges
var wedge_nodes: Array = []

func create_wedges() -> void:
	# Clear old wedges
	for child in wedge_nodes:
		child.queue_free()
	wedge_nodes.clear()

	var segments = wedges_data.size()
	if segments == 0:
		return

	var angle_step = TAU / segments
	for i in range(segments):
		var data = wedges_data[i]

		var start_angle = -i * angle_step
		var end_angle = -(i + 1) * angle_step

		var wedge_node = wedge_scene.instantiate()
		add_child(wedge_node)
		wedge_node.amount = data["amount"]
		wedge_node.color = data["color"]
		wedge_node.type = data["type"]
		wedge_node.id = i
		wedge_node.radius = radius
		wedge_node.z_index = i
		wedge_node.setup_wedge(start_angle, end_angle)
		wedge_node.update_label()
		wedge_nodes.append(wedge_node)

	var center_node = circle_node.instantiate()
	center_node.position = Vector2.ZERO  
	center_node.z_index = segments + 1   
	add_child(center_node)
