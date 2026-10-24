local ok, err = xpcall(function()
  assert(vim.v.errmsg == "", vim.v.errmsg)
  assert(_G.Obsidian and Obsidian.opts, "Obsidian setup did not finish")
  assert(vim.deep_equal(Obsidian.opts.checkbox.order, { " ", "x" }))
  assert(pcall(require, "blink.cmp"), "Completion failed to load")
  assert(vim.fn.exists(":CodeCompanion") == 0)
  assert(vim.fn.exists(":Copilot") == 0)
  assert(not pcall(require, "copilot"))
end, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd("cquit 1")
else
  print("Editor startup passed: Obsidian and completion load, AI plugins absent")
  vim.cmd("qa!")
end
