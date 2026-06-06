GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local UpvalueHacker = require "upvaluehacker"

Assets =
{
    Asset("ATLAS", "images/Aporkalypse_Clock.xml"), -- 灾变日历
    Asset("IMAGE", "images/Aporkalypse_Clock.tex"),
}

local _G = GLOBAL
local SaveTimeData = _G.SaveTimeData


-- [[岛屿冒险 - 海难]]
_G.EVENTS.twister                       = { name = STRINGS.NAMES.TWISTER , anim = "idle_loop", build = "twister_build", bank = "twister", scale = 0.02, offset = -10}
_G.EVENTS.chessnavy                     = { name = STRINGS.NAMES.KNIGHTBOAT, anim = "idle_loop", build = "knightboat_build", bank = "knightboat", scale = 0.09, offset = -10 } -- 浮船骑士
_G.EVENTS.krakener                      = { name = STRINGS.NAMES.KRAKEN, anim = "idle_loop", build = "quacken", bank = "quacken", scale = 0.03, offset = -10 } -- 海妖
_G.EVENTS.tigersharker                  = { name = STRINGS.NAMES.TIGERSHARK, anim = "taunt", build = "tigershark_ground_build", bank = "tigershark", scale = 0.02, offset = -10 } -- 虎鲨
_G.EVENTS.volcanomanager                = { name = STRINGS.UI.CUSTOMIZATIONSCREEN.DRAGOONEGG, anim = "active_idle_pst", build = "volcano", bank = "volcano", scale = 0.0077, offset = -15 } -- 火山爆发
_G.EVENTS.klaussack_tropical_spawntimer = { name = STRINGS.NAMES.KLAUS_SACK_TROPICAL, anim = "idle", build = "klaus_bag_tropical", bank = "klaus_bag", scale = 0.08, offset = -16 } -- 热带赃物袋

-- [[云霄国度-Above The Clouds]]
_G.EVENTS.aporkalypse                   = { name = STRINGS.UI.SERVERLISTINGSCREEN.SEASONS.APORKALYPSE, tex = "Aporkalypse_Clock.tex", xml = "images/Aporkalypse_Clock.xml", size = 40 } -- 大灾变
_G.EVENTS.pig_bandit_respawn_time_      = { name = STRINGS.NAMES.PIGBANDIT, anim = "idle_loop", build = "pig_bandit", bank = "townspig", scale = 0.07, offset = -15 } -- 蒙面猪人
_G.EVENTS.batted                        = { name = STRINGS.UI.CUSTOMIZATIONSCREEN.VAMPIREBAT, anim = "fly_loop", build = "bat_vamp_build", bank = "bat_vamp", scale = 0.09, offset = -27 } -- 吸血蝙蝠袭击
_G.EVENTS.ROC_RESPAWN_TIMER             = { name = STRINGS.NAMES.ROC_HEAD, anim = "idle_loop", build = "roc_head_build", bank = "head", scale = 0.01, offset = -20 } -- 友善的大鹏
_G.EVENTS.GRUB_RESPAWN_TIME             = { name = STRINGS.UI.CUSTOMIZATIONSCREEN.GIANTGRUB_SETTING, anim = "idle", build = "giant_grub", bank = "giant_grub", scale = 0.15, offset = -7 } -- 巨型蛆虫
_G.EVENTS.ancient_herald                = { name = STRINGS.NAMES.ANCIENT_HERALD, anim = "idle", build = "ancient_spirit", bank = "ancient_spirit", scale = 0.05, offset = -10 } -- 远古先驱
_G.EVENTS.pugalisk_fountain             = { name = STRINGS.NAMES.PUGALISK_FOUNTAIN, anim = "flow_loop", build = "python_fountain", bank = "fountain", scale = 0.02, offset = -10}

AddPrefabPostInit("world", function(inst)
    if TheWorld:HasTag("island") then
        -- 猎犬替换为鳄狗
        _G.EVENTS.hound = { name = STRINGS.NAMES.CROCODOG , anim = "run_loop", build = "crocodog", bank = "crocodog", scale = 0.08, offset = -14 }
    elseif TheWorld:HasTag("volcano") then
        -- 猎犬替换为鳄狗(虽然火山没有猎犬袭击)
        _G.EVENTS.hound = { name = STRINGS.NAMES.CROCODOG , anim = "run_loop", build = "crocodog", bank = "crocodog", scale = 0.08, offset = -14 }
    end
end)

if TheNet:GetIsClient() then return end -- 客户端止步于此

AddPrefabPostInit("world", function(inst)
    if TheWorld:HasTag("island") then
        inst:DoPeriodicTask(TUNING.UPTATE, function()
            -- 豹卷风
            local twister_time = TheWorld.components.worldsettingstimer:GetTimeLeft("twister_timetoattack")
            if twister_time then
                SaveTimeData("twister", math.floor(twister_time))
            end
            -- 浮船骑士
            local chessnavy_time = TheWorld.components.chessnavy and TheWorld.components.chessnavy.spawn_timer
            if chessnavy_time then
                SaveTimeData("chessnavy", math.floor(chessnavy_time))
            end

            -- 海妖
            local kraken_time = TheWorld.components.krakener and TheWorld.components.krakener:TimeUntilCanSpawn()
            if kraken_time then
                SaveTimeData("krakener", math.floor(kraken_time))
            end

            -- 虎鲨
            if TheWorld.components.tigersharker and TheWorld.components.tigersharker:CanSpawn(true,true) then
                local appear_time = TheWorld.components.tigersharker:TimeUntilCanAppear()
                local respawn_time = TheWorld.components.tigersharker:TimeUntilRespawn()
                local max = math.max(appear_time, respawn_time)
                SaveTimeData("tigersharker", math.floor(max))
            end

            -- 火山爆发
            if TheWorld.components.volcanomanager and TheWorld.components.volcanomanager:GetNumSegmentsUntilEruption() then
                local ActualTime = (TUNING.TOTAL_DAY_TIME * (TheWorld.state.time * 100)) / 100
                local ActualSeg = math.floor(ActualTime / 30)
                local TimeInSeg = ActualTime - (ActualSeg * 30)
                local SegUntilEruption = TheWorld.components.volcanomanager:GetNumSegmentsUntilEruption() or 0
                local seconds = math.floor((SegUntilEruption * 30) - TimeInSeg)
                seconds = math.floor(seconds + 0.5)
                SaveTimeData("volcanomanager", math.floor(seconds))
            end

        end)
    elseif TheWorld:HasTag("volcano") then
        -- 火山爆发
        inst:DoPeriodicTask(TUNING.UPTATE, function()
            if TheWorld.components.volcanomanager and TheWorld.components.volcanomanager:GetNumSegmentsUntilEruption() then
                local ActualTime = (TUNING.TOTAL_DAY_TIME * (TheWorld.state.time * 100)) / 100
                local ActualSeg = math.floor(ActualTime / 30)
                local TimeInSeg = ActualTime - (ActualSeg * 30)
                local SegUntilEruption = TheWorld.components.volcanomanager:GetNumSegmentsUntilEruption() or 0
                local seconds = math.floor((SegUntilEruption * 30) - TimeInSeg)
                seconds = math.floor(seconds + 0.5)
                SaveTimeData("volcanomanager", math.floor(seconds))
            end
        end)
    elseif TheWorld:HasTag("porkland") then
        -- 大灾变
        AddComponentPostInit("aporkalypse", function(self)
            inst:DoPeriodicTask(TUNING.UPTATE, function()
                local Next_Aporkalypse_Time = UpvalueHacker.GetUpvalue(self.OnUpdate, "_timeuntilaporkalypse")
                if Next_Aporkalypse_Time then
                    Next_Aporkalypse_Time = Next_Aporkalypse_Time:value()
                    if Next_Aporkalypse_Time > 0 then -- 现在不是大灾变
                        SaveTimeData("aporkalypse", math.floor(Next_Aporkalypse_Time)) -- 大灾变倒计时

                        -- 吸血蝙蝠(正常计算)
                        if TheWorld.components.batted and TheWorld.components.batted.LongUpdate then
                            local next_attack_in = UpvalueHacker.GetUpvalue(TheWorld.components.batted.LongUpdate, "_bat_attack_time")
                            if next_attack_in then
                                SaveTimeData("batted", math.floor(next_attack_in))
                            end
                        end
                    else
                        -- 大灾变进行时（处理蝙蝠和远古先驱）
                        local next_bat_attack = UpvalueHacker.GetUpvalue(self.OnUpdate, "_bat_time") -- 吸血蝙蝠袭击
                        local next_herald_attack = UpvalueHacker.GetUpvalue(self.OnUpdate, "_herald_time") -- 远古先驱

                        if next_bat_attack then
                            SaveTimeData("batted", math.floor(next_bat_attack))
                        end

                        if next_herald_attack then
                            SaveTimeData("ancient_herald", math.floor(next_herald_attack))
                        end
                    end
                end
            end)
        end)

        -- 蒙面猪人
        AddComponentPostInit("banditmanager", function(self)
            inst:DoPeriodicTask(TUNING.UPTATE, function()
                local str = self:GetDebugString()
                local stolen_oincs, active_bandit, respawns_in = string.match(str, "Stolen Oincs: (%d+) Active Bandit: (%a+) Respawns In: ([%d%.%-]+)")
                if respawns_in then
                    respawns_in = tonumber(respawns_in) or 0
                    SaveTimeData("pig_bandit_respawn_time", math.floor(respawns_in))
                end
            end)
        end)
    end
end)

-- 云霄国度-不老泉
AddPrefabPostInit("pugalisk_fountain", function(self)
    self:DoPeriodicTask(TUNING.UPTATE, function()
        if self.resettaskinfo then
            local seconds = self:TimeRemainingInTask(self.resettaskinfo)
            SaveTimeData("pugalisk_fountain", seconds)
        end
    end)
end)