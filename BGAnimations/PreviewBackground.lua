local FrameW = SCREEN_WIDTH
local FrameH = SCREEN_HEIGHT

local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local DisplayNotefield = false

-- Video/background display
local t = Def.ActorFrame {
    InitCommand=function(self) self:zoom(1):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y) end,

    Def.ActorFrame {
        Name="Back",
		
        Def.Quad {
            Name="Back1",
            InitCommand=function(self)
                self:zoomto(FrameW, FrameH):diffuseleftedge(color("#16EEFF")):diffuserightedge(color("#c01d00")):fadetop(0.9):diffusealpha(0)
            end,
			ScrollMessageCommand=function(self)
				self:stoptweening():diffusealpha(0.7):sleep(PreviewDelay):diffusealpha(0) end
        },

    },

    Def.Sprite {
        InitCommand=function(self) self:Load(nil):queuecommand("Refresh") end,
        CurrentSongChangedMessageCommand=function(self) self:Load(nil):queuecommand("Refresh") end,

        RefreshCommand=function(self)
            self:stoptweening():diffusealpha(0):sleep(PreviewDelay)
            Song = GAMESTATE:GetCurrentSong()
            if Song then
                if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil or LoadModule("Config.Load.lua")("ImagePreviewOnly", "Save/OutFoxPrefs.ini") then
                    self:queuecommand("LoadBG")
                else
                    self:queuecommand("LoadAnimated")
                end
            end
        end,

        LoadBGCommand=function(self)
            local Path = Song:GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
                self:LoadFromCached("Background", Path):zoomto(FrameW, FrameH)
                :diffusealpha(0):linear(PreviewDelay):diffusealpha(1)
            else
                self:LoadFromCached("Banner", Song:GetBannerPath()):zoomto(FrameW, FrameH)
                :diffusealpha(0):linear(PreviewDelay):diffusealpha(1)
            end
        end,

        LoadAnimatedCommand=function(self)
            local Path = Song:GetPreviewVidPath()
            if Path and FILEMAN:DoesFileExist(Path) then
                self:Load(Path):zoomto(FrameW, FrameH)
                :diffusealpha(0):linear(PreviewDelay):diffusealpha(1)
            else
                self:queuecommand("LoadBG")
            end
        end
    },

    -- the new decorations
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(0, -90):stoptweening():diffusealpha(0)
            :sleep(PreviewDelay):linear(0.2):diffusealpha(1)
        end,
		ScrollMessageCommand=function(self)
			self:stoptweening():diffusealpha(0)
            :sleep(PreviewDelay):linear(0.2):diffusealpha(1)
        end,

        Def.Sprite {
            Name="Circle1",
            Texture=THEME:GetPathG("", "UI/circles1"),
            InitCommand=function(self)
                self:zoomto(1024,1024):diffusealpha(0.3):spin():effectmagnitude(0,0,12):effectperiod(0.3) end
        },
        Def.Sprite {
            Name="Circle2",
            Texture=THEME:GetPathG("", "UI/circles2"),
            InitCommand=function(self)
                self:zoomto(1024,1024):diffuse(color("#16decb")):diffusealpha(0.4):spin():effectmagnitude(0,0,-12):effectperiod(0.3) end
        },
        
        Def.Sprite {
            Name="Circle3",
            Texture=THEME:GetPathG("", "UI/circles3"),
            InitCommand=function(self)
                self:zoomto(340,340):diffuse(color("#df16eb80")):rotationz(45) end,
            ScrollMessageCommand=function(self)
                self:stoptweening():zoomto(350,350):sleep(PreviewDelay):linear(0.2):zoomto(340,340)
            end
        },

        Def.Sprite {
            Name="Xmark",
            Texture=THEME:GetPathG("", "UI/targ1"),
            InitCommand=function(self)
                self:zoomto(340,340):diffusealpha(0.7) end,
            ScrollMessageCommand=function(self)
                self:stoptweening():zoomto(290,290):sleep(PreviewDelay):linear(0.2):zoomto(340,340)
            end
        }

    }
}

return t