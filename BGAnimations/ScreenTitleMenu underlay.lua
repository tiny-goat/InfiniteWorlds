local t = Def.ActorFrame {
    OnCommand=function(self)
        -- Reset machine profile mods
        ResetLuaMods(PLAYER_1)
        ResetLuaMods(PLAYER_2)

        GAMESTATE:UpdateDiscordGameMode(GAMESTATE:GetCurrentGame():GetName())
        GAMESTATE:UpdateDiscordScreenInfo("Title Menu", "", 1)
    end,

    
	-- woah suspense bg
    Def.Quad {
		InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end,
		OnCommand=function(self) self:diffusealpha(1):sleep(1.45):easeoutexpo(0.7):diffusealpha(0) end
	},
	
	Def.Quad {
		InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(0) end,
		OnCommand=function(self) self:sleep(2):queuecommand("Flash") end,
		
		FlashCommand=function(self)
			self:sleep(3.5)
            :easeinquad(0.5):diffuse(Color.Black):diffusealpha(1)
            :sleep(3.5)
            :easeinquad(0.1):diffuse(Color.White):accelerate(0.4):diffusealpha(0)
            :queuecommand("Flash")
        end,
	},
	
    Def.ActorFrame {
        OnCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :queuecommand("ZoomY")
        end,

        OffCommand=function(self)
            self:stoptweening()
            :easeoutexpo(0.5)
            :zoom(1.1):diffusealpha(0)
        end,

        ZoomYCommand=function(self)
            self:smooth(3.5)
            :zoom(0.9)
            :smooth(3.5)
            :zoom(1)
            :queuecommand("ZoomY")
        end,

        LoadActor(THEME:GetPathG("", "Logo/Parts"))..{
            InitCommand=function(self)
                self:zoom(0.8)
            end
    },
	
},

    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_RIGHT-20, -30):zoom(0.6)
        end,

		OnCommand=function(self)
			self:linear(1.5):y(23)
		end,
		
        OffCommand=function(self)
            self:stoptweening():diffusealpha(0)
        end,

        Def.BitmapText {
            Font="inter medium 25px",
            InitCommand=function(self)
                local InstalledSongs, Groups, InstalledCourses = 0
                if SONGMAN:GetRandomSong() then
                    InstalledSongs, Groups, InstalledCourses =
                        SONGMAN:GetNumSongs() + SONGMAN:GetNumAdditionalSongs() + SONGMAN:GetNumUnlockedSongs(),
                        SONGMAN:GetNumSongGroups(),
                        SONGMAN:GetNumCourses() + SONGMAN:GetNumAdditionalCourses()
                else
                    return
                end

                self:settextf(THEME:GetString("ScreenTitleMenu", "%i Songs (%i Groups), %i Courses"), InstalledSongs, Groups, InstalledCourses):halign(1)
            end
        },

        Def.BitmapText {
            Font="inter medium 25px",
            Text=string.format("OFox %s - %s", ProductVersion(), VersionDate()),
            AltText="OutFox",
            InitCommand=function(self) self:y(28):halign(1) end
        }
    }
}

if not IsHome() and GAMESTATE:EnoughCreditsToJoin() then
    t[#t+1] = Def.ActorFrame {
        OnCommand=function(self)
            -- Hide "Press Center Step" icons if we're on ScreenLogo
            self:visible(SCREENMAN:GetTopScreen():GetName() ~= "ScreenLogo" and true or false)
        end,

        -- ingenius dedicated USB graphic i added
        
        -- P1 side
        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X - SCREEN_WIDTH * 0.35, SCREEN_HEIGHT * 0.7):queuecommand("Refresh") end,
			OnCommand=function(self) self:y(SCREEN_HEIGHT * 0.75):diffusealpha(0):zoom(1):sleep(0.2):smooth(0.3):y(SCREEN_HEIGHT * 0.7):diffusealpha(1) end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(.7):x(SCREEN_LEFT-150) end,
            StorageDevicesChangedMessageCommand=function(self)self:queuecommand("Refresh")end,
            RefreshCommand=function(self)
    			CardState = MEMCARDMAN:GetCardState(PLAYER_1)
    			if CardState == "MemoryCardState_none" then
    				self:visible(true):GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/tg_press_step"))
                    MESSAGEMAN:Broadcast("P1Usb", { State = 0 })
    			elseif CardState == "MemoryCardState_ready" then
    				self:visible(false)
                    MESSAGEMAN:Broadcast("P1Usb", { State = 1 })
    			elseif CardState == "MemoryCardState_error" then
    				self:visible(false)
                    MESSAGEMAN:Broadcast("P1Usb", { State = 2 })
    			end
    		end
        },

        LoadActor(THEME:GetPathG("", "PressCenterStep/UsbMode")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X - SCREEN_WIDTH * 0.35, SCREEN_HEIGHT * 0.7) end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(.7):x(SCREEN_LEFT-150) end,
            P1UsbMessageCommand=function(self, params)
                if params.State == 0 then
                    self:visible(false)
                else if params.State == 1 then
                    self:y(SCREEN_HEIGHT * 0.75):easeoutexpo(0.4):y(SCREEN_HEIGHT * 0.7):visible(true)
                    self:GetChild("ReadyText"):visible(true)
                    self:GetChild("ErrorText"):visible(false)
                else if params.State == 2 then
                    self:visible(true)
                    self:GetChild("ReadyText"):visible(false)
                    self:GetChild("ErrorText"):visible(true) end
                end
            end
        end
        },

        -- P2 side
        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X + SCREEN_WIDTH * 0.35, SCREEN_HEIGHT * 0.7):queuecommand("Refresh") end,
			OnCommand=function(self) self:y(SCREEN_HEIGHT * 0.75):diffusealpha(0):zoom(1):sleep(0.2):smooth(0.3):y(SCREEN_HEIGHT * 0.7):diffusealpha(1) end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(.7):x(SCREEN_RIGHT+150) end,
            StorageDevicesChangedMessageCommand=function(self)self:queuecommand("Refresh")end,
            RefreshCommand=function(self)
    			CardState = MEMCARDMAN:GetCardState(PLAYER_2)
    			if CardState == "MemoryCardState_none" then
    				self:visible(true):GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/tg_press_step"))
                    MESSAGEMAN:Broadcast("P2Usb", { State = 0 })
    			elseif CardState == "MemoryCardState_ready" then
    				self:visible(false)
                    MESSAGEMAN:Broadcast("P2Usb", { State = 1 })
    			elseif CardState == "MemoryCardState_error" then
    				self:visible(false)
                    MESSAGEMAN:Broadcast("P2Usb", { State = 2 })
                end
    		end
        },

        LoadActor(THEME:GetPathG("", "PressCenterStep/UsbMode")) .. {
            InitCommand=function(self) self:xy(SCREEN_CENTER_X + SCREEN_WIDTH * 0.35, SCREEN_HEIGHT * 0.7) end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(.7):x(SCREEN_LEFT-150) end,
            P2UsbMessageCommand=function(self, params)
                if params.State == 0 then
                    self:visible(false)
                else if params.State == 1 then
                    self:y(SCREEN_HEIGHT * 0.75):easeoutexpo(0.4):y(SCREEN_HEIGHT * 0.7):visible(true)
                    self:GetChild("ReadyText"):visible(true)
                    self:GetChild("ErrorText"):visible(false)
                else if params.State == 2 then
                    self:visible(true)
                    self:GetChild("ReadyText"):visible(false)
                    self:GetChild("ErrorText"):visible(true) end
                end
            end
        end
        }
    }
end

if GAMESTATE:GetCoinMode() == "CoinMode_Pay" and GAMESTATE:EnoughCreditsToJoin() == false then
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(self)
			self:visible(SCREENMAN:GetTopScreen():GetName() ~= "ScreenLogo" and false or true)
		end,
		
		-- left
		LoadActor(THEME:GetPathG("", "InsertCredit/insertcoin")) .. {
			InitCommand=function(self) self:zoom(0.8):xy(SCREEN_CENTER_X + SCREEN_WIDTH * 0.33, SCREEN_HEIGHT * 0.9) end,
		},
		
		-- right
		LoadActor(THEME:GetPathG("", "InsertCredit/insertcoin")) .. {
			InitCommand=function(self) self:zoom(0.8):xy(SCREEN_CENTER_X - SCREEN_WIDTH * 0.33, SCREEN_HEIGHT * 0.9) end,
		},
	}
end

return t
