if(GetInput(INPUT.clicked)) && (obj_game_master.state == GS.main)
{
	//show_debug_message("Clicked");
	//show_debug_message("is array" + string(is_array(lines)));
	//show_debug_message(lines);
	obj_game_master.interactableTarget = id;
	CreateTextbox(lines);
}