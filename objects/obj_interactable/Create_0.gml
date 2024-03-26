
function LoadStructData(_struct, _structName)
{
	ChangeSprite(_structName);
	show_debug_message(_structName)
}

function ChangeSprite(_string)
{
	var _sprite = spr_test;
	switch(_string)
	{
		case "obj_car": _sprite = spr_apple; break;
		case "obj_apple": _sprite = spr_car; break;
		case "obj_key": _sprite = spr_key; break;
		case "obj_door": _sprite = spr_door; break;
	}
	sprite_index = _sprite;
}