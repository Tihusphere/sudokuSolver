extends Button

@export var board : Node


func _on_pressed():
	board.resetGame()
