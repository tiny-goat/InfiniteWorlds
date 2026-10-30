return Def.ActorFrame {
    Def.Sprite {
        InitCommand=function(self)
            local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
                self:Load(Path):scale_or_crop_background():diffusealpha(1)
			else
				self:Load(THEME:GetPathG("","Common fallback background")):scale_or_crop_background():diffusealpha(1)
			end
        end
    },

    Def.Quad {
        OnCommand=function(self)
            self:FullScreen():diffuse(Color.Black):diffusealpha(0.8)
        end
    },

}
