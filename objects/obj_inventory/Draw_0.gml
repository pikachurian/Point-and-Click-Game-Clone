draw_set_alpha(0.75);

if(obj_game_master.has_apple)
	draw_sprite(spr_item_apple, 0, 0, 0);
	
if(obj_game_master.has_key)
	draw_sprite(spr_item_key, 0, 0, 0);
	
if(obj_game_master.has_fish)
	draw_sprite(spr_item_fish, 0, 0, 0);
	
draw_set_alpha(1);