return Def.ActorFrame {
	Def.Sprite {
        Texture="shiftarrow_red",
		OpenGroupWheelMessageCommand=function(self) self:linear(0.2):diffusealpha(0) end,
		CloseGroupWheelMessageCommand=function(self) self:linear(0.2):diffusealpha(1) end,
    },
	
	Def.Sprite {
        Texture="a_mask",
		InitCommand=function(self) self:MaskSource() end,
    },
	
	Def.Sprite {
        Texture="glow_back",
		InitCommand=function(self) self:diffuse(color("#EE5512")):texcoordvelocity(0, -0.3):MaskDest():ztestmode("ZTestMode_WriteOnFail") end,
    },
	
	Def.Sprite {
        Texture="dessat_red",
		InitCommand=function(self) self:diffusealpha(0) end,
		OpenGroupWheelMessageCommand=function(self) self:linear(0.2):diffusealpha(1) end,
		CloseGroupWheelMessageCommand=function(self) self:linear(0.2):diffusealpha(0) end,
    },
	
	Def.Sprite {
        Texture="pattern",
		InitCommand=function(self) self:texcoordvelocity(0, -0.3):MaskDest():ztestmode("ZTestMode_WriteOnFail") end,
    }
}