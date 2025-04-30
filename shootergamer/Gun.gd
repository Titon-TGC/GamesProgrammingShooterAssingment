extends Node2D

var bullet = preload("res://Bullet.tscn")

var fire_select = false
var semifire = false
var autofire = true

var canshoot = true

@onready var bulletpos = $Bulletpos
@onready var shootspeed = $Shootspeed

func _on_shootspeed_timeout() -> void:
	canshoot = true
	
func shoot():
	if canshoot:
		var bulletins = bullet.instantiate()
		bulletins.position = bulletpos.global_position
		get_tree().root.add_child(bulletins)
		bulletins.rotation = rotation
		shootspeed.start()
		canshoot = false

func _process(delta):
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	if Input.is_action_just_pressed("fireselect"):
		print("fireselect pressed")
		if fire_select == semifire:
			fire_select = autofire
		elif fire_select == autofire:
			fire_select = semifire

func _physics_process(delta):
	if Input.is_action_just_pressed("click") and fire_select == semifire:
		shoot()
		canshoot = false
	if Input.is_action_pressed("click") and fire_select == autofire:
		shoot()
