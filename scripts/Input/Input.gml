// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Input(){

}

enum INPUT 
{
	mouseOver,
	clicked,
	mousePressed
}

function GetInput(_inputEnum)
{
	switch(_inputEnum)
	{
		case INPUT.mousePressed:
			return mouse_check_button_pressed(mb_left);
			break;
			
		case INPUT.mouseOver:
			return position_meeting(mouse_x, mouse_y, id);
			break;
			
		case INPUT.clicked:
			if(GetInput(INPUT.mouseOver)) && (GetInput(INPUT.mousePressed))
				return true;
			return false
			break;
	}
}