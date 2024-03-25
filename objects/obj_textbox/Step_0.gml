if(currentLines != noone)
{
	//When textbox is clicked.
	if(GetInput(INPUT.mousePressed))
	{
		lineIndex += 1;		
		ResolveLine();
	}

	
	//Update choice selection.
	for(var _i = 0; _i < array_length(choiceYPositions); _i ++)
		if(mouse_y <= choiceYPositions[_i] + font_get_size(fnt_pixel))
		{
			choiceIndex = _i;
			break;
		}
		
}