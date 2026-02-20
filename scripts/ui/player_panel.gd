extends Node

@export var players : Array[Node]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players[0].set_balance(100)
	players[0].set_player_name("Player1")
	players[0].set_active(true)

	players[1].set_balance(10000)
	players[1].set_player_name("Player2")
	players[1].set_active(false)

	players[2].set_balance(1500)
	players[2].set_player_name("Player3")
	players[2].set_active(false)

	players[3].set_balance(0)
	players[3].set_player_name("Player4")
	players[3].set_active(false)


