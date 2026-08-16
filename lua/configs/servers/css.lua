local M = {}

function M.setup(capabilities)
  -- Use the css parser for GTK css (waybar) so highlighting still works
  vim.treesitter.language.register("css", "gtkcss")

  -- CSS Variables
  vim.lsp.config("css_variables", {
    capabilities = capabilities,
    filetypes = { "css", "scss", "sass", "less", "typescriptreact", "javascriptreact" },
  })

  -- CSS LSP
  vim.lsp.config("cssls", {
    capabilities = capabilities,
    root_markers = { "package.json" },
    settings = {
      css = { validate = true, lint = { unknownAtRules = "ignore" } },
      scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      less = { validate = true, lint = { unknownAtRules = "ignore" } },
    },
  })

  -- GTK CSS: same server, but skip validation since GTK syntax
  -- (@define-color, @color refs) is not valid standard CSS
  vim.lsp.config("gtkcss", {
    capabilities = capabilities,
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "gtkcss" },
    settings = {
      css = { validate = false, lint = { unknownAtRules = "ignore" } },
      scss = { validate = false, lint = { unknownAtRules = "ignore" } },
      less = { validate = false, lint = { unknownAtRules = "ignore" } },
    },
  })

  -- Binary comes from the cssls mason package; enable directly since
  -- "gtkcss" is not a valid lspconfig server name for mason to install
  vim.lsp.enable("gtkcss")

  -- CSS Modules
  vim.lsp.config("cssmodules_ls", {
    capabilities = capabilities,
    filetypes = { "typescriptreact", "javascriptreact" },
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
      less = {
        validate = true,
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  })
end

return M
