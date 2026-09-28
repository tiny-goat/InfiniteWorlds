return Def.ActorFrame {
		-- kpump "Please Insert Coin" overlay
		OnCommand=function(self)
			self:diffusealpha(1)
		end,
		
		Def.BitmapText{
			Name="Text1",
			Font="Eurostile Extended 32px",
			Text="PLEASE INSERT COIN",
			InitCommand=function(self) self:zoom(0.65):strokecolor(color("#000000FF")):diffuse(color("FFFFFF")):queuecommand("Zoom") end,
			ZoomCommand=function(self) self:zoom(0.7):linear(0.45):zoom(0.65):linear(0.45):zoom(0.7):queuecommand("Zoom") end,
		},
		
		Def.BitmapText{
			Name="Text2",
			Font="Eurostile Extended 32px",
			Text="PLEASE INSERT COIN",
			InitCommand=function(self) self:zoom(0.6):diffuse(color("FFFFFF")):queuecommand("Pulse") end,
			PulseCommand=function(self) self:diffusealpha(1):zoom(0.7):easeoutexpo(0.9):zoom(0.76):diffusealpha(0):queuecommand("Pulse") end
		}
}