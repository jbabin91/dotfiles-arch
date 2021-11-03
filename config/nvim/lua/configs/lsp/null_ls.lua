local status_ok, null_ls = pcall(require, 'null-ls')

if status_ok then
  local b = null_ls.builtins

  local sources = {
    b.code_actions.gitsigns,
    require("null-ls.helpers").conditional(function(utils)
      return utils.root_has_file(".eslintrc.js") and b.formatting.eslint_d or b.formatting.prettier
    end),
    b.formatting.stylua.with({
      condition = function(utils)
        return utils.root_has_file("stylua.toml")
      end
    }),
    b.formatting.trim_whitespace,
    b.formatting.shfmt,
    b.formatting.fixjson,
    b.formatting.json_tool,
    b.formatting.rustfmt,
    b.diagnostics.shellcheck,
    b.diagnostics.write_good,
    b.diagnostics.shellcheck.with({
      diagnostics_format = "#{m} [#{c}]",
    }),
    b.code_actions.gitsigns,
    b.diagnostics.yamllint,
  }

  local M = {}

  M.setup = function(on_attach)
    null_ls.config({
      -- debug = true,
      sources = sources,
    })
    require("lspconfig")["null-ls"].setup(require("coq").lsp_ensure_capabilities({ on_attach = on_attach }))
  end

  return M
end
