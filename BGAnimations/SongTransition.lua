local BasicMode = getenv("IsBasicMode")

local ChartLabels = {
    "NEW",
    "ANOTHER",
    "PRO",
    "TRAIN",
    "QUEST",
    "UCS",
    "HIDDEN",
    "INFINITY",
    "JUMP",
}

local t = Def.ActorFrame {

	Def.Quad {
        OnCommand=function(self) self:playcommand("Refresh") end,
        StartTransitioningCommand=function(self) self:playcommand("Refresh") end,

        RefreshCommand=function(self)
            if SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
                self:FullScreen():diffuse(Color.Black)
            else
                self:visible(false)
            end
        end
    },

    Def.Sprite {
        OnCommand=function(self) self:playcommand("Refresh") end,
        StartTransitioningCommand=function(self) self:playcommand("Refresh") end,

        RefreshCommand=function(self)
            if SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
                if GAMESTATE:GetCurrentSong() then
                    local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
                    if Path and FILEMAN:DoesFileExist(Path) then
                        self:Load(Path):scale_or_crop_background()
                    else
                        self:Load(THEME:GetPathG("Common", "fallback background")):scale_or_crop_background()
                    end
                end
            else
                self:Load(nil)
            end
        end
    },
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local PlayerDirection = (pn == PLAYER_2 and 1 or -1)

    t[#t+1] = Def.ActorFrame {
		
        Def.ActorFrame {
            OnCommand=function(self)
                self:xy(pn == PLAYER_2 and SCREEN_RIGHT - 85 or 85, SCREEN_BOTTOM - 35):playcommand("Refresh")
            end,

            StartTransitioningCommand=function(self) self:playcommand("Refresh") end,

            RefreshCommand=function(self)
                if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) and
                SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
                    self:visible(true)

                    local Song = GAMESTATE:GetCurrentSong()
                    local Chart = GAMESTATE:GetCurrentSteps(pn)
                    local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))
                    local ChartMeter = Chart:GetMeter()
                    
                    if ChartMeter == 99 then ChartMeter = "??" end

                    local ChartAuthor = Chart:GetAuthorCredit()
                    if ChartAuthor == "" then ChartAuthor = "Unknown" end

                    self:GetChild("Ball"):diffuse(ChartTypeToColor(Chart))
                    self:GetChild("Meter"):settext(ChartMeter)
                    self:GetChild("Credit"):settext(ChartAuthor)

                    local ChartLabelIndex = 0
                    for Index, String in pairs(ChartLabels) do
                        if string.find(ToUpper(Chart:GetDescription()), String) then
                            ChartLabelIndex = Index
                        end
                    end

                    if ChartLabelIndex ~= 0 then
                        self:GetChild("Label"):visible(not BasicMode):setstate(ChartLabelIndex - 1)
                    else
                        self:GetChild("Label"):visible(false)
                    end
                else
                    self:visible(false)
                end
            end,

            -- Def.Sprite {
                -- Name="Frame",
                -- Texture=THEME:GetPathG("", "UI/StepArtist" .. (pn == PLAYER_2 and "R" or "L")),
				-- InitCommand=function(self) self:zoom(0.5) end,
            -- },
			
			Def.Sprite {
                 Name="Frame",
                 Texture=THEME:GetPathG("", "UI/tg_base_stepartist"),
				 InitCommand=function(self) self:zoom(0.38):rotationy(pn== PLAYER_2 and -180 or 0) end,
            },

            Def.Sprite {
                Name="Ball",
                Texture=THEME:GetPathG("", "UI/tg_stepartist_diff"),
                InitCommand=function(self)
                    self:rotationy(pn== PLAYER_2 and -180 or 0):zoom(0.38)
                end
            },
			
            Def.BitmapText {
                Name="Meter",
                Font="inter extrabold 45px",
                InitCommand=function(self)
                    self:xy(53.5 * PlayerDirection, 13):zoom(0.58):strokecolor(Color.Black)
                end
            },

            Def.Sprite {
                Name="Label",
                Texture=THEME:GetPathG("", "DifficultyDisplay/Labels"),
                InitCommand=function(self)
                    self:xy(53 * PlayerDirection, -17):zoom(0.7):visible(false):animate(false)
                end
            },

            Def.BitmapText {
                Name="Credit",
                Font="inter medium 25px",
                InitCommand=function(self)
                    self:xy(-21 * PlayerDirection, 14)
                    :vertspacing(-8):zoom(0.72):strokecolor(Color.Black)
                    :wrapwidthpixels(150)
                    :maxheight(40)
                    :maxwidth(115)
                end
            },
			
			Def.BitmapText {
                Font="inter light 22px",
                InitCommand=function(self)
                    self:settext("Step Artist"):xy(-21 * PlayerDirection, -17)
                    :vertspacing(-8):zoom(0.6):strokecolor(Color.Black)
                end
            }
        }
   }
end

-- If the screen is transitioning in attract mode, we don't need to show all of this
return (GAMESTATE:IsDemonstration() and Def.Actor{} or t)
