local isInARoutingBucket = false

RegisterNetEvent('rrp_instance:inRoutingBucket')
AddEventHandler('rrp_instance:inRoutingBucket', function(isIn)
    isInARoutingBucket = isIn
end)

function createObject(obj)
    print("-------------------------------------------------")
    print("-------------------------------------------------")
    print("-------------------------------------------------")
    if isInARoutingBucket then
        print(obj)
        if DoesEntityExist(obj) then
            print("ittttztzzzzzzzzzzzzzz")

            local entityType = GetEntityType(obj)
            if entityType == 0 then
                return
            elseif entityType == 1 then
                obj = PedToNet(obj)
            elseif entityType == 2 then
                obj = VehToNet(obj)
            elseif entityType == 3 then
                obj = ObjToNet(obj)
            end
            print("ittttztzzzzzzzzzzzzzz")
            TriggerServerEvent('rrp_instance:registerItem', obj)
        end
    end
end
