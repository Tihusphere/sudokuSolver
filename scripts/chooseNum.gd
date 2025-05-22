extends Button

@export var board : Node

func _on_pressed():
	board.setValue(int(self.text))
