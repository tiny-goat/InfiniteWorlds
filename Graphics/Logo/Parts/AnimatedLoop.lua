return Def.ActorFrame {
	FOV = 90,
    Def.Sprite {
        Name="PlainLoop",
        Texture="iw_logo_4",
	InitCommand=function(self) self:zoom(8):rotationz(-180):diffuse(1,1,1,0)
	:easeoutexpo(2):diffuse(color("#ff0062ff")):rotationz(0):zoom(1) end
    },

    Def.Sprite {
        Name="InnerLoop",
        Texture="iw_logo_3",
        InitCommand=function(self)
          self:zoom(1):MaskSource()
        end
    },

    -- Def.Sprite {
        -- Name="ArrowPattern0",
        -- Texture="ArrowPattern",
        -- InitCommand=function(self)
            -- self:blend("BlendMode_Add"):diffusealpha(0.3):y(-95):diffusecolor(color("#FFFFFF"))
            -- :zoomto(1125,1125)
            -- :customtexturerect(0,0,2,2)
            -- :texcoordvelocity(-0.1,0.3)
            -- :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        -- end,
	-- OnCommand=function(self) self:diffusealpha(0):sleep(0.8):diffusealpha(0.3) end
    -- },
	
	Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Circle"),
        InitCommand=function(self)
            self:xy(0,300)
            :diffusealpha(0):MaskDest():ztestmode("ZTestMode_WriteOnFail"):sleep(1.4):queuecommand("Expand")
        end,
        ExpandMessageCommand=function(self)
            self:diffusealpha(0.3):zoom(0)
            :linear(3)
            :diffusealpha(1):zoom(1.2)
            :queuecommand("Expand")
        end
    },
	
	Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Circle"),
        InitCommand=function(self)
            self:xy(250,-300)
            :diffusealpha(0):MaskDest():ztestmode("ZTestMode_WriteOnFail"):sleep(1.8):queuecommand("Expand")
        end,
        ExpandMessageCommand=function(self)
            self:diffusealpha(0.3):zoom(0)
            :linear(5)
            :diffusealpha(0.6):zoom(1.2)
            :queuecommand("Expand")
        end
    },
    
}
