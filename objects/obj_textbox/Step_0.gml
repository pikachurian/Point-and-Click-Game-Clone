if(lines != noone)
{
	//When textbox is clicked.
	if(GetInput(INPUT.mousePressed))
	{
		lineIndex += 1;
		choiceIndex = 0;
	
		if(lineIndex >= array_length(lines))
			Close();
		else
		{
			//Choice.
			if(struct_exists(lines[lineIndex], "choices"))
			{
				choices = lines[lineIndex].choices;
			
				//Add choice text.
				text = array_create(array_length(choices));
				choiceYPositions = array_create(array_length(choices))
				for(var _i = 0; _i < array_length(choices); _i ++)
				{
					text[_i] = choices[_i].text;
					choiceYPositions[_i] = y + _i * choiceYOffset;
				}
			
			}else if(struct_exists(lines[lineIndex], "text"))
			{
				//Text.
				text = lines[lineIndex].text;
			}
		}
	
		if(goto != noone)
		{
			ChangeRoom(asset_get_index(goto));
		}
	}
	
	//Update choice selection.
	for(var _i = 0; _i < array_length(choiceYPositions); _i ++)
		if(mouse_y <= choiceYPositions[_i] + font_get_size(fnt_pixel))
		{
			choiceIndex = _i;
			break;
		}
}