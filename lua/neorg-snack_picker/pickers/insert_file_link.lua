---@module "snacks"

local utils = require("neorg-snack_picker.utils")

local neorg = require("neorg.core")

--- Get the title set in the metadata block of file
--- @param file string
--- @return string?
local function get_file_title(file)
    local dirman = neorg.modules.get_module("core.dirman")
    if not dirman then
        return nil
    end

    local ts = neorg.modules.get_module("core.integrations.treesitter")
    if not ts then
        return nil
    end

    local metadata = ts.get_document_metadata(file)
    if not metadata or not metadata.title then
        return nil
    end
    return metadata.title
end

return function(opts)
    opts = opts or {}

    local current_workspace = utils.get_current_workspace()

    if not current_workspace then
        return
    end

    Snacks.picker.files({
        finder = "files",
        live = false,
        supports_live = true,
        dirs = { current_workspace },
        title = "Find Norg Files",
        args = { "-e", "norg" },

        ---@param item snacks.picker.Item
        ---@param picker snacks.Picker
        format = function(item, picker)
            local ret = {}
            return vim.list_extend(ret, Snacks.picker.format.file(item, picker))
        end,
        previewer = function(ctx)
            Snacks.picker.preview.file(ctx)
        end,
        actions = {
            confirm = function(picker, entry)
                local Path = require("pathlib")

                local file = Path(entry.file)
                local relative = file:relative_to(Path(current_workspace)):tostring()

                picker:close()
                local title = get_file_title(entry.file)

                vim.api.nvim_put({
                    "{" .. ":$/" .. relative .. ":" .. "}" .. "[" .. (title or relative) .. "]",
                }, "c", false, true)
                vim.api.nvim_feedkeys("hf]a", "t", false)
            end,
        },
    })
end
