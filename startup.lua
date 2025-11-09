local printsave = require("os/api/printsave")
term.clear()
term.setCursorPos(1, 1)  -- Ensure printing starts at the top left corner

-- Create the directory and file if needed
if fs.exists("tmp/sys") then
  if not fs.isDir("tmp/sys") then
    print("Error: tmp/sys exists but is not a directory.")
    return
  end
else
  fs.makeDir("tmp/sys")
end
if fs.exists("install.lua") then
    shell.run("mv install.lua os/install.lua")
end
if not fs.exists("tmp/sys/log.log") then
  local file = fs.open("tmp/sys/log.log", "w")
  if file then
    file.close()
    print("Created tmp/sys/log.log")
  else
    print("Error: Could not create log.log")
    return
  end
else
  print("start logging")
end

check = {}
check.__index = check

-- This function can be condensed if unneeded
function check:create(list)
  local chk = {}
  setmetatable(chk, check)
  chk.list = list
  return chk
end

-- Pass the file object as a parameter to the check function
function check:check(file)
  local valid = nil
  for i = 1, #self.list do
    if fs.exists(self.list[i]) then
      valid = "exists"
    else
      valid = "Missing"
    end
    file.printsave("[" .. #self.list .. "/" .. i .. "] " .. self.list[i] .. " " .. valid)
  end
end

-- Create and use check objects
check1 = check:create({"os", "home", "tmp", "root", "usr"})
check2 = check:create({"os/main.lua", "os/install.lua", "os/api/button.lua", "os/api/clear_exept.lua", "tmp/sys/log.log"})

-- Open file for writing
local file = fs.open("tmp/sys/log.log", "w")
if file then
  printsave.addPrintSave(file)  -- Add the printsave method to the file handle
  check1:check(file)
  check2:check(file)
  file.close()  -- Close the file when done
else
  print("Error: Could not open file for writing.")
end

sleep(4)
shell.run("os/main")
