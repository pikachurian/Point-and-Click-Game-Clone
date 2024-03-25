lines = [
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
];

lineIndex = -1;
text = "Mario.";
goto = noone;

choices = noone
choiceIndex = 0;
choiceYOffset = 16;
choiceYPositions = noone;

function Close()
{
	instance_destroy();
}

function ChangeRoom(_roomIndex)
{
	//
}