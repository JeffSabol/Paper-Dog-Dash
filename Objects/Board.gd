extends Sprite2D

@onready var level_desc = $LevelDesc
@onready var level_label = $LevelDesc/Label

@export var level_select := ""
@export var level_desc_text := ""
@export var player_body: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = level_desc_text
	level_desc.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(checkPlayerbodyEnter(player_body)):
		goToLevelWithEnter()

func goToLevelWithEnter():
	if(Input.is_action_just_pressed("ui_accept")):
		Global.goto_scene(level_select)

func checkPlayerbodyEnter(_body):
	return _body != null and $Area2D.overlaps_body(_body)

func _on_area_2d_body_entered(body):
	level_desc.show()
	goToLevelWithEnter()

func _on_area_2d_body_exited(body):
	level_desc.hide()
