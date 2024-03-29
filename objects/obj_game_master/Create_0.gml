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
	setup,
	paused
}

state = GS.setup;
previousState = state;

currentRoomString = noone;

//The ID of the current instance being interacted with.
interactableTarget = noone;

has_apple = false;
has_key = false;
met_voice = false;
has_fish = false;

//Parallax.
backgroundXScale = 1.15;//1.25;
backgroundYScale = 1.15;//1.25;

function ChangeRoom(_roomString)
{
	//Fade effect.
	obj_fade.alpha = 1;
	
	//Delete existing interactables.
	with(obj_interactable)
		instance_destroy();
		
	with(obj_textbox_closing)
		instance_destroy();
		
	show_debug_message(_roomString);
	var _roomStruct = struct_get(gameData, _roomString);
	
	ChangeState(GS.main);
	
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
	
	
	obj_background.image_xscale = backgroundXScale;
	obj_background.image_yscale = backgroundYScale;
	
	with(obj_interactable)
	{
		image_xscale = other.backgroundXScale;
		image_yscale = other.backgroundYScale;
	}
	
	//Check the free_move struct variable to see if the player is paused.
	if(struct_exists(_roomStruct, "free_move"))
	{
		if(_roomStruct.free_move == false)
		{
			ChangeState(GS.paused);	
			obj_background.image_xscale = 1;
			obj_background.image_yscale = 1;
			obj_background.x = 0;
			obj_background.y = 0;
			with(obj_interactable)
			{
				image_xscale = 0;
				image_yscale = 0;
				x = 0;
				y = 0;
			}
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

//Set a variable to true.
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
	
	audio_play_sound(sfx_item_get, 15, false);
}