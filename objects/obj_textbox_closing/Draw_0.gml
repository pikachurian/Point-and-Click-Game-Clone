draw_set_color(c_white);
draw_set_alpha(0.5 * alpha);

var _drawX1 = centerX - drawWidth / 2;
var _drawX2 = centerX + drawWidth / 2;
var _drawY1 = centerY - drawHeight / 2;
var _drawY2 = centerY + drawHeight / 2;

draw_rectangle(_drawX1, _drawY1, _drawX2, _drawY2, false);

draw_set_color(c_black);
draw_set_alpha(0.5 * alpha);

draw_rectangle(_drawX1 + borderSize, _drawY1 + borderSize, _drawX2 - borderSize, _drawY2 - borderSize, false);

draw_set_alpha(1);