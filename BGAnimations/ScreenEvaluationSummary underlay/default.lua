local Song = SessionEvaluationSummary or {}
local FirstSong = math.max(1, #Song - 7)
local SongCount = math.max(1, #Song - FirstSong + 1)
local rowY = math.min(60, 300 / SongCount)
local rowTop = SCREEN_CENTER_Y - (SongCount * rowY) / 2 + rowY / 2

local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"
local ClassicGrades = LoadModule("Config.Load.lua")("ClassicGrades", "Save/OutFoxPrefs.ini") and Scoring == "Old"

local GradeZoom = 0.2
local PlateZoom = 0.4
local GradeX = IsUsingWideScreen() and 520 or 370
local PlateX = IsUsingWideScreen() and 430 or 265

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
    LoadActor(THEME:GetPathB("","HudPanels"))..{}
}

for i = FirstSong, #Song do
	local Detail = Song[i]
	local BoxY = rowTop + (i - FirstSong) * rowY
	t[#t+1] = Def.Quad {
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, BoxY):zoomto(SCREEN_WIDTH - 80, rowY - 2)
				:diffuse(color("#000000")):diffusealpha(0.7):fadeleft(0.1):faderight(0.1)
		end,
        OnCommand=function(self)
            self:zoomto(SCREEN_WIDTH - 80, 0):sleep(i*0.2):easeoutexpo(0.6):zoomto(SCREEN_WIDTH - 80, rowY - 2) end
	}
    -- song title
	t[#t+1] = Def.BitmapText {
		Font="inter medium 25px",
		Text=Detail.Title or "Unknown",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, BoxY - 2):zoom(0):diffusealpha(0)
				:maxwidth(math.max(100, SCREEN_WIDTH / 2 - 40)):strokecolor(Color.Black)
		end,
        OnCommand=function(self)
            self:zoomy(0.68):zoomx(1.3):sleep(i*0.2):easeoutexpo(0.3):zoom(0.68):diffusealpha(1) end
	}

    -- lettergrade n plate
	for _, pn in ipairs({PLAYER_1, PLAYER_2}) do
		local GradeTexture = LetterGrade(Detail, pn)
		if GradeTexture then
			t[#t+1] = Def.Sprite {
				InitCommand=function(self)
					self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and GradeX or -GradeX), BoxY)
					self:Load(GradeTexture)
					:diffusealpha(0):zoom(0):sleep(i*0.3):easeoutexpo(0.25):zoom(GradeZoom):diffusealpha(1)
				end
			}
		end

        local PlateTexture = Plates(Detail, pn)
		if PlateTexture then
			t[#t+1] = Def.ActorFrame {
                Def.Sprite {
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and PlateX or -PlateX), BoxY + 10)
						self:Load(PlateTexture)
						:diffusealpha(0):zoom(0):sleep(i*0.3):easeoutexpo(0.25)
						:zoom(PlateZoom):diffusealpha(1)
					end
				},
			}
		end
	end
    -- difficulty + accuracy display, maybe we could do 1.000.000 scoring style next?
	t[#t+1] = Def.BitmapText {
		Font="inter medium 25px",
		Text=PlayerResult(Detail, PLAYER_1),
		InitCommand=function(self)
			self:xy(SCREEN_LEFT+170, BoxY + (Scoring == "New" and -18 or -1)):halign(0):zoom(0.62):diffusealpha(0)
				:maxwidth(math.max(100, SCREEN_WIDTH / 2 - 40)):strokecolor(Color.Black)
		end,
        OnCommand=function(self)
            self:sleep(i*0.3):easeoutexpo(0.3):zoom(0.62):diffusealpha(1) end
	}
	t[#t+1] = Def.BitmapText {
		Font="inter medium 25px",
		Text=PlayerResult(Detail, PLAYER_2),
		InitCommand=function(self)
			self:xy(SCREEN_RIGHT-170, BoxY + (Scoring == "New" and -18 or -1)):halign(1):zoom(0.62):diffusealpha(0)
				:maxwidth(math.max(100, SCREEN_WIDTH / 2 - 40)):strokecolor(Color.Black)
		end,
        OnCommand=function(self)
            self:sleep(i*0.3):easeoutexpo(0.3):zoom(0.62):diffusealpha(1) end
	}
end

return t
