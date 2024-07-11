extends Node3D

var hp: float = 100.0
var MAX_HP: int = 100.0

var stamina: float = 100.0
var MAX_STAMINA: int = 100.0
var STAMINA_REGEN: float = 20.0
var STAMINA_DRAIN: float = 15.0
var can_sprint: bool = true

var mana: float = 75.0
var MAX_MANA: int = 75.0

func _process(delta):
	if Input.is_action_pressed("mov_sprint") and can_sprint:
		stamina -= STAMINA_DRAIN * delta
	else:
		if stamina < MAX_STAMINA:
			stamina += STAMINA_REGEN * delta
			
func take_damage(damage: float):
	hp -= damage

