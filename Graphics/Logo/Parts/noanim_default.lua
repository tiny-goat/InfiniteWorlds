return Def.ActorFrame {

    LoadActor("AnimatedLoop")..{
        Name="Loop",
        OnCommand=function(self)
            self:zoom(0.95):queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:GetChild("PlainLoop"):diffusealpha(1)
            self:GetChild("ArrowPatternTop")
			self:GetChild("ArrowPatternBottom")
        end
    },

    Def.Sprite {
        Texture="iw_logo_4",
        Name="Text_Mask",
        InitCommand=function(self)
            self:MaskSource():zoom(0.9)
        end
    },

    Def.Quad {
        Name="Text_Shine",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:zoomto(70, 900)
            :diffuse(1,1,1,0.8)
            :skewx(-1)
            :x(-535)
            :sleep(0.5)
            :linear(0.5)
            :x(535):MaskDest():ztestmode("ZTestMode_WriteOnFail"):queuecommand("Shine")
        end,
	ShineCommand=function(self)
	    self:x(-535):sleep(3.5):linear(0.8):x(535):queuecommand("Shine") end
    },

    Def.Sprite {
        Texture="iw_logo_1",
        Name="Text",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:diffusealpha(1):zoom(0.9):y(0)
            :sleep(1.45):queuecommand("Displace")
        end,
		
		DisplaceCommand=function(self)
			self:sleep(3.4)
            :easeinquad(0.4):zoom(1.1):cropleft(1):diffusealpha(0)
            :sleep(3.4)
            :decelerate(0.5):zoom(0.9):cropleft(0):diffusealpha(1)
            :queuecommand("Displace")
		end,
    },

    Def.Sprite {
        Texture="iw_logo_2",
        Name="Text",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:diffusealpha(1):zoom(0.9):x(130)
            :sleep(1.45):queuecommand("Displace")
        end,
		
		DisplaceCommand=function(self)
			self:sleep(3.4)
            :easeinquad(0.4):zoom(1.1):cropright(1):diffusealpha(0)
            :sleep(3.4)
            :decelerate(0.5):zoom(0.9):cropright(0):diffusealpha(1)
            :queuecommand("Displace")
		end,
		
    },
	

}
