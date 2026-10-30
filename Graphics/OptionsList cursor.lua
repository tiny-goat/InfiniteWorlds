return Def.ActorFrame{
    Def.Quad {
        InitCommand=function(self)
            self:diffuseshift()
            :effectcolor2(color("#000000"))
            :effectcolor1(color("#600016"))
            :effectperiod(0.75)
            :zoomto(180,20)
            :fadeleft(0.1)
            :faderight(0.1)
            :blend(Blend.Add)
            :MaskDest()
        end
    },
    
	-- split these 2 in half idk i want it to atually move left n right not slightly zoom in and out the image
	-- left
    Def.Sprite {
        Texture=THEME:GetPathG("", "MusicWheel/Selector"),
        InitCommand=function(self)
            self:zoom(0.5):cropright(0.5)
            :bounce()
            :effectmagnitude(4,0,0)
            :effectperiod(0.75)
            :MaskDest()
        end
    },
	-- right
	Def.Sprite {
        Texture=THEME:GetPathG("", "MusicWheel/Selector"),
        InitCommand=function(self)
            self:zoom(0.5):cropleft(0.5)
            :bounce()
            :effectmagnitude(-4,0,0)
            :effectperiod(0.75)
            :MaskDest()
        end
    }
}
