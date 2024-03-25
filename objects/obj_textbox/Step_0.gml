if(lines != noone)
{
	if(lineIndex >= array_length(lines))
		Close();
	else
	{
		//Choice.
		if(struct_exists(lines[lineIndex], "choices"))
		{
			
		}else if(struct_exists(lines[lineIndex], "text"))
		{
			//Text.
			text = lines[lineIndex].text;
		}
	}
}

//When textbox is clicked.
if(GetInput(INPUT.clicked))
{
	lineIndex += 1;
	if(goto != noone)
	{
		ChangeRoom(asset_get_index(goto));
	}
}