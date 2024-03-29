switch(state)
{
	case GS.setup:
		//Load first room.
		var _rooms = struct_get_names(gameData);
		ChangeRoom("rm_in_bed");
		break;
}

//Restart.
if(keyboard_check_pressed(vk_alt))
	game_restart();
	
//Toggle fullscreen.
if(keyboard_check_pressed(vk_f4))
	window_set_fullscreen(!window_get_fullscreen());