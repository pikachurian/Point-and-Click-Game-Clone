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

function Close()
{
	obj_game_master.ChangeState(GS.main);
	instance_destroy();
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

function ResolveLine()
{
	//If goto was set to a room, change rooms.
	if(goto != noone)
	{
		obj_game_master.ChangeRoom(goto);
		Close();
	}else if(lineIndex >= array_length(currentLines))
	{
		ds_list_delete(dsLines, ds_list_size(dsLines) - 1);
		show_debug_message("AAAAAAAAAAAAAAAAAABBBBBBBB");
		show_debug_message(ds_list_size(dsLines));
		if(ds_list_empty(dsLines))
			Close();
		else
		{
			LoadCurrentLinesAndIndex();
			show_debug_message(lineIndex);
			ResolveLine();
			return;
		}
	}else
	{
		//Choice.
		if(struct_exists(currentLines[lineIndex], "choices"))
		{
			choices = currentLines[lineIndex].choices;
		
			//Add choice text.
			text = array_create(array_length(choices));
			choiceYPositions = array_create(array_length(choices))
			for(var _i = 0; _i < array_length(choices); _i ++)
			{
				text[_i] = choices[_i].text;
				choiceYPositions[_i] = y + _i * choiceYOffset;
			}
			
		}else if(choices != noone)
		{
			//Resolve choice.
			/*//Save current line index.
			dsLines[|ds_list_size(dsLines) - 1].lineIndex = lineIndex;
			ds_list_add(dsLines, {lines : choices[choiceIndex].lines, lineIndex : 0});
			LoadCurrentLinesAndIndex();
			choices = noone;
			choiceIndex = 0;*/
			//lineIndex is incremented in AddNewLines, so this offsets it only for
			//branching lines.  This seems random, but it works.
			lineIndex -= 1;
			AddNewLines(choices[choiceIndex].lines);
			ResolveLine();
		}
		
		if(struct_exists(currentLines[lineIndex], "text"))
		{
			//Set draw text.
			text = currentLines[lineIndex].text;
		}
		
		if(struct_exists(currentLines[lineIndex], "goto"))
		{
			//Set goto room.
			goto = currentLines[lineIndex].goto;
		}
		
		if(struct_exists(currentLines[lineIndex], "set_true"))
		{
			//Set a variable in the game master object to true.
			obj_game_master.SetTrue(currentLines[lineIndex].set_true);
		}
		
		if(struct_exists(currentLines[lineIndex], "if_true"))
		{
			//Conditional check.
			var _varToCheck = variable_instance_get(obj_game_master, currentLines[lineIndex].if_true);
			if(_varToCheck == true)
			{
				AddNewLines(currentLines[lineIndex].lines);
				ResolveLine();
			}else
			{
				lineIndex += 1;
				ResolveLine();
			}
		}
	}
	
	//show_debug_message(choiceIndex);
}

//This adds a new lines array to resolve.
function AddNewLines(_lines)
{
	lineIndex += 1;
	//Save current line index.
	dsLines[|ds_list_size(dsLines) - 1].lineIndex = lineIndex;
	
	//Add new lines array.
	ds_list_add(dsLines, {lines : _lines, lineIndex : 0});
	LoadCurrentLinesAndIndex();
	choices = noone;
	choiceIndex = 0;
}

//ResolveLine();
