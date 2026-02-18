extends Control
@export var letter_rows : Array[HBoxContainer] = []
@export var letter_scene : PackedScene  
var letter_nodes : Array = []

# Number of letters per row
var row_counts = [11, 14, 14, 11]

# Fixed size for each letter
var letter_size = Vector2(32, 32) # width x height in pixels

func _ready() -> void:
	for i in range(letter_rows.size()):
		var row = letter_rows[i]
		
		# Center the children horizontally
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.size_flags_vertical = Control.SIZE_EXPAND_FILL

		# Array to store letters for this row
		var row_letters : Array = []

		for j in range(row_counts[i]):
			var letter_instance = letter_scene.instantiate() as Control  # must be a Control node
			
			letter_instance.set_letter(str(j + 1))		
			letter_instance.set_hidden(true)	
			letter_instance.set_unused(false)	

			letter_instance.custom_minimum_size  = letter_size
			letter_instance.size_flags_horizontal = Control.SIZE_FILL
			letter_instance.size_flags_vertical = Control.SIZE_FILL

			# var scale_x = letter_size.x / letter_instance.rect_size.x
			# var scale_y = letter_size.y / letter_instance.rect_size.y
			# letter_instance.rect_scale = Vector2(scale_x, scale_y)
			
			row.add_child(letter_instance)
			row_letters.append(letter_instance)
			letter_instance.pressed.connect(_on_letter_pressed.bind(j, i))
		
		letter_nodes.append(row_letters)


func _on_letter_pressed(i: int, j: int) -> void:
		print("Clicked box: %d, %d" % [i, j])
		var current_box = letter_nodes[j][i]
		if current_box.is_hidden() and not current_box.is_unused():
			current_box.set_hidden(false)
