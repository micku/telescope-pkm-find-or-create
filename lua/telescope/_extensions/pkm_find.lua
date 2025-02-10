local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")
local path = require("plenary.path")

local config = {
  subfolder = "",
  file_extension = ""
}

local function build_destination_path()
  local cwd = vim.fn.getcwd()
  local file_path = path:new(cwd)

  if config.subfolder == "" then
    return file_path
  end

  return file_path:joinpath(config.subfolder)
end

local function build_file_name(current_line)
  if config.file_extension == "" then
    return current_line
  end

  return current_line .. "." .. config.file_extension
end

local function open_or_create_file_handler(prompt_bufnr)
  return function()
    actions.close(prompt_bufnr)

    local selection = action_state.get_selected_entry()
    if selection then
      return vim.cmd.edit(selection[1])
    end

    local current_line = action_state.get_current_line()
    if current_line == "" then
      return
    end

    local file_path = build_destination_path()
    local file_name = build_file_name(current_line)

    return vim.cmd.edit(file_path:joinpath(file_name):absolute())

  end
end

local function handle_selection(prompt_bufnr)
  actions.select_default:replace(open_or_create_file_handler(prompt_bufnr))
  return true
end

local function find_or_create()
  local opts = {
    attach_mappings = handle_selection
  }

  builtin.find_files(opts)
end

local function merge_configs(user_config)
  config = vim.tbl_deep_extend("force", {}, config, user_config or {})
end

return telescope.register_extension {
    setup = merge_configs,
    exports = {
      find_or_create = find_or_create
    }
}
