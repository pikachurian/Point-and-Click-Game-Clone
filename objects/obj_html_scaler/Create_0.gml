function ScaleCanvas(_baseWidth, _baseHeight, _currentWidth, _currentHeight, _center)
{
	if(os_browser == browser_not_a_browser)
		return;
	var _aspect = (_baseWidth / _baseHeight);
	
	if((_currentWidth / _aspect) > _currentHeight)
	{
		window_set_size((_currentHeight * _aspect), _currentHeight);
	}else
	{
		window_set_size(_currentWidth, (_currentWidth / _aspect));
	}
	
	if(_center)
	{
		window_center();
	}
	
	view_wport[0] = min(window_get_width(), _baseWidth);
	view_hport[0] = min(window_get_height(), _baseHeight);
	surface_resize(application_surface, view_wport[0], view_hport[0]);
}

baseWidth = 640;
baseHeight = 360;
width = baseWidth;
height = baseHeight;

ScaleCanvas(baseWidth, baseHeight, width, height, true);

