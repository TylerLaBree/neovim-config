local M = {}

-- Helper function to get sorted journal entries
local function get_journal_entries()
  local journal_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
  local entries = {}
  for _, file in ipairs(vim.fn.readdir(journal_dir)) do
    if file:match("%.md$") then -- Include only files ending with .md
      table.insert(entries, journal_dir .. "/" .. file)
    end
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
    if (direction == "next" and index < #entries) or (direction == "prev" and index > 1) then
        local target_index = direction == "next" and index + 1 or index - 1
        local current_buf = vim.api.nvim_get_current_buf()
        vim.cmd("edit " .. entries[target_index])
        vim.api.nvim_buf_delete(current_buf, { force = false })
    else
      print("No more journal entries in this direction.")
    end
  else
    print("Current file is not recognized as a journal entry.")
  end
end

function M.open_pdf()
    local current_dir = vim.fn.expand("%:p:h")
    local file_base = vim.fn.expand("%:t:r") -- Get the current file's base name (without extension)
    local pdf_file = current_dir .. "/" .. file_base .. ".pdf"
    local command = "flatpak run org.gnome.Papers " .. pdf_file .. " &"
    if vim.loop.fs_stat(pdf_file) then
        vim.fn.jobstart(command, { detach = true })
    else
        print("There is no such pdf.")
    end
end

function M.compile_with_marp()
    local current_dir = vim.fn.expand("%:p:h")
    local file_base = vim.fn.expand("%:t:r") -- Get the current file's base name (without extension)
    local md_file = current_dir .. "/" .. file_base .. ".md"
    local pdf_file = current_dir .. "/" .. file_base .. ".pdf"
    local Job = require'plenary.job'
    Job:new({
        command = 'marp',
        args = {
            '--no-stdin',
            '--config', '/home/tyler/.config/marp/config.yml',
            '-o', pdf_file,
            '--', md_file,
        },
    }):start()
end

return M

