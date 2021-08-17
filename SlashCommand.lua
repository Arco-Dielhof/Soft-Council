if SoftCouncil == nil then SoftCouncil = {} end
if SoftCouncil.SlashCommands == nil then
    SoftCouncil.SlashCommands = {}
    SLASH_SLC1 = '/slc'
    SlashCmdList['SLC'] = function(arg)
        local fn = SoftCouncil.SlashCommands[arg]
        if type(fn) == "function" then
            fn()
        end
    end
end