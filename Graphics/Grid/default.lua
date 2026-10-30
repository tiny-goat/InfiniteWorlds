return Def.ActorFrame {
    Name="GridFrame",
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoom(2)
	end,
	
    Def.Sprite {
        Name="Lines",
        Texture="_carbonline",
        InitCommand=function(self)
            self:xy(0,0)
            :texcoordvelocity(0, 0.1)
            :diffuse(color("#000000"))
			:fadetop(1)
            :fadebottom(1)
			
			if IsAnniversary() then 
				self:queuecommand("Rainbow") end
		end,
		
		ScreenChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
        RefreshCommand=function(self)
			local GridReposition = (SCREENMAN:GetTopScreen():GetName() == "ScreenTitleMenu" 
			or SCREENMAN:GetTopScreen():GetName() == "ScreenLogo" 
			or SCREENMAN:GetTopScreen():GetName() == "ScreenTitleJoin")
            
			if GridReposition then
				self:diffusealpha(0):rotationz(45):linear(1):diffusealpha(0.3)
			else
				self:diffusealpha(0):rotationz(180):linear(1):diffusealpha(0.3)
			end
		end,
		
        RainbowCommand=function(self) self:rainbow():effectperiod(10) end
    }
}
