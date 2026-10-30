return Def.ActorFrame {
    OnCommand=function(self)
	-- FINALLY perfected the kpump song decide screen
        self:GetChild("Fade"):diffusealpha(0)
    end,
    
    StartTransitioningCommand=function(self)
        if SCREENMAN:GetTopScreen():GetNextScreenName() == "ScreenStageInformation" then
        self:GetChild("Fade"):sleep(0.3):easeoutexpo(0.5):diffusealpha(1)
	    self:GetChild("SFX"):playcommand("Play")
        else
            self:sleep(0)
        end
    end,

	OffCommand=function(s)
		s:queuecommand("Dim")
	end,
	
	DimCommand=function(s) SOUND:StopMusic() end,
	
	-- the stage decide SFX now plays thru the screens, no more cutoff yay
    Def.ActorFrame {
        Name="SFX",
		PlayCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("", "stage_warp"))
		end,
    },

    Def.Quad {
        Name="Fade",
		InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end
    },
	
}
