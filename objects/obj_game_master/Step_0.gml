switch(state)
{
	case GS.preSetup:
		if(GetInput(INPUT.mousePressed))
			ChangeState(GS.setup);
		break;
		
	case GS.setup:
		//Load first room.
		var _rooms = struct_get_names(gameData);
		ChangeRoom("rm_in_bed");
		audio_play_sound(sng_background, 10, true);
		break;
		
	case GS.main:
		//Use parallax.
		with(obj_background)
		{
			x = lerp(x, mouse_x * -0.1, 0.5);
			y = lerp(y, mouse_y * -0.1, 0.5);
		}
		
		with(obj_interactable)
		{
			x = lerp(x, mouse_x * -0.1, 0.5);
			y = lerp(y, mouse_y * -0.1, 0.5);
		}

		break;
}
//Restart.
if(keyboard_check_pressed(vk_alt))
	game_restart();
	
//Toggle fullscreen.
if(keyboard_check_pressed(vk_f4))
	window_set_fullscreen(!window_get_fullscreen());