lines = noone;

//finishedSetup = false;

dsLines = ds_list_create();

currentLines = noone;
lineIndex = 0;
text = noone;
speaker = noone;
//goto = noone;

choices = noone;
choiceIndex = 0;
choiceYOffset = 16;
choiceYPositions = noone;

//Typewriter effect.
typeTime = 0.1 * game_get_speed(gamespeed_fps);
typeTick = 0;
textToDraw = noone;
textCharactersDrawn = 0;

//Frame.
width = room_width - 1;
height = room_height - y - 1;

//Text.
//textOffsetX = 16;//4;
//textOffsetY = 16;//4;
textX = x + 4;
textY = y + 16;

//Speaker.
speakerX = x + width / 2;//x + 4;
speakerY = y + 4;

drawWidth = width;
drawHeight = height;

centerX = x + width / 2;
centerY = y + height / 2;

borderSize = 2;

alpha = 0;

/*//Is this textbox closing.
closing = false;*/

//Textbox States.
enum TS 
{
	setup,
	main,
	closing
}

state = TS.setup;

function ChangeState(_state)
{
	state = _state;	
}

function Close(_showClosingAnimation = true)
{
	//obj_game_master.ChangeState(GS.main);
	if(text == noone)
		_showClosingAnimation = false;
	ChangeState(TS.closing);
	if(_showClosingAnimation)
		instance_create_depth(x, y, depth, obj_textbox_closing);
	else
		obj_game_master.ChangeState(obj_game_master.previousState);
	instance_destroy();
	show_debug_message("Closed");
}

//Load the current lines array.  This is mostly
//for branching dialogue and the current array is the last item
//added to the dsLines list.
function LoadCurrentLinesAndIndex()
{
	currentLines = dsLines[|ds_list_size(dsLines) - 1].lines;
	lineIndex = dsLines[|ds_list_size(dsLines) - 1].lineIndex;
}

function NextLine()
{
	lineIndex += 1;
	LinesEndCheck();		
}

function ResolveLine()
{
	speaker = noone;
	if(EndLine() == false)
		return;
	
	lineIndex += 1;
	show_debug_message("lineIndex " + string(lineIndex));
	
	LinesEndCheck();
	
	if(state == TS.closing)
		return;
		
	StartLine();
}

//Code performed when a line is first reached.
function StartLine()
{
	//Resolve true/false conditionals.
	if(HasConditional(currentLines[lineIndex]))
	{
		if(CheckConditional(currentLines[lineIndex]) == false)
		{
			NextLine();
			if(state == TS.closing)
				return;
		}
	}

	//Resolve choice.
	if(choices != noone)
	{
		show_debug_message("Made a choice.");
		if(CheckAndAddNewLines(choices[choiceIndex]))
		{
			//
		}else
		{
			//If no new lines are added as a result of the choice, move to the next line.
			NextLine();
		}
	}else//Check if a new lines array needs to be added, and add it if so.
		CheckAndAddNewLines(currentLines[lineIndex]);
		
	if(state == TS.closing)
		return;
		
	UpdateText();
	UpdateSpeaker();
	UpdateChoices();
}

//If false is returned, this event should stop resolving.
function EndLine()
{
	UpdateVariable();
	GotoCheck();
	if(state == TS.closing)
		return false;
	return true;
}

function HasConditional(_struct)
{
	if(struct_exists(_struct, "if_true")) ||
	(struct_exists(_struct, "if_false"))
		return true;
	return false;
}

//Check if a new lines array needs to be added, and add it if so.
//Returns true if new lines were added.
function CheckAndAddNewLines(_struct)
{
	//Add new lines array to dsLines.
	if(struct_exists(_struct, "lines"))
	{	
		AddNewLines(_struct.lines);
		//show_debug_message("lineIndex " + string(lineIndex));
		//show_debug_message("dsLines Size " + string(ds_list_size(dsLines)));
		//show_debug_message("currentLines " + string(currentLines));
		return true;
	}
	return false;
}

//This adds a new lines array to resolve.
function AddNewLines(_lines)
{
	//Save the current line index.
	dsLines[|ds_list_size(dsLines) - 1].lineIndex = lineIndex;
	
	//Add new lines array.
	ds_list_add(dsLines, {lines : _lines, lineIndex : 0});
	LoadCurrentLinesAndIndex();
	choices = noone;
	choiceIndex = 0;
}

//Returns true if the variable matches the goal of the check, true or false.
function CheckConditional(_struct)
{
	//Conditional check.
	var _goal = true;
	var _varName = "if_true";
	if(struct_exists(_struct, "if_false"))
	{
		_goal = false;
		_varName = "if_false";	
	}
		
	var _varToCheck = variable_instance_get(obj_game_master, struct_get(_struct, _varName));
	if(_varToCheck == _goal)
		return true;
	else		
		return false;
}

//Load the current choices if any.
function UpdateChoices()
{
	if(struct_exists(currentLines[lineIndex], "choices"))
	{
		choices = currentLines[lineIndex].choices;
		
		//Add choice text.
		text = array_create(array_length(choices));
		choiceYPositions = array_create(array_length(choices))
		for(var _i = 0; _i < array_length(choices); _i ++)
		{
			if(HasConditional(currentLines[lineIndex].choices[_i]))
			{
				if(CheckConditional(currentLines[lineIndex].choices[_i]))
				{
					text[_i] = choices[_i].text;
					choiceYPositions[_i] = textY + _i * choiceYOffset;
				}else
				{
					text[_i] = "";
					choiceYPositions[_i] = noone;
				}
			}else
			{
				text[_i] = choices[_i].text;
				choiceYPositions[_i] = textY + _i * choiceYOffset;
			}
		}
		
		//If all choices are locked via conditionals, then go to the next line.
		var _resolveNextLine = true;
		var _choiceIndexStart = noone;
		for(var _i = 0; _i < array_length(choices); _i ++)
		{
			if(choiceYPositions[_i] != noone)
			{
				_resolveNextLine = false;
					
				if(_choiceIndexStart == noone)
					_choiceIndexStart = _i;
			}
		}
			
		if(_resolveNextLine)
		{
			ResolveLine();
		}else
			choiceIndex = _choiceIndexStart;
	
		lineIndex -= 1;
	}
}


//Load the current text if any.
function UpdateText()
{
	if(struct_exists(currentLines[lineIndex], "text"))
	{
		//Set draw text.
		text = currentLines[lineIndex].text;
		textToDraw = "";
		if(is_array(text))
			textToDraw = ["", ""];
			
		textCharactersDrawn = 0;
	}
}

//Load the current speaker if any.
function UpdateSpeaker()
{
	if(struct_exists(currentLines[lineIndex], "speaker"))
	{
		//Set draw text.
		speaker = currentLines[lineIndex].speaker;
	}
}


//Update any variables if needed.
function UpdateVariable()
{
	if(struct_exists(currentLines[lineIndex], "set_true"))
	{
		//Set a variable in the game master object to true.
		obj_game_master.SetTrue(currentLines[lineIndex].set_true);
	}
}

//If a goto statement is found.  Go to that room and close this textbox.
function GotoCheck()
{
	if(struct_exists(currentLines[lineIndex], "goto"))
	{
		var _goto = currentLines[lineIndex].goto;
		Close();
		obj_game_master.ChangeRoom(_goto);
	}
	
}

//If the end of a lines array is reached remove that array from dsLines and go to the
//next item in dsLines with the highest index.  Do this until either an array where the
//end hasn't been reached is loaded, or dsLines is empty, in which case close this textbox.
function LinesEndCheck()
{
	while(lineIndex >= array_length(currentLines))
	{
		ds_list_delete(dsLines, ds_list_size(dsLines) - 1);
		if(ds_list_empty(dsLines))
		{
			Close();
			break;
		}
		LoadCurrentLinesAndIndex();
		lineIndex += 1;
	}
}

function UpdateTypewriterEffect()
{
	if(text == noone) || (textToDraw == text)	
		return;
		
	if(typeTick >= typeTime)
	{
		typeTick = 0;
		textCharactersDrawn += 1;
		
		if(is_string(text))
			textToDraw = string_copy(text, 0, textCharactersDrawn);
		else
		{
			for(var _i = 0; _i < array_length(text); _i ++)
			{
				textToDraw[_i] = string_copy(text[_i], 0, min(textCharactersDrawn, string_length(text[_i])));
			}
		}
	}else typeTick += 1;
}
