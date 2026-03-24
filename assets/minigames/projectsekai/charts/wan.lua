local function t (n) return n * 0.361 * 2 + 0.361 end

return {
	key = "wan",
	title = "Wan!",
	artists = {"Tanger", "Glitch Cat"},
	chart = {
		{x=1,y=0,time=t(0),width=2,type=1},
		{x=7,y=0,time=t(0),width=2,type=1},
		{x=3,y=0,time=t(1),width=2,type=1},
		{x=5,y=0,time=t(2),width=2,type=1},
		{x=7,y=0,time=t(3),width=2,type=1},
		{x=1,y=0,time=t(3),width=2,type=1},
		{x=5,y=0,time=t(4),width=2,type=1},
		{x=3,y=0,time=t(5),width=2,type=1},
		{x=1,y=0,time=t(6),width=2,type=1},
		{x=3,y=0,time=t(7),width=2,type=1},
		{x=5,y=0,time=t(7),width=2,type=1},
		{x=5,y=0,time=t(8),width=2,type=1},
		{x=7,y=0,time=t(9),width=2,type=1},
		{x=5,y=0,time=t(10),width=2,type=1},
		{x=3,y=0,time=t(11),width=2,type=1},
		{x=5,y=0,time=t(11),width=2,type=1}
	}
}