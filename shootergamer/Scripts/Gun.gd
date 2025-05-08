extends Node2D

var bullet = preload("res://Scenes/Bullet.tscn")
#var shootSound = preload("res://Sounds/puffsound.mp3")

var fire_select = false
var semifire = false
var autofire = true
var canshoot = true
var empty = false

var ammo : int
@export var maxAmmo : int
@export var damage : int

@onready var bulletpos = $Bulletpos
@onready var shootspeed = $Shootspeed
@onready var refill_timer = $RefilTimer
@onready var ammoText = $"../../CanvasLayer/Panel/PlayerStats/AmmoBar/Ammo"
@onready var ammoSprite = $"../../CanvasLayer/Panel/PlayerStats/AmmoBar/Sprite2D"

var explosionRadius : int = 48

var emptySprite = preload("res://Sprites/WaterGunEmpty.png")
var fullSprite = preload("res://Sprites/WaterGun.png")

var refill_rate = 0

func _on_shootspeed_timeout() -> void:
	canshoot = true
	
func shoot():
	if !empty:
		if canshoot:
			var bulletins = bullet.instantiate()
			bulletins.position = bulletpos.global_position
			get_tree().root.add_child(bulletins)
			bulletins.rotation = rotation
			bulletins.get_child(3).get_child(0).shape.radius = explosionRadius
			#print(bulletins.get_child(3).get_child(0).name, " + ", bulletins.get_child(3).get_child(0).shape.radius)
			shootspeed.start()
			canshoot = false
			ammo -= 1
			#SoundUtils.play_sound_at_position(shootSound, global_position, get_parent().get_parent())

func _process(delta):
	look_at(get_global_mouse_position())
	ammoText.text = str(ammo) + "/" + str(maxAmmo)
	
	$"../../CanvasLayer/Panel/PlayerStats/AmmoBar".max_value = maxAmmo
	$"../../CanvasLayer/Panel/PlayerStats/AmmoBar".value = ammo
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	if ammo <= 0:
		empty = true
		$Sprite2D.texture = emptySprite
	elif ammo > 0:
		empty = false
		$Sprite2D.texture = fullSprite
	
	if Input.is_action_just_pressed("fireselect"):
		print("fireselect pressed")
		if fire_select == semifire:
			$"../../CanvasLayer/Panel/PlayerStats/AmmoBar/Sprite2D".frame = 1
			fire_select = autofire
		elif fire_select == autofire:
			$"../../CanvasLayer/Panel/PlayerStats/AmmoBar/Sprite2D".frame = 0
			fire_select = semifire

func _physics_process(delta):
	if Input.is_action_just_pressed("click") and fire_select == semifire:
		shoot()
		canshoot = false
	if Input.is_action_pressed("click") and fire_select == autofire:
		shoot()


func _on_refil_timer_timeout() -> void:
	if ammo < maxAmmo:
		ammo += refill_rate
		ammo = min(ammo, maxAmmo)
