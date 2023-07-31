extends GameScene

@export var hud_manager:HUDManager

@export var world_parent:Node3D

func setup_managers():
	super.setup_managers()
	hud_manager.prepare(self)

func ready():
	var world = SoundSpacePlus.worlds.items.front()
	var selected_world = settings.skin.background.world
	var ids = SoundSpacePlus.worlds.get_ids()
	if ids.has(selected_world):
		world = SoundSpacePlus.worlds.get_by_id(selected_world)
	if world != null:
		var world_node = world.load_world()
		world_node.set_meta("game",self)
		world_parent.add_child(world_node)

	player.connect("failed",Callable(self,"finish").bind(true))

	sync_manager.call_deferred("start",-(settings.approach.time+1.5) * sync_manager.playback_speed)

var ended:bool = false
func finish(failed:bool=false):
	if ended: return
	ended = true
	print("failed: %s" % failed)
	if failed:
		print("fail animation")
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sync_manager,"playback_speed",0,2)
		tween.play()
		await tween.finished
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
