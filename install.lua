term.clear()
term.setCursorPos(1,2)
print("Proceeding with the operation will overwrite any files with the same name, do you understand? Y/N")
local a = read()

if a == "Y" then
    local username = "Sillylittleguy1"
    local repo = "singularity-OS"
    local branch = "main"
    local files = {
        "os/api/button.lua",
        "startup.lua",
        "os/main.lua",
    }
    local baseURL = "https://raw.githubusercontent.com/" .. username .. "/" .. repo .. "/" .. branch .. "/"
    
    local function downloadFile(file)
        local url = baseURL .. file
        print("Downloading: " .. file)
        local response = http.get(url)
        if response then
            local content = response.readAll()
            response.close()
            local f = fs.open(file, "w")
            f.write(content)
            f.close()
            print("Downloaded: " .. file)
        else
            print("Failed to download: " .. file)
        end
    end

    for _, file in ipairs(files) do
        downloadFile(file)
    end
    print("All files downloaded.")
    sleep(1)
    term.clear()
  else
  print("Operation canceled.")
  sleep(1)
  term.clear()
end
