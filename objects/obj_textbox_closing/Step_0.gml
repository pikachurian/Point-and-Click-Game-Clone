alpha = lerp(alpha, 0, 0.1);
//Delete this object and return control to the player.
if(alpha <= 0.01)
{
	obj_game_master.ChangeState(GS.main);
	instance_destroy();
}