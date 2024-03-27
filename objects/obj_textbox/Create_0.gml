lines = noone;/*[
	{text : "Huh?"},
	{
		choices : [
			{
				text : "Where am I?",
				lines : [
					{text : "A bedroom, it looks like."}
				]
			},
			{
				text : "Who am I?",
				lines : [
					{text : "I have absolutely no idea."}
				]
			}
		]
	},
	{
		text : "I need to get out of here.",
		goto : "rm_bedroom"
	}
];*/

finishedSetup = false;

dsLines = ds_list_create();

//ds_list_add(dsLines, {lines : lines, lineIndex : 0});

currentLines = noone//dsLines[|0].lines;
lineIndex = 0;
text = noone;//"Mario.";
goto = noone;

choices = noone;
choiceIndex = 0;
choiceYOffset = 16;
choiceYPositions = noone;

closing = false;

function Close()
{
	obj_game_master.ChangeState(GS.main);
	closing = true;
	instance_destroy();
	show_debug_message("Closed");
}

function ChangeRoom(_roomIndex)
{
	//
}

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
	if(EndLine() == false)
		return;
	
	lineIndex += 1;
	show_debug_message("lineIndex " + string(lineIndex));
	
	LinesEndCheck();
	
	if(closing)
		return;
		
	StartLine();
}

function StartLine()
{
	if(HasConditional(currentLines[lineIndex]))
	{
		if(CheckConditional(currentLines[lineIndex]) == false)
		{
			/*lineIndex += 1;
			LinesEndCheck();
			
			if(closing)
				return;*/
			NextLine();
			if(closing)
				return;
		}
	}

	if(choices != noone)
	{
		if(CheckAndAddNewLines(choices[choiceIndex]))
		{
			dsLines[|ds_list_size(dsLines) - 2].lineIndex -= 1;
		}
	}else
		CheckAndAddNewLines(currentLines[lineIndex]);
		
	UpdateText();
	UpdateChoices();
}

//If false is returned, this event should stop resolving.
function EndLine()
{
	UpdateVariable();
	GotoCheck();
	if(closing)
		return false;
	//if(ResolveChoice())
	//	return false;
}

//Returns true if a choice was resolved.
function ResolveChoice()
{
	if(choices != noone)
	{
		
		//show_debug_message("Made a choice.")
		CheckAndAddNewLines(choices[choiceIndex]);
		choices = noone;
		return true;
	}
	return false;
}

function ResolveLineSkibidi()
{
	if(HasConditional(currentLines[lineIndex])) //Conditional Check
		{
			if(CheckConditional(currentLines[lineIndex]) == false)
			{
				lineIndex += 1;		
				ResolveLine();
				show_debug_message("Conditional False");
				return;
			}
		}
		
		//Choice.
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
					show_debug_message("has conditional");
					if(CheckConditional(currentLines[lineIndex].choices[_i]))
					{
						text[_i] = choices[_i].text;
						choiceYPositions[_i] = y + _i * choiceYOffset;
					}else
					{
						text[_i] = "";
						choiceYPositions[_i] = noone;
						show_debug_message("ERRORERROR");
					}
				}else
				{
					text[_i] = choices[_i].text;
					choiceYPositions[_i] = y + _i * choiceYOffset;
				}
			}
			
			//If all choices are locked, then go to the next line.
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
				//lineIndex += 1;
				ResolveLine();
			}else
				choiceIndex = _choiceIndexStart;
			
		}else if(choices != noone)
		{
			//Resolve choice.
			/*//Save current line index.
			dsLines[|ds_list_size(dsLines) - 1].lineIndex = lineIndex;
			ds_list_add(dsLines, {lines : choices[choiceIndex].lines, lineIndex : 0});
			LoadCurrentLinesAndIndex();
			choices = noone;
			choiceIndex = 0;*/
			
			/*//lineIndex is incremented in AddNewLines, so this offsets it only for
			//branching lines.  This seems random, but it works.
			if(struct_exists(choices[choiceIndex], "lines"))
			{
				lineIndex -= 1;
				AddNewLines(choices[choiceIndex].lines);
				ResolveLine();
			}*/
			CheckAndAddNewLines(choices[choiceIndex]);
		}else
			CheckAndAddNewLines(currentLines[lineIndex]);
		
		if(struct_exists(currentLines[lineIndex], "set_true"))
		{
			//Set a variable in the game master object to true.
			obj_game_master.SetTrue(currentLines[lineIndex].set_true);
		}
		
	
	//show_debug_message(choiceIndex);
}

//This adds a new lines array to resolve.
function AddNewLines(_lines)
{
	//if(lineIndex == 0)
	//	lineIndex += 1;
	//lineIndex += 1;
	//Save current line index.
	dsLines[|ds_list_size(dsLines) - 1].lineIndex = lineIndex;
	
	//Add new lines array.
	ds_list_add(dsLines, {lines : _lines, lineIndex : 0});
	LoadCurrentLinesAndIndex();
	choices = noone;
	choiceIndex = 0;
}

function HasConditional(_struct)
{
	if(struct_exists(_struct, "if_true")) ||
	(struct_exists(_struct, "if_false"))
		return true;
	return false;
}

//Returns true if new lines were added.
function CheckAndAddNewLines(_struct)
{
	//Add new lines array to dsLines.
	if(struct_exists(_struct, "lines"))
	{	
		//lineIndex is incremented in AddNewLines, so this offsets it only for
		//branching lines.  This seems random, but it works.
		//lineIndex -= 1;
		AddNewLines(_struct.lines);
		/*show_debug_message("lineIndex " + string(lineIndex));
		show_debug_message("dsLines Size " + string(ds_list_size(dsLines)));
		show_debug_message("currentLines " + string(currentLines));*/
		//StartLine();
		return true;
	}
	return false;
}

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
					show_debug_message("has conditional");
					if(CheckConditional(currentLines[lineIndex].choices[_i]))
					{
						text[_i] = choices[_i].text;
						choiceYPositions[_i] = y + _i * choiceYOffset;
					}else
					{
						text[_i] = "";
						choiceYPositions[_i] = noone;
						show_debug_message("ERRORERROR");
					}
				}else
				{
					text[_i] = choices[_i].text;
					choiceYPositions[_i] = y + _i * choiceYOffset;
				}
			}
			
			//If all choices are locked, then go to the next line.
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
				//lineIndex += 1;
				ResolveLine();
			}else
				choiceIndex = _choiceIndexStart;
			
		}
}

function UpdateGoto()
{
		if(struct_exists(currentLines[lineIndex], "goto"))
		{
			//Set goto room.
			goto = currentLines[lineIndex].goto;
		}
}

function UpdateText()
{
	if(struct_exists(currentLines[lineIndex], "text"))
	{
		//Set draw text.
		text = currentLines[lineIndex].text;
	}
}

function UpdateVariable()
{
	if(struct_exists(currentLines[lineIndex], "set_true"))
	{
		//Set a variable in the game master object to true.
		obj_game_master.SetTrue(currentLines[lineIndex].set_true);
	}
}

function GotoCheck()
{
	/*if(goto != noone) //If goto was set to a room, change rooms.
	{
		Close();
		obj_game_master.ChangeRoom(goto);
	}*/
	if(struct_exists(currentLines[lineIndex], "goto"))
	{
		var _goto = currentLines[lineIndex].goto;
		Close();
		obj_game_master.ChangeRoom(_goto);
	}
	
}

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
	
	/*if(lineIndex >= array_length(currentLines))
	{
		ds_list_delete(dsLines, ds_list_size(dsLines) - 1);
		//show_debug_message("AAAAAAAAAAAAAAAAAABBBBBBBB");
		//show_debug_message(ds_list_size(dsLines));
		if(ds_list_empty(dsLines))
			Close();
		else
		{
			LoadCurrentLinesAndIndex();
			LinesEndCheck();
			//NextLine();
			//show_debug_message(lineIndex);
			//ResolveLine();
		}
		return;
	}*/
}

//ResolveLine();
