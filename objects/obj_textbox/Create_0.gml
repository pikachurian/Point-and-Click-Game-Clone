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
]