---@diagnostic disable: lowercase-global

local function zh_en(zh, en)  -- Other languages don't work
    local chinese_languages =
    {
        zh = "zh", -- Chinese for Steam
        zhr = "zh", -- Chinese for WeGame
        ch = "zh", -- Chinese mod
        chs = "zh", -- Chinese mod
        sc = "zh", -- simple Chinese
        zht = "zh", -- traditional Chinese for Steam
        tc = "zh", -- traditional Chinese
        cht = "zh", -- Chinese mod
    }

    if chinese_languages[locale] ~= nil then
        lang = chinese_languages[locale]
    else
        lang = en
    end

    return lang ~= "zh" and en or zh
end

name = zh_en("饥饥事件计时器加强", "Don't Event Timer Plus")
description = zh_en([[
加强饥饥事件计时器Mod
使它支持显示
岛屿冒险 - 海难模组中的：豹卷风、虎鲨、火山、浮船骑士、海妖 倒计时显示
云霄国度模组中的：吸血蝙蝠、不老泉、蒙面猪人、友善的大鹏、大灾变、大灾变期间的蝙蝠/远古先驱 倒计时显示
]], [[
Enhances the Don't Event Timer mod
Adds countdown displays for:
Island Adventures - Shipwrecked : Sealnado, Tiger Shark, Volcano, Floaty Boaty Knight, Quacken
Above the Clouds : Vampire Bat, Fountain of Youth, Masked Pig, BFB, Aporkalypse, and bats/Ancient Herald during the Aporkalypse
]])
author = "冰冰羊"
version = "2025-08-31"
dst_compatible = true
forge_compatible = false
gorge_compatible = false
dont_starve_compatible = false
client_only_mod = false
all_clients_require_mod = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
api_version_dst = 10
priority = -2
mod_dependencies = {
    { workshop = "workshop-3511498282" }, -- 饥饥事件计时器
}
server_filter_tags = {"饥饥事件计时器加强", "Don't Event Timer Plus"}