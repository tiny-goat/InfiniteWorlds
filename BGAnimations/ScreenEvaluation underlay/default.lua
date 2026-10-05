local CenterPressCount = 0
local CenterPress3xEnabled = LoadModule("Config.Load.lua")("EvalCenter3xExit", "Save/OutFoxPrefs.ini")
local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"
local ClassicGrades = LoadModule("Config.Load.lua")("ClassicGrades", "Save/OutFoxPrefs.ini") and Scoring == "Old"
local AdvScoresShown = false
local BasicMode = getenv("IsBasicMode")

local GradeZoom = IsUsingWideScreen() and 0.3 or 0.25

-- we will pass the gradezoom values here, since new and classic grade letters are in different resolutions, and need diff zoom values, kinda stupid but eh it works
local GradeZoomAdd = ClassicGrades and GradeZoom or GradeZoom+0.2

-- same code taken from EvalLines, probably not the most efficient method of making certain elements resize/reposition depending on the rows on screen though :/

local Name, Length = LoadModule("Options.SmartTapNoteScore.lua")()
table.sort(Name)
Name[#Name+1] = "Miss"
Name[#Name+1] = "MaxCombo"
Name[#Name+1] = "Accuracy"
Name[#Name+1] = "Score"
Length = Length + 4

local RowAmount = Length

local PlateZoom = IsUsingWideScreen() and 0.7 or 0.45

-- how long it takes for the grading/plate/sfx to play after evallines finishes showing all stats
local GradeTime = 3

local Grades = { PlayerNumber_P1 = "FailF", PlayerNumber_P2 = "FailF" }
local GradePriority = {
    Pass3S = 1, Fail3S = 2, Pass2S = 3, Fail2S = 4, Pass1S = 5, Fail1S = 6, PassA = 7, FailA = 8,
    PassB = 9, FailB = 10, PassC = 11, FailC = 12, PassD = 13, FailD = 14, PassF = 15, FailF = 16
}
local Plates = { PlayerNumber_P1 = "RoughGame", PlayerNumber_P2 = "RoughGame" }

local function InputHandler(event)
    local pn = event.PlayerNumber
    if not pn then return end

    -- To avoid control from a player that has not joined, filter the inputs out
    if pn == PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then return end
    if pn == PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then return end

    if event.type == "InputEventType_Repeat" or event.type == "InputEventType_Release" then return end

    local button = event.button
    if button == "Center" then
        if CenterPressCount == (CenterPress3xEnabled and 2 or 0) then
            SCREENMAN:set_input_redirected(PLAYER_1, false)
            SCREENMAN:set_input_redirected(PLAYER_2, false)
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        else
            CenterPressCount = CenterPressCount + 1
        end
    elseif button == "Start" then
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    elseif button == "Back" then
        SCREENMAN:set_input_redirected(PLAYER_1, false)
        SCREENMAN:set_input_redirected(PLAYER_2, false)
        SCREENMAN:GetTopScreen():Cancel()
    end
    return false
end

local t = Def.ActorFrame {
	-- kpump doesnt have a start sound on evaluation however
    --[[Def.Sound {
        File=THEME:GetPathS("Common", "Start"),
        IsAction=true,
        OffCommand=function(self) self:play() end
    },]]--

    LoadActor("EvalLines"),

    -- TODO: Dynamically adjust the Y position relative to the amount of lines on screen?
    -- might be the most inefficient way to achieve such thing (jkob)
    LoadActor("EvalSongInfo") .. {
        InitCommand=function(self) self:xy(SCREEN_CENTER_X, RowAmount == 9 and 146 or 156) end,
    },

    LoadActor("../HudPanels")
}

t[#t+1] = Def.ActorFrame {
    OnCommand=function(self)
        -- Save profile names as score names
        if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
            GAMESTATE:StoreRankingName(PLAYER_1, PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName())
        end
        -- Yes, having to do this twice sucks
        if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
            GAMESTATE:StoreRankingName(PLAYER_2, PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName())
        end

        -- Used for our custom input
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
        SCREENMAN:set_input_redirected(PLAYER_1, true)
        SCREENMAN:set_input_redirected(PLAYER_2, true)

        -- Discord RPC
        local pn = GAMESTATE:GetMasterPlayerNumber()
        local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
        local StepOrTrails = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn) or GAMESTATE:GetCurrentSteps(pn)
        if GAMESTATE:GetCurrentSong() then
            local title = PREFSMAN:GetPreference("ShowNativeLanguage") and GAMESTATE:GetCurrentSong():GetDisplayMainTitle() or GAMESTATE:GetCurrentSong():GetTranslitFullTitle()
            local details = not GAMESTATE:IsCourseMode() and title .. " - " .. SongOrCourse:GetDisplayArtist() or title
            details = string.len(details) < 128 and details or string.sub(details, 1, 124) .. "..."
            local Difficulty = ToEnumShortString(ToEnumShortString((StepOrTrails:GetStepsType()))) .. " " .. StepOrTrails:GetMeter()
            local Percentage = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetPercentDancePoints()
            local states = Difficulty .. " (" .. string.format( "%.2f%%", Percentage*100) .. ")"
            GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(pn))
            GAMESTATE:UpdateDiscordScreenInfo(details, states, 1)
        end
    end,

    OffCommand=function(self) self:playcommand("EnableInput") end,
    CancelCommand=function(self) self:playcommand("EnableInput") end,

    EnableInputCommand=function(self)
        SCREENMAN:set_input_redirected(PLAYER_1, false)
        SCREENMAN:set_input_redirected(PLAYER_2, false)
    end
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.ActorFrame {
        LoadActor("../ModIcons", pn) .. {
            InitCommand=function(self)
                self:zoomx(0):xy(pn == PLAYER_2 and SCREEN_RIGHT + 40 * 2 or -40 * 2, 160)
                :sleep(0.5):easeoutexpo(0.6):zoomx(1):x(pn == PLAYER_2 and SCREEN_RIGHT - 40 or 40)
                :visible(not BasicMode)
            end,
        },

		-- the 2nd element that needs that y adjustment
        LoadActor("EvalBall", pn) .. {
            InitCommand=function(self)
			local DynamicY = RowAmount == 9 and 242.3 or 230
                self:zoom(2):xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 100 or -100), SCREEN_CENTER_Y +200):rotationy(80):sleep(0.1):easeoutexpo(0.5):zoom(RowAmount == 9 and 1.2 or 1.3):xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 75 or -75), SCREEN_CENTER_Y+DynamicY):rotationy(0)
            end,

        },

		-- fx
		Def.Sprite {
            InitCommand=function(self)
                local GradeX = IsUsingWideScreen() and 300 or 260
                self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), SCREEN_CENTER_Y + 6)

                self:Load(THEME:GetPathG("", "ParticlesAndEffects/Stars2"))
                :diffusealpha(1):zoom(0):sleep(GradeTime):decelerate(0.75)
                :zoom(0.13):diffusealpha(0)
            end
        },
		
		Def.Sprite {
            InitCommand=function(self)
                local GradeX = IsUsingWideScreen() and 300 or 260
                self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), SCREEN_CENTER_Y + 6)

                self:Load(THEME:GetPathG("", "ParticlesAndEffects/Stars3"))
                :diffusealpha(1):zoom(0):sleep(GradeTime+0.1):decelerate(0.75)
                :zoom(0.13):diffusealpha(0)
            end
        },
		
		Def.Sprite {
            InitCommand=function(self)
                local GradeX = IsUsingWideScreen() and 300 or 260
                self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), SCREEN_CENTER_Y + 6)

                self:Load(THEME:GetPathG("", "Background/circle"))
                :diffusealpha(1):zoom(0):sleep(GradeTime):decelerate(0.75)
                :zoom(0.35):diffusealpha(0)
            end
        },
		
		-- letter grades
        Def.Sprite {
            InitCommand=function(self)
                local GradeX = IsUsingWideScreen() and 300 or 260
                self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), SCREEN_CENTER_Y + 4)

                local PlayerScore = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                Grades[pn] = LoadModule("PIU/Score.GradingEval.lua")(PlayerScore)

                self:Load(THEME:GetPathG("", "LetterGrades/" .. (ClassicGrades and "" or "New/") .. Grades[pn]))
                :diffusealpha(0):rotationz(0):sleep(GradeTime):decelerate(0.1)
                :zoom(GradeZoomAdd):diffusealpha(1)
            end,
		},
		
		
        Def.Sprite {
            InitCommand=function(self)
                local GradeX = IsUsingWideScreen() and 300 or 260
                self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), SCREEN_CENTER_Y + 3):blend("Add")

                local PlayerScore = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                Grades[pn] = LoadModule("PIU/Score.GradingEval.lua")(PlayerScore)

                self:Load(THEME:GetPathG("", "LetterGrades/" .. (ClassicGrades and "" or "New/") .. Grades[pn]))
                :diffusealpha(0):glow(1,1,1,0):sleep(GradeTime+0.1):glow(1,1,1,1):diffusealpha(0.9):zoom(GradeZoomAdd):decelerate(0.6)
                :zoom(GradeZoomAdd * 1.28):glow(1,1,1,0):diffusealpha(0)
            end
        }
    }

	-- plates
    if Scoring == "New" then
        t[#t+1] = Def.ActorFrame {
			
			Def.Sprite {
                InitCommand=function(self)
                    local GradeX = IsUsingWideScreen() and 300 or 260
                    self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), SCREEN_CENTER_Y - 100)

                    local PlayerScore = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                    Plates[pn] = LoadModule("PIU/Score.PlatesEval.lua")(PlayerScore)

                    self:Load(THEME:GetPathG("", "LetterGrades/New/" .. Plates[pn]))
                    :diffusealpha(0):zoomx(2):zoomy(0):sleep(GradeTime+0.3):easeoutexpo(0.25)
                    :zoom(PlateZoom):diffusealpha(1):queuecommand("Levitate")
                end,
				LevitateCommand=function(self) self:y(SCREEN_CENTER_Y - 100):smooth(1.2):y(SCREEN_CENTER_Y - 104):smooth(1.2):y(SCREEN_CENTER_Y - 100):queuecommand("Levitate") end
            },
			
			Def.Sprite {
                InitCommand=function(self)
                    local GradeX = IsUsingWideScreen() and 300 or 260
                    self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), SCREEN_CENTER_Y - 100)

                    local PlayerScore = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                    Plates[pn] = LoadModule("PIU/Score.PlatesEval.lua")(PlayerScore)

                    self:Load(THEME:GetPathG("", "LetterGrades/New/" .. Plates[pn]))
                    :blend("Add"):diffusealpha(0):sleep(GradeTime+0.4):diffusealpha(0.8):zoom(PlateZoom):decelerate(0.3)
                    :zoom(PlateZoom * 1.3):diffusealpha(0)
                end
            },
			
			Def.Sound {
				File=THEME:GetPathS("", "tg_platesound"),
				InitCommand=function(self) self:sleep(GradeTime+0.3):queuecommand("Play") end,
				PlayCommand=function(self) self:play() end,
			}
        }
    end
end

-- Sounds

-- ticking sound effect, this is timed to EvalLines, plays a tick every time a new eval line element appears.

for i = 1, RowAmount do
	t[#t+1] = Def.Sound {
		File = THEME:GetPathS("","tg_tick"),
		OnCommand=function(self) self:sleep(1.5+i*0.1):queuecommand("Play") end,
		PlayCommand=function(self) self:play() end
	}
end

-- evaluation hit

t[#t+1] = Def.Sound {
            File=THEME:GetPathS("", "tg_hit"),
            InitCommand=function(self) self:sleep(GradeTime):queuecommand("Play") end,
            PlayCommand=function(self) self:play() end,
}

-- announcer

t[#t+1] = Def.ActorFrame {
    OnCommand=function(self)
        self:sleep(GradeTime+0.1):queuecommand("Announcer")
    end,

    AnnouncerCommand=function(self)
        local Grade = "FailF"

        if ClassicGrades then
            if GradePriority[Grades[PLAYER_1]] < GradePriority[Grades[PLAYER_2]] then
                Grade = Grades[PLAYER_1]
            else
                Grade = Grades[PLAYER_2]
            end
        else
            local ScoreP1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetScore() or "0"
            local ScoreP2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetScore() or "0"
            Grade = (ScoreP1 > ScoreP2 and Grades[PLAYER_1] or Grades[PLAYER_2])
        end

        SOUND:PlayAnnouncer(Grade)
    end
}

return t
