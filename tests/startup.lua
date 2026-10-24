local ok, err = xpcall(function()
  assert(vim.v.errmsg == "", vim.v.errmsg)
  assert(_G.Obsidian and Obsidian.opts, "Obsidian setup did not finish")
  assert(pcall(require, "blink.cmp"), "Completion failed to load")
end, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd("cquit 1")
else
  print("Editor startup passed: Obsidian and completion load")
  vim.cmd("qa!")
end
