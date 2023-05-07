extends "res://menus/map_pause/InteractiveMap.gd"

func _on_chunk_button_pressed(chunk_index:Vector2, button):
	_on_chunk_button_focus(chunk_index)
	if not enable_fast_travel:
		return 
	
	var level = WorldSystem.get_level_map()
	if ( not level or not level.enable_fast_travel ) and not Debug.dev_mode:
		if( UserSettings.show_timer ):
			if info_panel.current_warp_features.size() > 0:
				GlobalMessageDialog.clear_state()
				yield (GlobalMessageDialog.show_message("UI_MAP_FAST_TRAVEL_DISALLOWED"), "completed")
			button.grab_focus()
			return 
	
	Controls.set_disabled(map_chunk_container, true)
	
	for warp in info_panel.current_warp_features:
		
		if warp.warp_effect == 1 and not SaveState.has_ability("train_travel"):
			continue
		
		if yield (MenuHelper.confirm(Loc.trf("UI_MAP_FAST_TRAVEL_CONFIRM", {
			"location":warp.title
		})), "completed"):
			
			var args = {}
			SceneManager.transition = SceneManager.TransitionKind.TRANSITION_STATIC
			if warp.warp_effect == 1:
				SceneManager.loading_audio.stream = preload("res://sfx/world/train/train_depart.wav")
				SceneManager.loading_graphic = preload("res://sprites/ui/train.png")
			
			WorldSystem.reset_flags()
			MenuHelper.clear()
			WorldSystem.warp(warp.warp_target_scene, warp.warp_target_chunk, warp.warp_target_name, args, Bind.new(SaveState.mapping, "update_position", [map_metadata, info_panel.chunk_metadata]))
			warp.emit_signal("warping")
			return 
		
	Controls.set_disabled(map_chunk_container, false)
	button.grab_focus()
