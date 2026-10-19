local UseBasicMode

-- Fallback fix
Branch.TitleMenu = function()
    -- home mode is the most assumed use of sm-ssc.
    if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
        return "ScreenTitleMenu"
    end
    -- arcade junk:
    if GAMESTATE:GetCoinsNeededToJoin() > GAMESTATE:GetCoins() then
        -- if no credits are inserted, don't show the Join screen. SM4 has
        -- this as the initial screen, but that means we'd be stuck in a
        -- loop with ScreenInit. No good.
        return "ScreenLogo"
    else
        return "ScreenTitleJoin"
    end
end

function SelectMusicOrCourse()
    UseBasicMode = LoadModule("Config.Load.lua")("BasicMode","Save/OutFoxPrefs.ini") or false
    
    -- Required to avoid unplayable songs and more
    UpdateGroupSorting()
    
    if GAMESTATE:IsCourseMode() then
        return "ScreenSelectCourse"
    elseif getenv("IsBasicMode") and UseBasicMode then
        return "ScreenSelectMusicBasic"
    else
        return "ScreenSelectMusicFull"
    end
end

function ToLoadOrNotToLoad()
    if GAMESTATE:IsAnyHumanPlayerUsingMemoryCard() then
        return "ScreenProfileLoad"
    else
        return SelectMusicOrCourse()
    end
end

-- if no more stages, go over to evaluation summary and then game over
local function GameOverOrSummary()
    if SessionEvaluationSummary and #SessionEvaluationSummary > 0 then
        return "ScreenEvaluationSummary"
    end
    return GameOverOrContinue()
end

CustomBranch = {
    StartGame = function()
        -- clear play result details when a new game is started
        SessionEvaluationSummary = {}
        
        if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
            return "ScreenHowToInstallSongs"
        end
        if PROFILEMAN:GetNumLocalProfiles() > 0 then
            return "ScreenSelectProfile"
        else
            setenv("IsBasicMode", true)
            return SelectMusicOrCourse()
        end
    end,
    AfterSelectProfile = function()
        UseBasicMode = LoadModule("Config.Load.lua")("BasicMode","Save/OutFoxPrefs.ini") or false
        
        return ToLoadOrNotToLoad()
    end,
    AfterProfileSave = function()
        if GAMESTATE:IsEventMode() then
            return SelectMusicOrCourse()
        elseif STATSMAN:GetCurStageStats():AllFailed() then
            -- even if the player fails, still show the play result, does cause a bug where the profile decks appear on fail but not when you clear all songs
            return GameOverOrSummary()
        end
        
        -- If a player has ran out of stages, unjoin them
        if GAMESTATE:GetNumStagesLeft(PLAYER_1) <= 0 then GAMESTATE:UnjoinPlayer(PLAYER_1) end
        if GAMESTATE:GetNumStagesLeft(PLAYER_2) <= 0 then GAMESTATE:UnjoinPlayer(PLAYER_2) end
        
        -- This is done so that if a player has joined mid
        -- session can still play the rest of their stages.
        if GAMESTATE:GetNumSidesJoined() <= 0 then
            return GameOverOrSummary()
        else
            return SelectMusicOrCourse()
        end
    end,

}
