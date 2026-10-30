if IsGame("pump") or IsGame("piu") then
    -- modified presscenter step that works specifically for the USB memory cards
    return Def.ActorFrame {
        
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(280,120):y(48):diffuse(color("#202020")):diffusealpha(0.5) end
        },

        Def.Quad {
            InitCommand=function(self)
                self:zoomto(272,113):y(48):fadetop(0.5):diffuse(color("#600010")):diffusealpha(0.5) end
        },


		Def.Sprite {
            Name="Step",
                Texture=THEME:GetPathG("","UI/Icon/CenterArrow"),
                InitCommand=function(self) self:xy(-70,48):zoom(0.65) end
        },

        Def.Sprite {
           Texture=THEME:GetPathG("","UI/Icon/CenterArrow"),
            InitCommand=function(self)
                self:blend('Add'):xy(-70,48):zoom(0):diffusealpha(0)
                :queuecommand("FadeEffect")
            end,
            FadeEffectCommand=function(self)
                self:stoptweening()
                :zoom(0.65):diffusealpha(0.7)
                :smooth(0.5286)
                :zoom(0.8):diffusealpha(0)
                :queuecommand("FadeEffect")
            end
        },

        Def.Sprite {
            Name="Press",
            Texture="tg_press_step",
            InitCommand=function(self) self:zoom(0.45):xy(-70,14) end,
            OnCommand=function(self)
                self:bounce():sleep(1.1)
                :effectmagnitude(0, -30, 0)
                :effectperiod(0.5286)
            end
        },
		
		Def.BitmapText {
            Name="ReadyText",
            Font="inter medium 32px",
            Text="USB Inserted!\nPress Center Step\nto continue.",
            InitCommand=function(self) self:x(-10):y(48):halign(0):zoom(0.43) end,
        },

        Def.BitmapText {
            Name="ErrorText",
            Font="inter medium 32px",
            Text="USB Error!",
            InitCommand=function(self) self:x(-10):y(48):halign(0):zoom(0.7):strokecolor(color("#EE0010")) end,
        },
    }
else
    return LoadActor("ButtonPress 5x2") .. {
        Frames=Sprite.LinearFrames(10, .4286),
        InitCommand=function(self) self:y(20) end
    }
end