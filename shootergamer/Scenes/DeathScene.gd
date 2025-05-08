extends Control

@onready var winSound = preload("res://Sounds/losing-horn-313723.mp3")

func _ready():
	SoundUtils.play_sound_at_position(winSound, global_position, get_parent())
	$VBoxContainer/StatsContainer/TreesFreed.text = "Trees Freed: " + str(FinalStats.treesFreed)
	$VBoxContainer/StatsContainer/WavesSurvived.text = "Waves Survived: " + str(FinalStats.wavesSurvived)
	$VBoxContainer/StatsContainer/UpgradesPurchaed.text = "Upgrades Bought: " + str(FinalStats.upgradesPurchased)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
