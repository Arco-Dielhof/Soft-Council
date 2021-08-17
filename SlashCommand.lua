if SoftCouncil == nil then SoftCouncil = {} end
if SoftCouncil.SlashCommands == nil then
    SoftCouncil.SlashCommands = {}
    SLASH_SCL1 = '/scl'
    SlashCmdList['SCL'] = function(arg)
        local fn = SoftCouncil.SlashCommands[arg]
        if type(fn) == "function" then
            fn()
        end
    end
end