local pn = GAMESTATE:GetMasterPlayerNumber()
local IsTwoPlayer = (GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersTwoSides")
local IsDouble = (GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides")
local IsCenter = (IsDouble or Center1Player() or GAMESTATE:GetIsFieldCentered(pn))
local FieldWidth = math.ceil(GAMESTATE:GetCurrentStyle():GetWidth(pn) * 0.75) + 48

local BasicMode = getenv("IsBasicMode")

-- force the colors to the BasicMode Counterpart when we are on Demo Play
local IsDemonstration = GAMESTATE:IsDemonstration()

return Def.ActorFrame {
    InitCommand=function(self)
        self:y(SCREEN_TOP + 22)
        if IsCenter and not IsTwoPlayer then
            
            self:x(SCREEN_CENTER_X + (GAMESTATE:IsPlayerEnabled(PLAYER_2) and -FieldWidth or FieldWidth))
        else
            self:x(SCREEN_CENTER_X)
        end
    end,
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/tg_stageindicator_base"),
        InitCommand=function(self) self:zoom(0.8):y(8) end
    },
	-- pulse to the beat, i know noteskins already do this, but why not (tiny)
	Def.ActorFrame {
	InitCommand=function(self) 
		self:y(8):zoom(0.8)
		-- this looks convoluted af lmao
		:diffuse(IsDemonstration and (color("#00CCBB")) or (BasicMode and (color("#00CCBB")) or (color("#DD0030")))) end,
		
		Def.Sprite {
			Texture=THEME:GetPathG("", "UI/tg_glow_stageindicator"),	
			InitCommand=function(self) self:diffuseramp():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,0.5")):effectperiod(1):effectclock('beat') end
		},
		Def.Sprite {
			Texture=THEME:GetPathG("", "UI/tg_glow_stageindicator"),	
			InitCommand=function(self) self:diffuseramp():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,1")):effectperiod(4):effectclock('beat') end
		}
	},
    Def.BitmapText {
        Font="_praetorian numbers 42px",
        Text=string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1),
        InitCommand=function(self)
            self:y(15):zoomx(0.65):zoomy(0.75):strokecolor(IsDemonstration and (color("#00BBAA")) or (BasicMode and (color("#00BBAA")) or (color("#FF0040"))))
        end
    }
}
