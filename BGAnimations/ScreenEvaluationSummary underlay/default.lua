local Song = SessionEvaluationSummary or {}
local FirstSong = math.max(1, #Song - 7)
local SongCount = math.max(1, #Song - FirstSong + 1)
-- since the maximum allowable songs per game of non-event mode, just make this big af
local rowY = math.min(90, 500 / SongCount)
local rowTop = SCREEN_CENTER_Y - (SongCount * rowY) / 2 + rowY / 2

local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"
local ClassicGrades = LoadModule("Config.Load.lua")("ClassicGrades", "Save/OutFoxPrefs.ini") and Scoring == "Old"

local GradeZoom = 0.25
local PlateZoom = 0.4
local GradeX = IsUsingWideScreen() and 520 or 370
local PlateX = IsUsingWideScreen() and 410 or 250
local StatsX = IsUsingWideScreen() and 450 or 295

local function PlayerResult(EvalDetail, pn)
	local result = EvalDetail.Players and EvalDetail.Players[pn]
	if not result then return "" end
	return string.format("%s %s" , result.Difficulty or "nil", result.Percentage or "nil")
end

local function LetterGrade(EvalDetail, pn)
	local result = EvalDetail.Players and EvalDetail.Players[pn]
	if not result or not result.Grade then return nil end
	return THEME:GetPathG("", "LetterGrades/" .. (ClassicGrades and "" or "New/") .. result.Grade)
end

local function Plates(EvalDetail, pn)
	local result = EvalDetail.Players and EvalDetail.Players[pn]
	if Scoring ~= "New" or not result or not result.Plate then return nil end
	return THEME:GetPathG("", "LetterGrades/New/" .. result.Plate)
end

local t = Def.ActorFrame {
	-- apply timer check here
	InitCommand=function(self)
		self:sleep(0.5):queuecommand("CheckTimer")
	end,
	CheckTimerCommand=function(self)
		if SCREENMAN:GetTopScreen():GetChild("Timer"):GetSeconds() <= 0 then
			self:queuecommand("TimerExpired")
		else
			self:sleep(0.5):queuecommand("CheckTimer")
		end
	end,
	TimerExpiredCommand=function(self)
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
	end,
	
    LoadActor(THEME:GetPathB("","HudPanels"))..{}
}

for i = FirstSong, #Song do
	local Detail = Song[i]
	local BoxY = rowTop + (i - FirstSong) * rowY

	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, BoxY)
		end,

		-- the backing thing
		Def.Quad {
			InitCommand=function(self)
				self:xy(0,0):zoomto(SCREEN_WIDTH - 80, rowY - 2)
					:diffuse(color("#000000")):diffusealpha(0.8):fadeleft(0.05):faderight(0.05)
			end,
			OnCommand=function(self)
				self:zoomto(SCREEN_WIDTH - 80, 0):sleep(i*0.25):easeoutexpo(0.6):zoomto(SCREEN_WIDTH - 80, rowY - 2) 
			end
		},
		Def.BitmapText {
			Font="Eurostile extended 32px",
			InitCommand=function(self)
				self:settext("ROUND"):xy(0,-26):zoom(0.3)
			end,
			OnCommand=function(self)
				self:diffusealpha(0):zoomx(1):sleep(i*0.25):easeoutexpo(0.6):zoomx(0.3):diffusealpha(0.1)
			end
		},
		Def.BitmapText {
			Font="Eurostile extended 32px",
			InitCommand=function(self)
				self:settext(i):xy(0,-5):skewx(-0.3):zoom(2)
			end,
			OnCommand=function(self)
				self:diffusealpha(0):zoomx(6):sleep(i*0.25):easeoutexpo(0.6):zoomx(2):diffusealpha(0.1)
			end
		},

		-- song title
		Def.BitmapText {
			Font="inter medium 32px",
			InitCommand=function(self)
				self:settext(Detail.Title or "Unknown"):xy(0, -2):zoom(0):diffusealpha(0)
					:maxwidth(math.max(100, SCREEN_WIDTH / 2 - 40)):strokecolor(Color.Black)
			end,
			OnCommand=function(self)
				self:zoomy(0.7):zoomx(1.3):sleep(i*0.25):easeoutexpo(0.3):zoom(0.7):diffusealpha(1) end
		},

		-- difficulty + accuracy display, maybe we could do 1.000.000 scoring style next?
		Def.BitmapText {
			Font="inter medium 25px",
			InitCommand=function(self)
				self:settext(PlayerResult(Detail, PLAYER_1)):xy(-StatsX, Scoring == "New" and -18 or -1):halign(0):zoom(0.62):diffusealpha(0)
					:maxwidth(math.max(100, SCREEN_WIDTH / 2 - 40)):strokecolor(Color.Black)
			end,
			OnCommand=function(self)
				self:sleep(i*0.25):easeinexpo(0.3):zoom(0.62):diffusealpha(1) end
		},
		Def.BitmapText {
			Font="inter medium 25px",
			InitCommand=function(self)
				self:settext(PlayerResult(Detail, PLAYER_2)):xy(StatsX, Scoring == "New" and -18 or -1):halign(1):zoom(0.62):diffusealpha(0)
					:maxwidth(math.max(100, SCREEN_WIDTH / 2 - 40)):strokecolor(Color.Black)
			end,
			OnCommand=function(self)
				self:sleep(i*0.25):easeinexpo(0.3):zoom(0.62):diffusealpha(1) end
		}
	}

    -- lettergrade n plate
	for _, pn in ipairs({PLAYER_1, PLAYER_2}) do
		local GradeTexture = LetterGrade(Detail, pn)
		if GradeTexture then
			t[#t+1] = Def.Sprite {
				InitCommand=function(self)
					self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), BoxY)
					self:Load(GradeTexture)
					:diffusealpha(0):zoom(0):sleep(i*0.25):easeoutexpo(0.25):zoom(GradeZoom):diffusealpha(1)
				end
			}
		end

        local PlateTexture = Plates(Detail, pn)
		if PlateTexture then
            t[#t+1] = Def.Sprite {
				InitCommand=function(self)
					self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and PlateX or -PlateX), BoxY + 10)
					self:Load(PlateTexture)
					:diffusealpha(0):zoom(0):sleep(i*0.25):easeoutexpo(0.25)
					:zoom(PlateZoom):diffusealpha(1)
				end
			}
		end
	end
    
end

return t
