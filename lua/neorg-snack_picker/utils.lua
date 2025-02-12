local utils = {}

local neorg = require("neorg.core")

---Gets the full path to the current workspace
---@return string?
utils.get_current_workspace = function()
    local dirman = neorg.modules.get_module("core.dirman")
    if dirman then
        ---@diagnostic disable-next-line: undefined-field
        local current_workspace = dirman.get_current_workspace()[2]:tostring()
        return current_workspace
    end
    return nil
end

return utils
