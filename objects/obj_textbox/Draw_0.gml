//Draw text.
if(is_string(text))
{
	draw_set_font(fnt_pixel);
	draw_set_color(c_white);
	draw_text(x, y, text);
}else if(is_array(text))
{
	//Draw multiple text choices.
	draw_set_font(fnt_pixel);
	for(var _i = 0; _i < array_length(text); _i ++)
	{
		draw_set_color(c_white);
		if(_i == choiceIndex)
			draw_set_color(c_orange);
		draw_text(x, y + _i * choiceYOffset, text[_i]);
	}
}