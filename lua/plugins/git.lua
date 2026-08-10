return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      -- Prevent attaching while inside Diffview or a diff split
      on_attach = function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("^diffview://") then
          return false
        end

        local ok, lib = pcall(require, "diffview.lib")
        if ok and lib.get_current_view() ~= nil then
          return false
        end

        for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
          if vim.api.nvim_win_is_valid(win) and vim.wo[win].diff then
            return false
          end
        end
      end,

      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 200,
      max_file_length = 10000,

      preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
  },
  {
    "dlyongemallo/diffview-plus.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = {
      hooks = {
        -- Detach gitsigns when entering a diff buffer
        diff_buf_win_enter = function(bufnr, winid)
          if vim.wo[winid].winbar == "%{%v:lua.dropbar()%}" then
            vim.wo[winid].winbar = ""
          end

          pcall(require("gitsigns").detach, bufnr)
        end,

        -- Re-attach gitsigns to all normal buffers when Diffview closes
        view_closed = function()
          vim.schedule(function()
            local ok, gitsigns = pcall(require, "gitsigns")
            if not ok then
              return
            end

            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_is_valid(bufnr) then
                pcall(gitsigns.attach, bufnr)
              end
            end
          end)
        end,
      },

      status_icons = {
        ["A"] = "✓", -- Added to index (Staged)
        ["?"] = "★", -- Untracked
        ["M"] = "✗", -- Modified in working tree (Unstaged)
        ["R"] = "➜", -- Renamed
        ["C"] = "✓", -- Copied (treated as a type of staged addition)
        ["T"] = "✗", -- Type changed (Unstaged metadata mutation)
        ["U"] = "", -- Unmerged (Conflict)
        ["D"] = "", -- Deleted
        ["B"] = "✗", -- Broken/Incomplete (Unstaged error state)
        ["!"] = "◌", -- Ignored
      },

      use_icons = true,
      enhanced_diff_hl = true,
      clean_up_buffers = true,

      view = {
        merge_tool = {
          layout = "diff3_mixed",
          winbar_info = false,
        },
        default = { winbar_info = false },
        file_history = { winbar_info = false },
      },

      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          { "n", "<M-e>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle Explorer" } },

          { "n", "<tab>", false },
          { "n", "<s-tab>", false },

          {
            "n",
            "<M-Right>",
            function()
              require("diffview.actions").select_next_entry()
            end,
            { desc = "Open the diff for the next file" },
          },
          {
            "n",
            "<M-Left>",
            function()
              require("diffview.actions").select_prev_entry()
            end,
            { desc = "Open the diff for the previous file" },
          },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          { "n", "<M-e>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle Explorer" } },
          { "n", "R", "<cmd>DiffviewRefresh<cr>", { desc = "Refresh" } },

          { "n", "<tab>", false },
          { "n", "<s-tab>", false },

          {
            "n",
            "<M-Right>",
            function()
              require("diffview.actions").select_next_entry()
            end,
            { desc = "Open the diff for the next file" },
          },
          {
            "n",
            "<M-Left>",
            function()
              require("diffview.actions").select_prev_entry()
            end,
            { desc = "Open the diff for the previous file" },
          },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          { "n", "<M-e>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle Explorer" } },

          { "n", "<tab>", false },
          { "n", "<s-tab>", false },

          {
            "n",
            "<M-Right>",
            function()
              require("diffview.actions").select_next_entry()
            end,
            { desc = "Open the diff for the next file" },
          },
          {
            "n",
            "<M-Left>",
            function()
              require("diffview.actions").select_prev_entry()
            end,
            { desc = "Open the diff for the previous file" },
          },
        },
      },
    },
  },
}
