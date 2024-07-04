extends AudioStreamPlayer3D

@export var looping: bool = true

func _ready():
	if looping:
		play()

func _on_finished():
	if looping:
		play()
