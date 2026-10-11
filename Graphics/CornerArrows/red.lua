return Def.ActorFrame {
	Def.Sprite {
        Texture="shiftarrow_red",
    },
	
	Def.Sprite {
        Texture="a_mask",
		InitCommand=function(self) self:MaskSource() end,
    },
	
	Def.Sprite {
        Texture="glow_back",
		InitCommand=function(self) self:diffuse(color("#EE5512")):texcoordvelocity(0, -0.25):MaskDest():ztestmode("ZTestMode_WriteOnFail") end,
    },
	
	Def.Sprite {
        Texture="pattern",
		InitCommand=function(self) self:texcoordvelocity(0, -0.25):MaskDest():ztestmode("ZTestMode_WriteOnFail") end,
    }
}