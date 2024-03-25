// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Input(){

}

enum INPUT 
{
	mouseOver,
	clicked,
}

function GetInput(_inputEnum)
{
	switch(_inputEnum)
	{
		case INPUT.mouseOver:
			return position_meeting(mouse_x, mouse_y, id);
			break;
			
		case INPUT.clicked:
			if(GetInput(INPUT.mouseOver)) && (mouse_check_button_pressed(mb_left))
				return true;
			return false
			break;
	}
}