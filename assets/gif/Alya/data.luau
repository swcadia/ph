-- Alya Data
-- 30fps
local BASE = "https://raw.githubusercontent.com/swcadia/ph/refs/heads/main/assets/gif/Alya/"

local frames = {}
for i = 0, 59 do
    frames[i + 1] = BASE .. "1015_" .. string.format("%02d", i) .. ".png"
end

return {
    name   = "Alya",
    fps    = 30,
    frames = frames,
}
