return Def.ActorFrame {
    -- simplified ScreenInit, i have plans to further improve this soon, but when? (tiny)
	-- i think we finally done it (tiny)
    -- bro wake up it's 2008
    CodeMessageCommand=function(self, param)
        if param.Name == "Secret" then
            if _G["Secret"] == true then
                _G["Secret"] = false
                MESSAGEMAN:Broadcast("SecretUpdated")
                SCREENMAN:SystemMessage("returning to "..Year())
            else
                _G["Secret"] = true
                MESSAGEMAN:Broadcast("SecretUpdated")
                SCREENMAN:SystemMessage("bro wake up it's 2008")
            end
        end
    end,

    -- Possibly unnecessary but last time I tried this it didn't work without
    -- it for ??? reasons so I'm not taking any risks
	
	-- AM style screen (1)
    Def.Quad {
      Name="Background1",
      InitCommand=function(self)
          self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
          :diffuse(Color.White):sleep(14):diffuse(Color.Black)
      end
    },
	
	Def.ActorFrame {
		-- AM Style OutFox intro by tiny
		Name="LogoMain",
		OnCommand=function(self) self:sleep(6):linear(0.7):diffusealpha(0) end,
		
		Def.Sprite {
			Name="OutFoxLogo0",
			Texture="OutFox",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(0):zoom(0.6):cropleft(0.29)
			end,
			OnCommand=function(self)
				self:sleep(2.9):linear(0.7):diffusealpha(1)
			end
		},
	
		Def.Sprite {
			Name="OutFoxLogo1",
			Texture="Fox",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(1):zoom(0.4)
			end,
			OnCommand=function(self)
				self:diffusealpha(0):sleep(0.5):linear(0.7):diffusealpha(1):sleep(0.6):linear(1):zoom(0.18):addx(-190)
			end
		}
		
	},
	
	Def.ActorFrame {
		-- tinygoat intro
		Name="tinyIntro",
		OnCommand=function(self) self:diffusealpha(0):sleep(7):linear(0.7):diffusealpha(1):sleep(4):linear(0.7):diffusealpha(0) end,
		
		Def.Sprite {
			Name="tinyLogo",
			Texture="tg_logo",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(0):zoom(0.6)
			end,
			OnCommand=function(self)
				self:diffusealpha(1):sleep(10.7):easeoutexpo(0.5):zoomx(0.8):zoomy(0)
			end
		},
		
	},
	
	-- the4kman intro
	Def.ActorFrame {
		-- the4kman logo
		Name="4kmanintro",
		OnCommand=function(self) self:diffusealpha(0):sleep(11.6):linear(0.7):diffusealpha(1):sleep(5):linear(0.7):diffusealpha(0) end,
		
		Def.Sound {
			File="the4k",
			InitCommand=function(self) self:sleep(10.6):queuecommand("Play") end,
			PlayCommand=function(self) self:play() end
		},
		
		Def.Quad {
			Name="Background1",
			InitCommand=function(self)
				self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
				:diffuse(color("#007fff")):diffusealpha(1)
			end,
		},
		
		Def.BitmapText {
			Name="text",
			Font="Eurostile Extended 32px",
			InitCommand=function(self)
				self:Center()
				:settext("SOUND BY"):zoomx(1):zoomy(1):diffusealpha(0)
				:sleep(11):easeoutexpo(0.7):diffusealpha(1):sleep(1.3):easeoutexpo(0.4):zoomx(1):zoomy(1.5):diffusealpha(0) end,
		},
		
		Def.Sprite {
			Name="4kman",
			Texture="4kman_logo",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(0):zoom(0.9)
			end,
			OnCommand=function(self)
				self:sleep(13.6):linear(0.5):zoom(0.8):diffusealpha(1)
			end
		},
	},
	
	-- the dj505 intro is back
	Def.Quad {
      Name="Background1",
      InitCommand=function(self)
          self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
          :diffuse(color("#7174e4")):diffusealpha(0)
      end,
	  OnCommand=function(self) self:sleep(18.6):linear(0.7):diffusealpha(1) end
    },
	
	Def.ActorFrame {
		-- dj505 logo
		Name="dj505intro",
		OnCommand=function(self) self:diffusealpha(0):sleep(19):linear(0.7):diffusealpha(1) end,
		
		Def.Sprite {
			Name="dj505_1",
			Texture="dj505_arrow",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(1):addx(-15):addy(10):zoom(0.36):rotationz(45)
			end,
			OnCommand=function(self)
				self:sleep(20.6):decelerate(1):rotationz(-135)
			end
		},
		
		Def.Sprite {
			Name="dj505_2",
			Texture="dj505_logo",
			InitCommand=function(self)
				self:Center()
				:diffusealpha(1):zoom(0.9)
			end
		},
		
	},
	

    Def.Quad {
        Name="ShutdownDark",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffuse(0,0,0,0)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(24.3):linear(0.7):diffuse(0,0,0,1)
        end
    },

    -- Transitions to the next screen after n seconds
    Def.Quad {
        Name="ScreenTransferActor",
        InitCommand=function(self)
               self:diffuse(0,0,0,0):sleep(25):queuecommand("Transfer")
        end,
        TransferCommand=function(self)
               SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }

}
