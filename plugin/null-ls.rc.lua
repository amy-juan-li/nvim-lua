local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint]\n #{m}\n(#{c})'
    }),
    null_ls.builtins.diagnostics.fish,
    formatting.prettier,
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds { buffer = bufnr, group = augroup_format }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        -- buffer = 0,
        callback = function()
          vim.lsp.buf.formatting_seq_sync()
        end
      })
    end
  end,
})

-- Auto commands
vim.cmd([[ autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync() ]])
