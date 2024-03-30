switch(state)
{
	case GS.preSetup:
		draw_set_font(fnt_pixel);
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		draw_text(room_width / 2, room_height / 2, "CLICK TO START");
		draw_set_halign(fa_left);
		break;
}