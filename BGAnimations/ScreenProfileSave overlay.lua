return Def.ActorFrame {
	
	Def.Sprite{
		Name="Icon",
		Texture=THEME:GetPathG("", "Logo/Parts/iw_logo_3"),
		InitCommand=function(self) self:Center():diffusealpha(0):rotationz(45):zoom(0.5) end,
		OnCommand=function(self) self:croptop(1):sleep(0.25):diffusealpha(1):linear(0.4):croptop(0):linear(0.4):cropbottom(1) end,
	},
	
    LoadActor("LoadingIcon")..{
        InitCommand=function(self)
            self:GetChild("Text"):settext("SAVE PROFILE DATA...")
        end
    },
	
    Def.Actor {
        BeginCommand=function(self)
            if SCREENMAN:GetTopScreen():HaveProfileToSave() then self:sleep(1) end
            self:queuecommand("Load")
        end,
        -- eval summary prio
        LoadCommand=function()
            local nextScreen = CustomBranch.AfterProfileSave()
            SCREENMAN:GetTopScreen():SetNextScreenName(nextScreen)
            SCREENMAN:GetTopScreen():Continue()
        end
    }

}
