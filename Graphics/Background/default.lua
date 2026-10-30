local t = Def.ActorFrame {}

-- Solid Background
t[#t+1] = Def.Quad {
    Name="Background",
    InitCommand=function(self)
        self:Center()
        :zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
        :diffuse(color("#020000"))
    end
}

-- Gradient overlay
t[#t+1] = Def.Sprite {
    Name="Gradient",
    Texture="gradient",
    InitCommand=function(self)
        self:Center():diffuse(color("#700035"))
    end,
}

-- Squiggly Things (with random speed!)
for i=1,4 do
    t[#t+1] = Def.Sprite {
        Name="Squiggle" .. i,
        Texture="Squiggles/" .. i,
        InitCommand=function(self)
            self:Center()
            :zoom(1 + i / 8)
            :texcoordvelocity((math.random(-3, 3) / 10) + 0.05, 0) -- bad hack to make sure the X velocity is 0 less often
			:blend("Add")
			:diffuse(color("#300016"))
            :diffusealpha(0.5)
        end
    }
end

-- lines
t[#t+1] = LoadActor(THEME:GetPathG("", "Grid"))

t[#t+1] = LoadActor("confetti")..{
    Condition=IsAnniversary()
}

return t
