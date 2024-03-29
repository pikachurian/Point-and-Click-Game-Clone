//Draw frame.
if(text != noone)
{
	draw_set_color(c_white);
	draw_set_alpha(0.5 * alpha);

	var _drawX1 = centerX - drawWidth / 2;
	var _drawX2 = centerX + drawWidth / 2;
	var _drawY1 = centerY - drawHeight / 2;
	var _drawY2 = centerY + drawHeight / 2;

	draw_rectangle(_drawX1, _drawY1, _drawX2, _drawY2, false);

	draw_set_color(c_black);
	draw_set_alpha(0.5* alpha);

	draw_rectangle(_drawX1 + borderSize, _drawY1 + borderSize, _drawX2 - borderSize, _drawY2 - borderSize, false);

	draw_set_alpha(1);
}

//Draw text.
if(text != noone)
{
	draw_set_alpha(1 * alpha);
	draw_set_font(fnt_pixel);
	draw_set_halign(fa_left);
	
	if(is_string(textToDraw))
	{
		draw_set_color(c_white);
		draw_text_ext(textX, textY, textToDraw, font_get_size(fnt_pixel) * 1.5, room_width - 4);//32);
	}else if(is_array(textToDraw))
	{
		//Draw multiple text choices.
		for(var _i = 0; _i < array_length(textToDraw); _i ++)
		{
			draw_set_color(c_white);
			if(_i == choiceIndex)
				draw_set_color(c_orange);
			draw_text_ext(textX, textY + _i * choiceYOffset, textToDraw[_i], font_get_size(fnt_pixel) * 1.5, room_width - 4);
		}
	}
}

//Draw speaker.
if(speaker != noone)
{
	draw_set_font(fnt_pixel);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	//draw_text_ext(x + room_width / 2, y - font_get_size(fnt_pixel) * 1.5, speaker, font_get_size(fnt_pixel) * 1.5, room_width - 32);
	draw_text_ext(speakerX, speakerY, speaker, font_get_size(fnt_pixel) * 1.5, room_width - 32);
}

draw_set_alpha(1);