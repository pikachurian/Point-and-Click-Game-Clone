switch(state)
{
	case GS.setup:
		//Load first room.
		var _rooms = struct_get_names(gameData);
		ChangeRoom(_rooms[0]);
		break;
}