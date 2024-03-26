switch(state)
{
	case GS.setup:
		//Load first room.
		var _rooms = struct_get_names(gameData);
		ChangeRoom("rm_in_bed");
		break;
}