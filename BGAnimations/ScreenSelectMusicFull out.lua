return Def.ActorFrame {
    OnCommand=function(self)
	-- close enough to kpump ig
        self:GetChild("FirstFade"):diffusealpha(0)
		self:GetChild("ChartStats"):diffusealpha(0)
    end,
    
    StartTransitioningCommand=function(self)
        if SCREENMAN:GetTopScreen():GetNextScreenName() == "ScreenStageInformation" then
        self:GetChild("FirstFade"):sleep(0.3):easeoutexpo(0.5):diffusealpha(1):sleep(1.8)
		
	    self:GetChild("ChartStats"):sleep(1):diffusealpha(1)

	    self:GetChild("SFX"):play()
        else
            self:sleep(0)
        end
    end,

	OffCommand=function(s)
		s:queuecommand("Dim")
	end,
	
	DimCommand=function(s) SOUND:StopMusic() end,

    Def.Sound {
        Name="SFX",
        File=THEME:GetPathS("", "stage_warp")
    },

    Def.Quad {
        Name="FirstFade",
		InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end
    },
	
    LoadActor("SongTransition") .. {
        Name="ChartStats"
    }


}
