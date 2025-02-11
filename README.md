# telescope-pkm-find-or-create.nvim

Telescope PKM Find or Create is a simple tool designed to create a new file if none is found, acting as a Telescope selector.

PKM stands for [Personal Knowledge Management](https://en.wikipedia.org/wiki/Personal_knowledge_management).

## Background

This plugin is a fragment of a larger effort aimed at building a Personal Knowledge Manager within Neovim.

One of the useful features of [Obsidian](https://obsidian.md/) is the CTRL+O (or CMD+O) binding, which searches for existing notes or creates a new one if no such note exists. This functionality was missing as a Telescope extension, so this plugin fills that gap.

This small feature significantly reduces friction when creating new notes on the go, potentially boosting productivity.

## Installation and Usage

To use this plugin, include it using your preferred package manager, and then load the extension in Telescope. Here's an example of a self-contained [lazy.nvim](https://github.com/folke/lazy.nvim) configuration which can be copy/pasted into a new file and then referenced in the lazy setup `spec` property:

```lua
return {
    {
        "micku/telescope-pkm-find-or-create.nvim",
        cond = function()
            local cwd = vim.fn.getcwd()
            local folder_name = "My PKM"

            return cwd:sub(-#folder_name) == folder_name
        end,
        config = function()
            require("telescope").setup({
                extensions = {
                    pkm_find = {
                        subfolder = "Notes",
                        file_extension = "md",
                    },
                },
            })
            require("telescope").load_extension("pkm_find")

            vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope pkm_find find_or_create<cr>", { noremap = true, silent = true })
        end
    }
}
```

### Configuration Breakdown

Here's a step-by-step breakdown of the most relevant configuration parts:

* `cond` enables the plugin only if the current working directory (cwd) is the "My PKM" folder, which is the root of the PKM repository.
* The `config` section does a few things:
  * `require("telescope").setup()` runs on top of the main Telescope configuration, keeping all plugin configurations in one place.
  * The `pkm_find` extension is then configured with two options:
    * `subfolder` is a subfolder of the PKM path where new files will be created. If omitted or empty, files are created in the root directory.
    * `file_extension` is the file extension for the new files. This can also be omitted or left empty to not add an extension.
  * `require("telescope").load_extension("pkm_find")` instructs Telescope to load the new extension.
  * `vim.api.nvim_set_keymap...` binds the find or create function, overriding the default finder used in any other working directory in my case.
