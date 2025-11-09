term.clear()
term.setCursorPos(1,2)
print("Proceeding with the operation will overwrite any files with the same name, do you understand? Y/N")
local a = read()

if a == "Y" then
    local username = "Sillylittleguy1"
    local repo = "singularity-OS"
    local branch = "beta"
    
    local baseURL = "https://raw.githubusercontent.com/" .. username .. "/" .. repo .. "/" .. branch .. "/"
    local apiBaseURL = "https://api.github.com/repos/" .. username .. "/" .. repo .. "/contents/"
    
    -- Function to download a single file
    local function downloadFile(filePath)
        local url = baseURL .. filePath
        print("Downloading: " .. filePath)
        
        -- Create directory structure if needed
        local directory = fs.getDir(filePath)
        if directory ~= "" and not fs.exists(directory) then
            fs.makeDir(directory)
        end
        
        local response = http.get(url)
        if response then
            local content = response.readAll()
            response.close()
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
    
    -- Function to get folder contents recursively
    local function getFolderContents(folderPath)
        local url = apiBaseURL .. folderPath .. "?ref=" .. branch
        print("Fetching folder: " .. folderPath)
        
        local response = http.get(url, {
            ["User-Agent"] = "ComputerCraft"
        })
        
        if not response then
            error("Failed to fetch folder: " .. folderPath)
        end
        
        local data = response.readAll()
        response.close()
        
        local success, contents = pcall(textutils.unserializeJSON, data)
        if not success then
            error("Failed to parse JSON for: " .. folderPath)
        end
        
        if contents.message then
            error("API Error: " .. contents.message)
        end
        
        local files = {}
        
        for _, item in ipairs(contents) do
            if item.type == "file" then
                table.insert(files, item.path)
            elseif item.type == "dir" then
                -- Recursively get files from subdirectory
                local subFiles = getFolderContents(item.path)
                for _, subFile in ipairs(subFiles) do
                    table.insert(files, subFile)
                end
            end
        end
        
        return files
    end
    
    -- Main download logic
    local function downloadFolder(folderPath)
        print("Processing folder: " .. folderPath)
        local files = getFolderContents(folderPath)
        
        for _, file in ipairs(files) do
            downloadFile(file)
        end
        
        return #files
    end
    
    -- Download individual files and folders
    local itemsToDownload = {
        "startup.lua",
        "os"  -- This will be handled as a folder
    }
    
    for _, item in ipairs(itemsToDownload) do
        if string.sub(item, -4) == ".lua" or string.find(item, "%.") then
            -- It's a file
            downloadFile(item)
        else
            -- It's a folder - download recursively
            local fileCount = downloadFolder(item)
            print("Downloaded " .. fileCount .. " files from " .. item)
        end
    end
    
    print("All files downloaded successfully!")
    sleep(2)
    term.clear()
    
else
    print("Operation canceled.")
    sleep(1)
    term.clear()
end
