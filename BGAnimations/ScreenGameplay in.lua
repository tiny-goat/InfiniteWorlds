return Def.ActorFrame {
    LoadActor("SongTransition") .. {
        OnCommand=function(self)
            self:linear(0.5):diffusealpha(0)
        end
    }
}
