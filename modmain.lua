local IsServer = GLOBAL.TheNet:GetIsServer()
local TUNING = GLOBAL.TUNING

-- Stuff from prefabs/bunnyman.lua
local beardlordloot = { "beardhair", "beardhair", "monstermeat" }
local regularloot = { "carrot", "carrot" }

local function IsCrazyGuy(guy)
    local sanity = guy ~= nil and guy.replica.sanity or nil
    return sanity ~= nil and sanity:IsInsanityMode() and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local function LootSetupFunction(lootdropper)
    local guy = lootdropper.inst.causeofdeath
    if IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
        -- beardlord loot
        lootdropper:SetLoot(beardlordloot)
    else
        -- regular loot
        lootdropper:SetLoot(regularloot)
        lootdropper:AddRandomLoot("meat", 3)
        lootdropper:AddRandomLoot("manrabbit_tail", 1)
        lootdropper.numrandomloot = 1
    end
end

if IsServer then
    AddPrefabPostInit("bunnyman", function(inst)
        if (inst.components.lootdropper == nil) then
            -- Something went wrong
            return
        end


        inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)
        LootSetupFunction(inst.components.lootdropper)
    end)
end
