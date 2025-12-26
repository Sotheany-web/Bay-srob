extends Control

@onready var main_buttons: VBoxContainer = $main_buttons
@onready var settings: Panel = $Settings

@onready var player = get_node("/root/Main/GameplayRoot/Main_Character")
@onready var environment = get_node("/root/Main/GameplayRoot/Environment")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # show cursor when menu loads
	show_main_menu()
	player.visible = false
	environment.visible = false
	print(main_buttons)

func show_main_menu():
	main_buttons.visible = true
	settings.visible = false

func _on_start_pressed():
	print("Start pressed")
	self.visible = false
	player.visible = true
	environment.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock cursor for gameplay

func _on_howtoplay_pressed() -> void:
	print("How to play pressed")

func _on_setting_pressed() -> void:
	print("Setting pressed")
	main_buttons.visible = false
	settings.visible = true

func _on_quit_pressed() -> void:
	print("Quit pressed")
	get_tree().quit()

func _on_back_settings_pressed():
	show_main_menu()

func _on_BackToMenu_pressed():
	self.visible = true
	player.visible = false
	environment.visible = false
