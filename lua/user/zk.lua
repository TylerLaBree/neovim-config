local M = {}

-- Helper function to get sorted journal entries
local function get_journal_entries()
  local journal_dir = vim.fn.expand("$ZK_NOTEBOOK_DIR/journal/daily") -- Adjust the path to your journal directory
  local entries = {}

  for _, file in ipairs(vim.fn.readdir(journal_dir)) do
    table.insert(entries, journal_dir .. "/" .. file)
  end

  table.sort(entries)
  return entries
end

function M.open_journal_entry(direction)
  local current_path = vim.fn.expand("%:p")
  local entries = get_journal_entries()
  local index = nil

  for i, entry in ipairs(entries) do
    if entry == current_path then
      index = i
      break
    end
  end

  if index then
    if direction == "next" and index < #entries then
      vim.cmd("bdelete")  -- Delete the current buffer
      vim.cmd("edit " .. entries[index + 1])
    elseif direction == "prev" and index > 1 then
      vim.cmd("bdelete")  -- Delete the current buffer
      vim.cmd("edit " .. entries[index - 1])
    else
      print("No more journal entries in this direction.")
    end
  else
    print("Current file is not recognized as a journal entry.")
  end
end

return M

