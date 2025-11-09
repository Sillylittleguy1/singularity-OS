term.clear()
term.setCursorPos(1,2)
print("Proceeding with the operation will overwrite any files with the same name, do you understand? Y/N")
local a = read()

if a == "Y" then
    local username = "Sillylittleguy1"
    local repo = "singularity-OS"
    local branch = "beta"
    
    -- Define folders and files to download
    local items = {
        "startup.lua",
        "os"  -- This is a folder that we'll download recursively
    }
    
    local baseURL = "https://raw.githubusercontent.com/" .. username .. "/" .. repo .. "/" .. branch .. "/"
    
    local function downloadFile(filePath)
        local url = baseURL .. filePath
        print("Downloading: " .. filePath)
        local response = http.get(url)
        if response then
            local content = response.readAll()
            response.close()
            
            -- Create directory structure if needed
            local directory = fs.getDir(filePath)
            if directory ~= "" and not fs.exists(directory) then
                fs.makeDir(directory)
            end
            
            local f = fs.open(filePath, "w")
            f.write(content)
            f.close()
            print("Downloaded: " .. filePath)
            return true
        else
            print("Failed to download: " .. filePath)
            return false
        end
    end
    
    -- Function to get folder contents from GitHub API
    local function getFolderContents(folderPath)
        local apiURL = "https://api.github.com/repos/" .. username .. "/" .. repo .. "/contents/" .. folderPath .. "?ref=" .. branch
        print("Fetching folder structure: " .. folderPath)
        
        local response = http.get(apiURL, {
            ["User-Agent"] = "ComputerCraft"
        })
        
        if not response then
            print("Failed to access folder: " .. folderPath)
            return {}
        end
        
        local data = response.readAll()
        response.close()
        
        local success, contents = pcall(textutils.unserializeJSON, data)
        if not success or type(contents) ~= "table" then
            print("Failed to parse folder contents: " .. folderPath)
            return {}
        end
        
        return contents
    end
    
    -- Recursive function to download folder and all subfolders
    local function downloadFolder(folderPath)
        local contents = getFolderContents(folderPath)
        
        for _, item in ipairs(contents) do
            if item.type == "file" then
                downloadFile(item.path)
            elseif item.type == "dir" then
                -- Recursively download subfolder
                downloadFolder(item.path)
            end
        end
    end
    
    -- Download all items
    for _, item in ipairs(items) do
        if string.sub(item, -4) == ".lua" or string.find(item, "%.") then
            -- It's a file
            downloadFile(item)
        else
            -- It's a folder
            downloadFolder(item)
        end
    end
    
    print("All files downloaded.")
    sleep(1)
    term.clear()
else
    print("Operation canceled.")
    sleep(1)
    term.clear()
end
