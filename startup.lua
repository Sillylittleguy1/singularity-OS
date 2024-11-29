term.clear()
term.setCursorPos(1,1)  -- Ensure printing starts at the top left corner
checks = 1
check1 = 0
local function check()
  check1 = check1 + 1
  print("[" .. check1 .. "/" .. checks .. "]")
end
local time = textutils.formatTime(os.time(utc))  
if fs.exists("os/main") == False then
    term.setCursorPos(1, 18)
    printError("Missing OS files! \"how did we get here?\" lookin ahh")
else
  check()
end
if fs.exists("install.lua") then
    fs.copy("install.lua", "os/install.lua") 
    fs.delete("install.lua")  
end
sleep(3)
shell.run("os/main")
