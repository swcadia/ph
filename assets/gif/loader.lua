--[[
Gif Player by VibeGPT
Project Owner: 1ksuwu
]]
local req = request or http_request or httprequest

local ROOT = "GifAssets"
local CAT  = "PH"

local SOURCES: { [string]: string } = {
	Alya = "https://raw.githubusercontent.com/swcadia/ph/refs/heads/main/assets/gif/Alya/data.luau",
}

local meta:   { [string]: { name: string, fps: number, frames: { string } } } = {}
local assets: { [string]: { [number]: string } } = {}


local function get(url: string): string
	local res = req({ Url = url, Method = "GET" })
	assert(res and res.StatusCode == 200, "SpriteLoader: request failed -> " .. url)
	return res.Body
end

local function ensureDir(path: string)
	local cur = ""
	for part in path:gmatch("[^\\]+") do
		cur = cur == "" and part or cur .. "\\" .. part
		if not isfolder(cur) then makefolder(cur) end
	end
end

local function charDir(name: string): string
	return ROOT .. "\\" .. CAT .. "\\" .. name
end

local function framePath(name: string, index: number): string
	return charDir(name) .. "\\frame_" .. string.format("%02d", index) .. ".png"
end

local function fetchMeta(name: string)
	if meta[name] then return meta[name] end

	local url = SOURCES[name]
	assert(url, "SpriteLoader: unknown character '" .. name .. "'")

	local fn, err = loadstring(get(url))
	assert(fn, "SpriteLoader: parse error for '" .. name .. "': " .. tostring(err))

	meta[name] = fn()
	return meta[name]
end

local function resolveFrame(name: string, index: number): string
	local path = framePath(name, index)

	if not isfile(path) then
		ensureDir(charDir(name))
		local url = fetchMeta(name).frames[index + 1]
		writefile(path, get(url))
	end

	return getcustomasset(path)
end


local SpriteLoader = {}

function SpriteLoader:Preload(name: string)
	if assets[name] then return end
	assets[name] = {}
	for i in ipairs(fetchMeta(name).frames) do
		assets[name][i - 1] = resolveFrame(name, i - 1)
	end
end

function SpriteLoader:GetGifFrame(name: string, index: number): string
	if assets[name] and assets[name][index] then
		return assets[name][index]
	end
	if not assets[name] then assets[name] = {} end
	assets[name][index] = resolveFrame(name, index)
	return assets[name][index]
end

function SpriteLoader:GetFPS(name: string): number
	return fetchMeta(name).fps
end

function SpriteLoader:GetFrameCount(name: string): number
	return #fetchMeta(name).frames
end

return SpriteLoader
