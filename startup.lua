term.clear()
term.setCursorPos(1,1)  -- Ensure printing starts at the top left corner
check = True
local time = textutils.formatTime(os.time(utc))  
print("singularity OS[v1.0b]", time)
print("                                 @         ")
print("                      @@::@    :           ")
print("              :    @@::@@                  ")
print("                 @@@::@          @@@       ")
print("               @@:-@     @@@@::::@@@::@    ")
print("              @@:     @@@@:@@          @   ")
print("            @ @:     @@@::@   @         @  ")
print("              @:    @@@  @@::  @    @      ")
print("                @    @  ::@@  @@@    :@    ")
print("            @         @   @::@@@     :@ @  ")
print("             @          @@:@@@@     :@@    ")
print("              @::@@@::::@@@@     @-:@@     ")
print("                 @@@          @::@@@       ")
print("                            @@::@@    :    ")
print("                     :    @::@@            ")
print("                   @                       ")
print("[                                                 ]")
term.setCursorPos(2,18)
textutils.slowPrint("=================================================")
if fs.exists("/main") == False then
  term.setCursorPos(1,18)
  print("             Error, missing file main.lua                 ")
  check = False
end
sleep(2)
if check == True then
shell.run("main")
end
