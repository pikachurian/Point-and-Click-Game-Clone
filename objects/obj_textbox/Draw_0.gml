//Draw text.
if(text != noone)
{
	draw_set_font(fnt_pixel);
	draw_set_halign(fa_left);
	
	if(is_string(textToDraw))
	{
		draw_set_color(c_white);
		draw_text_ext(x, y, textToDraw, font_get_size(fnt_pixel) * 1.5, room_width - 32);
	}else if(is_array(textToDraw))
	{
		//Draw multiple text choices.
		for(var _i = 0; _i < array_length(textToDraw); _i ++)
		{
			draw_set_color(c_white);
			if(_i == choiceIndex)
				draw_set_color(c_orange);
			draw_text_ext(x, y + _i * choiceYOffset, textToDraw[_i], font_get_size(fnt_pixel) * 1.5, room_width - 32);
		}
	}
}

//Draw speaker.
if(speaker != noone)
{
	draw_set_font(fnt_pixel);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text_ext(x + room_width / 2, y - font_get_size(fnt_pixel) * 1.5, speaker, font_get_size(fnt_pixel) * 1.5, room_width - 32);
}