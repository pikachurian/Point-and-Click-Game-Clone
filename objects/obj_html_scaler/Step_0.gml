if(browser_width != width) || (browser_height != height)
{
	width = min(baseWidth, browser_width);
	height = min(baseHeight, browser_height);
	ScaleCanvas(baseWidth, baseHeight, width, height, true);
}