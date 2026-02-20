extends Node2D

@export var label: Label
@export var polygon: Polygon2D
var type: WheelConfig.wedge_type
var amount: int = 0
var color: Color = Color.WHITE
var id: int = 0
@onready var radius: float = WheelConfig.radius

# store angles for use later
var start_angle: float = 0.0
var end_angle: float = 0.0

func setup_wedge(_start_angle: float, _end_angle: float, steps: int = 10) -> void:
	start_angle = _start_angle
	end_angle = _end_angle

	# Build wedge polygon
	var points = PackedVector2Array([Vector2.ZERO])
	for j in range(steps + 1):
		var t = j / float(steps)
		var angle = lerp(start_angle, end_angle, t)
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	polygon.polygon = points
	polygon.color = color

func update_label() -> void:
	# Set label text
	if type == WheelConfig.wedge_type.BANKRUPT:
		label.text = "Fallit"                
	elif type == WheelConfig.wedge_type.LOSE_TURN:
		label.text = "Tabt Tur"
	elif type == WheelConfig.wedge_type.JOKER:
		label.text = "Joker"
	else:
		label.text =str(amount) + " KR"

	# Set label rotation
	
	var font_ref = label.get_theme_font("font")
	var font_height = font_ref.get_height() if font_ref else 0.0
	var text_size = Vector2(0,0)
	if font_ref:
		text_size = font_ref.get_string_size(label.text)
		# debug
		# var rect_pos = label.position
		# var rect_size = text_size
		# draw_rect(Rect2(rect_pos, rect_size), Color(0,1,0,0.2))  # semi-transparent green
	
	var mid_angle = (start_angle + end_angle) / 2
	
	var label_radius = clamp(radius * 0.6, font_height * 0.5, radius - font_height * 0.5)
	var pos = Vector2(cos(mid_angle), sin(mid_angle)) * label_radius	
	var offset = Vector2(text_size.x * 0.5, font_height*0.5)
	var vertical_tweak = 8
	offset += Vector2(0, vertical_tweak)
	
	offset = offset.rotated(mid_angle)

	# var normalized_angle = fposmod(mid_angle, TAU)
	# if normalized_angle > PI/2 and normalized_angle < 3*PI/2:
	# 	label.rotation = mid_angle + PI
	# 	offset.x = -offset.x  # mirror horizontally
	label.position = pos - offset	
	
	label.rotation = mid_angle
	



# func _draw():
# 	# Draw a radial debug line to the middle of the wedge
# 	var mid_angle = (start_angle + end_angle) / 2
# 	var line_length = radius
# 	var line_end = Vector2(cos(mid_angle), sin(mid_angle)) * line_length
# 	draw_line(Vector2.ZERO, line_end, Color.WHITE, 2)  # red line
