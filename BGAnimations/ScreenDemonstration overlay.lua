local t = LoadActor(THEME:GetPathB("ScreenGameplay", "overlay"))

t[#t+1] = Def.ActorFrame {
	-- left
	Def.BitmapText {
        Font="Eurostile Extended 32px",
        InitCommand=function(self)
            self:settext("DEMO PLAY"):diffusetopedge(color("#FFFFFF")):diffusebottomedge(color("#12AAFF")):strokecolor(Color.Black)
            :zoomx(0.89):zoomy(1):skewx(-0.25):xy(SCREEN_CENTER_X-300, SCREEN_CENTER_Y * 1.92)
            :diffusealpha(1)
        end,
    },
	
	-- right
    Def.BitmapText {
        Font="Eurostile Extended 32px",
        InitCommand=function(self)
            self:settext("DEMO PLAY"):diffusetopedge(color("#FFFFFF")):diffusebottomedge(color("#12AAFF")):strokecolor(Color.Black)
            :zoomx(0.89):zoomy(1):skewx(-0.25):xy(SCREEN_CENTER_X+300, SCREEN_CENTER_Y * 1.92)
            :diffusealpha(1)
        end,
    }
}

return t
