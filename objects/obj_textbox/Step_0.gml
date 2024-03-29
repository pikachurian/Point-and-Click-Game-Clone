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
	
		//Update typewriter effect.
		UpdateTypewriterEffect();
		
		//When textbox is clicked.
		if(GetInput(INPUT.mousePressed))
		{	
			var _resolvedLine = false;
			if(text == noone)//Resolve the line of there is no text.
			{
				ResolveLine();
				_resolvedLine = true;
			}
			else if(is_string(text)) && (text == textToDraw)//Resolve the line if all the text is drawn.
			{
				ResolveLine();
				_resolvedLine = true;
			}else if(is_array(text))
			{
				var _doResolveLine = true;
				for(var _i = 0; _i < array_length(text); _i ++)
				{
					if(text[_i] != textToDraw[_i])
						_doResolveLine = false;
				}
				
				if(_doResolveLine)
				{
					ResolveLine();
					_resolvedLine = true;
				}
			}
			
			if(_resolvedLine == false)
			{
				if(text != noone)
					textToDraw = text;
			}
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