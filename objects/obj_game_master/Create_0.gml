gameData = global.gameData;
show_debug_message("AAAAAAAAAAAAAAAAAAAAAA");
show_debug_message(struct_get_names(gameData));

//Game State.
enum GS 
{
	inTextbox,
	main,
	setup
}

state = GS.setup;

currentRoomString = noone;


function ChangeRoom(_roomString)
{
	ChangeState(GS.main);
	show_debug_message(_roomString);
	var _roomStruct = struct_get(gameData, _roomString);
	//Change background sprite.
	var _backgroundSprite = spr_background_0;
	switch(_roomString)
	{
		case "rm_in_bed": _backgroundSprite = spr_background_0; break;
		case "rm_bedroom": _backgroundSprite = spr_background_1; break;
	}
	obj_background.sprite_index = _backgroundSprite;
	
	//Create interactables.
	if(struct_exists(_roomStruct, "interactables"))
	{
		var _interactableNames = struct_get_names(_roomStruct.interactables);
		for(var _i = 0; _i < array_length(_interactableNames); _i ++)
		{
			var _inst = instance_create_layer(0, 0, "Instances", obj_interactable);
			_inst.LoadStructData(struct_get(_roomStruct.interactables, _interactableNames[_i]), _interactableNames[_i]);
		}
	}
	
	//Create a textbox with lines.
	if(struct_exists(_roomStruct, "lines"))
	{
		ChangeState(GS.inTextbox);
		var _textbox = instance_create_layer(0, 96, "Textbox", obj_textbox);
		_textbox.lines = _roomStruct.lines;
	}
}

function ChangeState(_state)
{
	state = _state;
}