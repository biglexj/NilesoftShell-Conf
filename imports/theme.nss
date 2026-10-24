theme
{	
	name = "modern"
	dark = auto
	view = view.large

	background
	{
		color = auto
		opacity = 80
		effect = 3
	}
	
	image.align = 2
	font.size = 20

	item
	{
		opacity = 100
		prefix = 1

		text
		{
			normal = #1392a5ff
			select = #29CCD0
			normal-disabled = #0F758580
			select-disabled = #29CCD080
		}

		back
		{
			select = #29CCD01E
			select-disabled = #29CCD00D
		}
		
		padding
		{
			left = 5
			top = 0
			right = 5
			bottom = 0
		}
	}
	
	border
	{
		enabled = true
		size = 1
		color = #29CCD0
		opacity = 100
		radius = 8
	}

	separator
	{
		size = 1
		color = #29CCD033
	}

	symbol
	{
		normal = #0F7585
		select = #29CCD0
		normal-disabled = #0F758560
		select-disabled = #29CCD060
	}

	image
	{
		enabled = true
		color = [@if(theme.islight, #0F7585, #FBFDFF), #29CCD0, @if(theme.islight, #CBD5E1, #0F7585)]
	}
}
