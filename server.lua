ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local defaultDimension = 0
local createdDimensions = {} -- TODO: change to number
local playersEachDimensions = {}
local players = {}
local objects = {} -- redundancy, but may be useful later.
local objectsEachDimensions = {}

function enter(playerId, cb)
    local emptyDimension = nil
    for i=1, 1000, 1 do -- find empty routing bucket
        if not playersEachDimensions[i] then
            playersEachDimensions[i] = {
                [playerId] = true
            }
            emptyDimension = i
            players[playerId] = emptyDimension
            break
        end
    end
    if not createdDimensions[emptyDimension] then
        createdDimensions[emptyDimension] = true
        SetRoutingBucketPopulationEnabled(emptyDimension, false)
    end
    SetPlayerRoutingBucket(playerId, emptyDimension)
    TriggerClientEvent('rrp_instance:inRoutingBucket', playerId, true)
    if cb then
        cb(emptyDimension)
    end
end

function leave(playerId, cb)
    SetPlayerRoutingBucket(playerId, defaultDimension)
    TriggerClientEvent('rrp_instance:inRoutingBucket', playerId, false)
    local dim = players[playerId]
    print("elhagytam")
    if playersEachDimensions[dim] then
        playersEachDimensions[dim][playerId] = nil
        if next(playersEachDimensions[dim]) == nil then
            print("világ törlése")
            playersEachDimensions[dim] = nil
            TriggerEvent('rrp_instance:worldDestroy', dim)
            if objectsEachDimensions[dim] then
                for object, _ in pairs(objectsEachDimensions[dim]) do
                    if DoesEntityExist(object) then
                        DeleteEntity(object)
                        print("töröltem az objectet")
                    end
                    objects[object] = nil
                end
            end
            objectsEachDimensions[dim] = nil
        end
    end
    players[playerId] = nil
    if cb then
        cb(dim)
    end
end

function join(playerId, dimId, cb)
    playersEachDimensions[dimId][playerId] = true
    players[playerId] = dimId
    SetPlayerRoutingBucket(playerId, dimId)
    if cb then
        cb(dimId)
    end
end

function enterObject(dim, obj, cb)
    if not objectsEachDimensions[dim] then
        objectsEachDimensions[dim] = {}
    end
    objectsEachDimensions[dim][obj] = true
    objects[obj] = dim
    SetEntityRoutingBucket(obj, dim)
    if cb then
        cb(dim)
    end
end

function leaveObject(obj, cb)
    local dim = objects[obj]
    if dim then
        objectsEachDimensions[dim][obj] = nil
        objects[obj] = nil
        SetEntityRoutingBucket(obj, defaultDimension)
    end
    if cb then
        cb(dim)  
    end
end

function leaveAll(dim, cb)
    local ids = {}
    if playersEachDimensions[dim] then
        for playerId, _ in pairs(playersEachDimensions[dim]) do
            leave(playerId)
            table.insert(ids, playerId)
        end
    end
    if cb then
        cb(dim, ids)
    end
end

RegisterNetEvent('rrp_instance:registerItem')
AddEventHandler('rrp_instance:registerItem', function(netid)
    obj = NetworkGetEntityFromNetworkId(netid)
    if not DoesEntityExist(obj) then
        for i=1, 100, 1 do
            obj = NetworkGetEntityFromNetworkId(netid)
            if DoesEntityExist(obj) then
                break
            end
            Wait(100)
        end 
    end
    if DoesEntityExist(obj) then
        local dim = GetEntityRoutingBucket(obj)
        if dim ~= 0 then
            print(dim, obj)
            enterObject(dim, obj)
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    if players[playerId] then
        leave(playerId, cb)
    end
end)



