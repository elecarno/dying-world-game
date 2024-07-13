extends Node3D

var time : float = 0.0
var full_day_seconds = 86400 # 24 * 3600

var day_color : Color = Color(0.5176, 0.5529, 0.6078, 1)
var night_color : Color = Color(0.0392, 0.0471, 0.0588, 1)

@export var timescale : float = 72

@onready var sun : DirectionalLight3D = get_node("sun")
@onready var moon : DirectionalLight3D = get_node("moon")
@onready var env : WorldEnvironment = get_node("env")

func get_interpolation_factor(time_of_day: float) -> float:
	return clamp(time_of_day / full_day_seconds, 0, 1)

func get_fog_color(time_of_day: float) -> Color:
	var factor = get_interpolation_factor(time_of_day)
	return day_color.lerp(night_color, factor)

func _process(delta):	
	time += (timescale * delta)
	if time >= full_day_seconds:
		time = 0
		
	sun.rotation_degrees.x = -(time / full_day_seconds) * 360 # + 90 for night, - 90 for noon
	env.environment.set_fog_light_color(get_fog_color(time))

