local timeDelay = 0
local t = Def.ActorFrame{
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gradient background"),
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center():diffusecolor(Color.Red)
        end,
    },
	
	--[[Def.Sprite {
		Texture="tg_stage_crash_2",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoom(1.4):diffusealpha(0.4):accelerate(0.2):zoom(0.9):decelerate(0.1):zoom(1):sleep(0.3):linear(0.7):diffusealpha(0)			
		end
	},]]--
	
	Def.ActorFrame {
		InitCommand=function(self)
				self:xy(SCREEN_CENTER_X+300, SCREEN_CENTER_Y)
				:diffusealpha(0)
				:shadowlength(3)
				:shadowcolor(0,0,0,0.25)
				:zoom(0.9)
				:sleep(timeDelay)
				:accelerate(0.25)
				:diffusealpha(1)
				:x(SCREEN_CENTER_X-10)
				:decelerate(0.1)
				:x(SCREEN_CENTER_X)
				:zoom(0.9):linear(4.9):zoom(1)
			end,
			
		Def.Sprite {
			Texture="tg_stage_crash_1",
			InitCommand=function(self)
				self:cropleft(0.5):sleep(0.6):accelerate(0.1):y(22):rotationz(1):decelerate(0.1):y(20)
			end
		},
		Def.Sprite {
			Texture="tg_stage_crash_1",
			InitCommand=function(self)
				self:cropright(0.5):sleep(0.6):accelerate(0.1):rotationz(-2):decelerate(0.1):rotationz(-2.3)
			end
		},
	},
	

    Def.Sprite {
        Texture="tg_stage_crash_3",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 10, SCREEN_CENTER_Y+100)
            :diffuse(color("#FF0000"))
            :zoom(0.4):diffusealpha(0)
            :sleep(0.3):linear(4):diffusealpha(1):zoom(0.45):y(SCREEN_CENTER_Y+120)
        end
    },

    Def.Sound {
        File="pipe",
        OnCommand=function(self)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },

    Def.Sound {
        File="stage_crash",
        OnCommand=function(self)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },
	
	Def.Quad {
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
            :Center():diffuse(1,1,1,0)
        end,

        OnCommand=function(self)
            self:sleep(timeDelay+0.1):diffusealpha(1):sleep(0.1):easeoutexpo(0.4)
            :diffusealpha(0)
        end
    },
    
    Def.Quad {
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
            :Center():diffuse(0,0,0,0)
        end,

        OnCommand=function(self)
            self:sleep(2.9)
            :linear(0.7)
            :diffusealpha(1)
        end
    }
}

return t
