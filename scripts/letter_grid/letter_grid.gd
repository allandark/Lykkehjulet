extends Control
@export var letter_rows : Array[HBoxContainer] = []
@export var letter_scene : PackedScene  
@export var vbox : VBoxContainer
var letter_nodes : Array = []

# Number of letters per row
var row_counts = [11, 14, 14, 11]

# Fixed size for each letter
var letter_size = Vector2(32, 32) # width x height in pixels


func _ready() -> void:
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	for i in range(letter_rows.size()):
		var row = letter_rows[i]
		
		# Center the children horizontally
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

		# Array to store letters for this row
		var row_letters : Array = []

		for j in range(row_counts[i]):
			var letter_instance = letter_scene.instantiate() as Control 
			
			letter_instance.set_letter(str(j + 1))		
			letter_instance.set_hidden(true)	
			letter_instance.set_unused(true)	

			letter_instance.custom_minimum_size  = letter_size			
			letter_instance.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			letter_instance.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			
			row.add_child(letter_instance)
			row_letters.append(letter_instance)
			letter_instance.pressed.connect(_on_letter_pressed.bind(j, i))
		
		letter_nodes.append(row_letters)
	



func _on_letter_pressed(i: int, j: int) -> void:
		print("Clicked box: %d, %d" % [i, j])
		var current_box = letter_nodes[j][i]
		if current_box.is_hidden() and not current_box.is_unused():
			current_box.set_hidden(false)
