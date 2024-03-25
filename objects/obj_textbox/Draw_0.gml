//Draw text.
if(is_string(text))
{
	draw_set_font(fnt_pixel);
	draw_set_color(c_white);
	draw_text(x, y, text);
}