local bitser = require 'core.lib.bitser'
local md5 = require 'core.lib.md5'
local SaveEngine = {}
SaveEngine.__index = SaveEngine

function SaveEngine:new ()
  local ins = setmetatable({}, self)
  ins._dataStores = {}
  ins.loadedData = {}

  return ins
end

function SaveEngine:loadData (saveInt)
  local fileInfo = love.filesystem.getInfo("save"..saveInt)
  if fileInfo ~= nil then
    local rawSave = self:readFromDisk(saveInt)
    local decodedSave = bitser.loads(rawSave)
    self.loadedData = decodedSave
    self._dataStores = decodedSave
  end
end

function SaveEngine:readFromDisk (saveInt)
  local content, size = love.filesystem.read("save"..saveInt)
  return content
end
function SaveEngine:saveToDisk (saveInt)
  local success, message = love.filesystem.write("save"..saveInt, self:encode(self._dataStores))
end

function SaveEngine:createDataStore (name)
  self._dataStores[name] = {}
end

function SaveEngine:getDataStore (dataStore)
  local store = self._dataStores[dataStore]
  if not store then return end
  return store
end

function SaveEngine:setDataStore (dataStore, data)
  local store = self._dataStores[dataStore]
  if not store then return end
  table.insert(store, data)
end
function SaveEngine:getItemIndex (dataStore, id)
  local store = self._dataStores[dataStore]
  if not store then return end
  local itemIndex = nil
  for k,v in ipairs(store) do
    if v[id] == id then
      itemIndex = k
    end
  end
  return itemIndex
end

function SaveEngine:saveItem (dataStore, item)
  local store = self._dataStores[dataStore]
  if not store then return end
  table.insert(store, item)
end

function SaveEngine:clearDataStore (dataStore)
  local store = self._dataStores[dataStore]
  if not store then return end
  for k in pairs(store) do
    store[k] = nil
  end
end

function SaveEngine:removeItem (dataStore, itemID)
  local store = self._dataStores[dataStore]
  if not store then return end
  local itemIndex = nil
  for k,v in ipairs(store) do
    if v.id == itemID then
      itemIndex = k
    end
  end
  table.remove(store, itemIndex)
end

function SaveEngine:encode (table)
  local encoded = bitser.dumps(table)
  return encoded
end

function SaveEngine:decode (data)
  local decoded = bitser.loads(data)
  return decoded
end

return SaveEngine
