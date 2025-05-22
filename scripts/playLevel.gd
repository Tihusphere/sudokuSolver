extends Button

@export var board : Node
@export var level : int

func _on_pressed():
	board.resetBoard(level)
