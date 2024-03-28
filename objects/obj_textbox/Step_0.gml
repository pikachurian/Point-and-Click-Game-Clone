switch(state)
{
	case TS.setup:
		ChangeState(TS.main);
		ds_list_add(dsLines, {lines : lines, lineIndex : 0});
		currentLines = dsLines[|0].lines;
		lineIndex = 0;
		StartLine();
		break;
		
	case TS.main:
		//When textbox is clicked.
		if(GetInput(INPUT.mousePressed))
		{	
			ResolveLine();
		}

	
		//Update choice selection.
		if(choices != noone)
		{
			for(var _i = 0; _i < array_length(choiceYPositions); _i ++)
				if(choiceYPositions[_i] != noone) && (mouse_y <= choiceYPositions[_i] + font_get_size(fnt_pixel))
				{
					choiceIndex = _i;
					break;
				}
		}
		break;
		
	case TS.closing:
		break;
}

/*if(finishedSetup == false) && (lines != noone)
{
	finishedSetup = true;
	ds_list_add(dsLines, {lines : lines, lineIndex : 0});
	currentLines = dsLines[|0].lines;
	lineIndex = 0;
	StartLine();
	exit;
}

if(currentLines != noone)
{
	//When textbox is clicked.
	if(GetInput(INPUT.mousePressed))
	{	
		ResolveLine();
	}

	
	//Update choice selection.
	for(var _i = 0; _i < array_length(choiceYPositions); _i ++)
		if(mouse_y <= choiceYPositions[_i] + font_get_size(fnt_pixel))
		{
			choiceIndex = _i;
			break;
		}
		
}*/