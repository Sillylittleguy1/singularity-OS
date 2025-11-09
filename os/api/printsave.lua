local printsave = {}

-- Adds a printsave method to the file handle
function printsave.addPrintSave(file)
  function file.printsave(text)
    print(text)           -- Print to terminal
    file.writeLine(text)  -- Write to file
  end
end

return printsave
