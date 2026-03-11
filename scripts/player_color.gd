class_name PlayerColor

static var colors: Array[Color] = [
	Color.BLUE, 
	Color.RED,
	Color.GREEN,
	Color.YELLOW,
	Color.AQUA,
	Color.FUCHSIA,	
	Color.MAROON,
	Color.NAVY_BLUE,
	Color.OLIVE,
	Color.TEAL,
	Color.PURPLE
]

static var labels: Array[String] = [
	"Blå",
	"Rød",
	"Grøn",
	"Gul",
	"Turkis",
	"Magenta",	
	"Kastanje",
	"Marineblå",
	"Oliven",
	"Blågrøn",
	"Lilla"
]

var color_id: int
var taken: bool

func _init(_color_id: int):
  color_id = _color_id
  taken = false
  

func get_label() -> String:
  return labels[color_id]

func get_color() -> Color:
  return colors[color_id]

static func get_string(color: Color) -> String:
  match color:
    Color.BLUE:
      return "blue"
    Color.RED:
      return "red"
    Color.GREEN:
      return "green"
    Color.YELLOW:
      return "yellow"
    Color.AQUA:
      return "aqua"
    Color.FUCHSIA:
      return "fuchsia"
    Color.MAROON:
      return "maroon"
    Color.NAVY_BLUE:
      return "navy"
    Color.OLIVE:
      return "olive"
    Color.PURPLE:
      return "purple"
  
  return ""