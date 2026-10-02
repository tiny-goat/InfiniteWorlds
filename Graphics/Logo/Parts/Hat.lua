return Def.ActorFrame {
    Def.Sprite {
        Name="PartyHat",
        Texture="PartyHat",
        InitCommand=function(self)
            self:xy(210, -320):rotationz(40):diffusealpha(0)
        end,
        OnCommand=function(self)
            self:sleep(0.7)
            :easeoutexpo(0.9)
            :diffusealpha(1)
            :y(-280):wag():effectmagnitude(0,0,3):effectperiod(2)
        end
    },

	Def.ActorFrame {
	
		InitCommand=function(self)
				self:y(500)
				:diffusealpha(0)
		end,
			
		OnCommand=function(self)
				self:sleep(1)
				:easeoutexpo(0.9)
				:diffusealpha(1)
				:y(250)
		end,
			
		Def.BitmapText {
			Font="Eurostile Extended 32px",
			InitCommand=function(self)
				self:settext(string.format("%d YEAR ANNIVERSARY!", (Year() - 2023))):strokecolor(color("#000000AA")) end,
		},
		
		Def.BitmapText {
			Font="Eurostile Extended 32px",
			InitCommand=function(self)
				self:settext(string.format("%d YEAR ANNIVERSARY!", (Year() - 2023)))
				:diffusealpha(0)
			end,
			OnCommand=function(self)
				self:queuecommand("Pulse")
			end,
			PulseCommand=function(self) self:diffusealpha(1):zoom(1):easeoutexpo(0.5286):zoom(1.1):diffusealpha(0):queuecommand("Pulse") end
		}
	
	}

}
