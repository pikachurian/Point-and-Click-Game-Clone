gameData = noone;//global.gameData;

//Load JSON.
if(file_exists("mystery.json"))
{
	var _buffer = buffer_load("mystery.json");
	var _string = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	
	gameData = json_parse(_string);
}

//Game State.
enum GS 
{
	inTextbox,
	main,
	setup
}

state = GS.setup;

currentRoomString = noone;

//The ID of the current instance being interacted with.
interactableTarget = noone;

has_apple = false;
has_key = false;
met_voice = false;
has_fish = false;

function ChangeRoom(_roomString)
{
	//Fade effect.
	obj_fade.alpha = 1;
	
	//Delete existing interactables.
	with(obj_interactable)
		instance_destroy();
		
	with(obj_textbox_closing)
		instance_destroy();
		
	
	ChangeState(GS.main);
	show_debug_message(_roomString);
	var _roomStruct = struct_get(gameData, _roomString);
	
	//Change background sprite.
	var _backgroundSprite = spr_background_0;
	var _backgroundString = string_delete(_roomString, 1, 2);
	_backgroundString = "spr" + _backgroundString;

	obj_background.sprite_index = asset_get_index(_backgroundString);
	
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
		CreateTextbox(_roomStruct.lines);
	}
}

function ChangeState(_state)
{
	state = _state;
}

function SetTrue(_varString)
{
	variable_instance_set(id, _varString, true);
	show_debug_message(_varString + " set to " + string(variable_instance_get(id, _varString)));
	
	switch(_varString)
	{
		//Delete this interactables when they are collected.
		case "has_apple":
		case "has_key":
		case "has_fish":
			if(instance_exists(interactableTarget))
				instance_destroy(interactableTarget);
			break;
	}
}