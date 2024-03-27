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
	_string = string_delete(_string, 1, 4);
	_string = "spr_" + _string;
	switch(_string)
	{
		//Bedroom sprites.
		case "obj_car": _sprite = spr_car; break;
		case "obj_apple": _sprite = spr_apple; break;
		case "obj_key": _sprite = spr_key; break;
		case "obj_door": _sprite = spr_door; break;
		
		//Kitchen sprites.
		case "obj_fish": _sprite = spr_fish; break;
	}
	_sprite = asset_get_index(_string);
	sprite_index = _sprite;
}