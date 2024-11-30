term.clear()
term.setCursorPos(1,1)  -- Ensure printing starts at the top left corner
local check1 = 0
local check2 = 0
local checks = 2
local checks1 = 0
-- Function to increment and print the main check progress
local function check(text)
  check1 = check1 + 1
  print("[" .. check1 .. "/" .. checks .. "] " .. text)
end

-- Function to print the sub-check progress for each path
local function subcheck(text, num)
  check2 = check2 + 1
  print("-[" .. check2 .. "/" .. num .. "] " .. text)
end

-- Function to check the existence of paths
local function check_paths(paths)
  check2 = 0
  local num_paths = #paths  -- Get the number of paths
  checks1 = num_paths  -- Update `checks` to match the number of paths being checked
  for _, path in ipairs(paths) do
    if fs.exists(path) then
      subcheck(path .. " exists.", num_paths)
    else
      print(path .. " does not exist.")
    end
  end
  if check2 == num_paths then
    return 0
  else
    return 1
  end
end


-- Move the installer if it exists
if fs.exists("install.lua") then
  fs.copy("install.lua", "os/install.lua") 
  fs.delete("install.lua") 
  print("Installer moved to 'os/install.lua'")
else
  print("Installer move ignored")
end

print("checking sys")
if check_paths({"os", "home", "tmp", "root", "usr"}) == 0 then
  check("Root folders found")
else
  print("Root folders missing")
end

if check_paths({"os/main.lua","os/install.lua","os/api/button.lua","os/api/clear_exept.lua","tmp/sys/log.txt"}) == 0 then
  check("System files found")
else
  print("System files missing")
end


-- Sleep for 5 seconds and then run main script
sleep(5)
shell.run("os/main")
