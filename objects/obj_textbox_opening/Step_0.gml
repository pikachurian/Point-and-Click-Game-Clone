drawWidth = lerp(drawWidth, width, 0.1);
drawHeight = lerp(drawHeight, height, 0.1);

//Create real textbox.
if(width - drawWidth <= 4) && (height- drawHeight <= 4)
{
	var _textbox = instance_create_depth(x, y, depth, obj_textbox);
	_textbox.lines = lines;
	instance_destroy();
}