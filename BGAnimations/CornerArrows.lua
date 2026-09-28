return Def.ActorFrame {
    -- Up Left
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_red"),
        OnCommand=function(self) self:zoom(0.6):xy(-40, -40):rotationz(135):easeoutexpo(1):xy(50,50) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(-72, -72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_red"),
        InitCommand=function(self) self:xy(50,50):rotationz(135):zoom(0.6):blend('add'):diffusealpha(0) end,
        SongUnchosenMessageCommand=function(self) self:playcommand("Glow") end,
        StartSelectingGroupMessageCommand=function(self) self:playcommand("Glow") end,
        GlowCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.6):linear(0.25):diffusealpha(0):zoom(0.7)
        end
    },

    -- Up Right
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_red"),
        OnCommand=function(self) self:zoom(0.6):xy(SCREEN_RIGHT + 40, -40):rotationz(-135):easeoutexpo(1):xy(SCREEN_RIGHT - 50, 50) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(SCREEN_RIGHT + 72, -72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_red"),
        InitCommand=function(self) self:xy(SCREEN_RIGHT - 50,  50):rotationz(-135):zoom(0.6):blend('add'):diffusealpha(0) end,
        SongUnchosenMessageCommand=function(self) self:playcommand("Glow") end,
        StartSelectingGroupMessageCommand=function(self) self:playcommand("Glow") end,
        GlowCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.6):linear(0.25):diffusealpha(0):zoom(0.7)
        end
    },

    -- Down Left
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_blue"),
        OnCommand=function(self) self:zoom(0.6):xy(-72, SCREEN_BOTTOM + 72):rotationz(45):easeoutexpo(1):xy(50, SCREEN_BOTTOM - 50) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(-72, SCREEN_BOTTOM + 72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_blue"),
        InitCommand=function(self) self:xy(50, SCREEN_BOTTOM - 50):rotationz(45):zoom(0.6):blend('add'):diffusealpha(0) end,
        PreviousSongMessageCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.6):linear(0.25):diffusealpha(0):zoom(0.7)
        end,
        ScrollMessageCommand=function(self, params) if params.Direction == -1 then
            self:stoptweening():diffusealpha(1):zoom(0.6):linear(0.25):diffusealpha(0):zoom(0.7) end
        end
    },

    -- Down Right
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_blue"),
        OnCommand=function(self) self:zoom(0.6):xy(SCREEN_RIGHT + 72, SCREEN_BOTTOM + 72):rotationz(-45):easeoutexpo(1):xy(SCREEN_RIGHT - 50, SCREEN_BOTTOM - 50) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(SCREEN_RIGHT + 72, SCREEN_BOTTOM + 72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/shiftarrow_blue"),
        InitCommand=function(self) self:xy(SCREEN_RIGHT - 50, SCREEN_BOTTOM - 50):rotationz(-45):zoom(0.6):blend('add'):diffusealpha(0) end,
        NextSongMessageCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.6):linear(0.25):diffusealpha(0):zoom(0.7)
        end,
        ScrollMessageCommand=function(self, params) if params.Direction == 1 then
            self:stoptweening():diffusealpha(1):zoom(0.6):linear(0.25):diffusealpha(0):zoom(0.7) end
        end
    }
}
