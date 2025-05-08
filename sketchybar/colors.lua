return {
	black = 0xff1e1e2e, -- #1e1e2e
	white = 0xffcba6f7, -- #cba6f7 #8839ef
	red = 0xffff38ba8, -- #f38ba8
	green = 0xffa6e3a1, -- #a6e3a1
	blue = 0xff89b4fa, -- #89b4fa
	yellow = 0xfffab387, -- #fab387
	orange = 0xfff39660,
	magenta = 0xffb4befe, -- #b4befe
	grey = 0xff6c7086, -- #6c7086
	transparent = 0x00000000,

	bar = {
		bg = 0xf02c2e34,
		border = 0xffe2e2e3,
	},
	popup = {
		bg = 0xc02c2e34,
		border = 0xffe2e2e3,
	},
	bg1 = 0xff363944,
	bg2 = 0xff414550,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
