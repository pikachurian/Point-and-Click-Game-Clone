lines = noone;

function LoadStructData(_struct, _structName)
{
	ChangeSprite(_structName);
	lines = _struct.lines;
	show_debug_message(_structName + " | " + string(_struct));
}

function ChangeSprite(_string)
{
	var _sprite = spr_test;
	_string = string_delete(_string, 1, 3);
	_string = "spr" + _string;
	_sprite = asset_get_index(_string);
	sprite_index = _sprite;
	
	switch(sprite_index)
	{
		case spr_key:
			depth += 50;
			break;
			
		case spr_door:
			if(obj_background.sprite_index == spr_kitchen)
				sprite_index = spr_door_kitchen;
			break;
	}
}