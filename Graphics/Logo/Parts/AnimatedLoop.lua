return Def.ActorFrame {
	FOV = 90,
    Def.Sprite {
        Name="PlainLoop",
        Texture="iw_logo_4",
	InitCommand=function(self) self:zoom(0):rotationy(180):diffuse(1,1,1,1):linear(0.3):sleep(0.2)
	:easeoutexpo(0.7):diffusetopedge(color("#22CCDD")):diffusebottomedge(color("#EE16DD")):rotationy(0):zoom(1.15) end
    },

    Def.Sprite {
        Name="InnerLoop",
        Texture="iw_logo_3",
        InitCommand=function(self)
          self:zoom(1.1):MaskSource()
        end
    },

    Def.Sprite {
        Name="ArrowPattern0",
        Texture="ArrowPattern",
        InitCommand=function(self)
            self:blend("BlendMode_Add"):diffusealpha(0.3):y(-95):diffusecolor(color("#FFFFFF"))
            :zoomto(1125,1125)
            :customtexturerect(0,0,4,2.4)
            :texcoordvelocity(-0.1,0.3)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end,
	OnCommand=function(self) self:diffusealpha(0):sleep(0.8):diffusealpha(0.3) end
    },

    LoadActor("Hat")..{
        Condition = IsAnniversary()
    }

}
