extends Node2D

@export var label: Label
@export var polygon: Polygon2D
var amount: int = 0
var color: Color = Color.WHITE
var id: int = 0
var radius: float = 100.0

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
    if amount == -1:
        label.text = "Bankrupt"
    elif amount == 0:
        label.text = "Lose Turn"
    else:
        label.text = "$" + str(amount)

    # Get font
    var font_ref = label.get_theme_font("font")
    var font_height = font_ref.get_height() if font_ref else 0.0
    var text_size = Vector2(0,0)
    if font_ref:
        text_size = font_ref.get_string_size(label.text)

    # Mid angle of wedge
    var mid_angle = (start_angle + end_angle) / 2

    # Radial position along the spoke
    var label_radius = clamp(radius * 0.6, font_height * 0.5, radius - font_height * 0.5)
    var pos = Vector2(cos(mid_angle), sin(mid_angle)) * label_radius

    # Offset by half text size to center the label along the radial line
    pos -= Vector2(text_size.x * 0.5, font_height*0.5)

    label.position = pos

    # Rotate text along the spoke
    var normalized_angle = fposmod(mid_angle, TAU)
    if normalized_angle > PI/2 and normalized_angle < 3*PI/2:
        label.rotation = mid_angle + PI
    else:
        label.rotation = mid_angle

