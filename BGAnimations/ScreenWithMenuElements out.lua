return Def.Quad{
    StartTransitioningCommand=function(self)
        self:FullScreen():diffuse(Color.Black)
        :diffusealpha(0):smooth(0.2):diffusealpha(1)
    end
}
