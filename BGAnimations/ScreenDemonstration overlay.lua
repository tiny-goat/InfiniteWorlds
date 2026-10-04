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
    },
	
	-- Song Info
	Def.ActorFrame {
	
		InitCommand=function(self)
        if GAMESTATE:GetCurrentSong() then
				local Song = GAMESTATE:GetCurrentSong()

				local TitleText = Song:GetDisplayFullTitle()
				if TitleText == "" then TitleText = "Unknown" end

				local AuthorText = Song:GetDisplayArtist()
				if AuthorText == "" then AuthorText = "Unknown" end

				self:GetChild("Title"):settext(TitleText)
				self:GetChild("Artist"):settext("Artist: " .. AuthorText)
				
			else
				self:GetChild("Title"):settext("")
				self:GetChild("Artist"):settext("")
			end
		end,
		
		OnCommand=function(self)
			self:y(180):diffusealpha(0):sleep(0.3):smooth(0.6):diffusealpha(1) end,
	
		Def.Quad {
			InitCommand=function(self)
				self:diffuse(Color.Black):diffusealpha(0.9):zoomto(200,110):fadeleft(0.1):faderight(0.1):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 20):sleep(0.3):linear(0.3):zoomto(370,110) end
		},
		
		Def.BitmapText {
			Font="Eurostile Extended 32px",
			InitCommand=function(self)
				self:settext("SONG INFO"):strokecolor(Color.Black):zoom(0.6):diffuse(color(1,1,1,1)):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-15) end
		},

		Def.BitmapText {
			Name="Title",
			Font="Inter Medium 32px",
			InitCommand=function(self)
				self:zoom(0.6):diffuse(color("#00CCEE")):maxwidth(450):x(SCREEN_CENTER_X):diffusealpha(0):y(SCREEN_CENTER_Y+40):sleep(0.4):smooth(0.5):diffusealpha(1):y(SCREEN_CENTER_Y+30) end
		},
		
		Def.BitmapText {
			Name="Artist",
			Font="Inter Medium 32px",
			InitCommand=function(self)
				self:zoom(0.5):diffuse(color("#CCEE00")):maxwidth(450):x(SCREEN_CENTER_X):diffusealpha(0):y(SCREEN_CENTER_Y+40):sleep(0.4):smooth(0.5):diffusealpha(1):y(SCREEN_CENTER_Y+55) end
		}
	}
}

return t
