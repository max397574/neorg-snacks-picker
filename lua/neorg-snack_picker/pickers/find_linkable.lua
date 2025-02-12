---@module "snacks"

local utils = require("neorg-snack_picker.utils")

return function(opts)
    opts = opts or {}

    local current_workspace = utils.get_current_workspace()

    if not current_workspace then
        return
    end

    Snacks.picker.grep({
        finder = "grep",
        live = false,
        supports_live = true,
        dirs = { current_workspace },
        title = "Find Linkables",

        search = function()
            return [[^\s*(\*+|\|{1,2}|\${1,2})\s+]]
        end,
        ---@param item snacks.picker.Item
        ---@param picker snacks.Picker
        format = function(item, picker)
            local ret = {}
            return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
        end,
        previewer = function(ctx)
            Snacks.picker.preview.file(ctx)
        end,
    })
end
