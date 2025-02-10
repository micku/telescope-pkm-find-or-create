# Telescope PKM Find or Create

A simple Telescope selector that creates a new file if none is found.

## Background

This is a small piece of an effort to build a Personal Knowledge Manager within Neovim.

A small but useful feature of [Obsidian](https://obsidian.md/) is the CTRL+O (or CMD+O) binding which searches for existing notes or, if no such note exists, it creates a new one. I haven't found this already implemented as a Telescope extension.

This small feature reduces friction when creating new notes on the go, and I believe it boosts productivity, even just a tiny bit.

## How to use

Use your favourite package manager (or not) to include the plugin, and then load the extension in Telescope. Here is an example of a self-contained [lazy.nvim](https://github.com/folke/lazy.nvim) configuration which can be copy/pasted in a new file and then referenced in the lazy setup `spec` property:

```
return {
    {
        "micku/telescope-pkm-find-or-create",
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

Here is a breakdown of what is happening:

* Get the plugin from this repo;
* `cond` enables the plugin only if cwd is the "My PKM" folder, which is the root of the PKM repository;
* In the `config` section a few things happen:
  * `require("telescope").setup()` runs on top of the main Telescope configuration, this is helpful to keep all of this plugin configuration in the same place;
  * Then the `pkm_find` extension is configured, there are only 2 configuration options:
    * `subfolder` is a subfolder of the PKM path where new files will be created; it can be omitted/empty, in such case files are created in the root directory;
    * `file_extension` is the file extension of the files that will be created; this can also be omitted/empty to not add an extension.
  * `require("telescope").load_extension("pkm_find")` tells Telescope that it can load the new extension;
  * `vim.api.nvim_set_keymap...` binds the find or create function, in my case it overrides the default finder used in any other working directory.
