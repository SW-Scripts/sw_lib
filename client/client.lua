local QBCore = exports['qb-core']:GetCoreObject()

-- This handles the opening of a stash inventory. This will open the inventory for the player to view and interact with. The event will depend on which framework/inventory resource you use.
local function OpenStash(stashName, maxweight, slots)
    if Config.Inventory == 'qb' then
        TriggerServerEvent('sw_lib:server:openInventory', stashName, maxweight, slots)
    elseif Config.Inventory == 'ox' then
        TriggerServerEvent('sw_lib:server:openInventory', stashName, maxweight, slots)
        exports.ox_inventory:openInventory('stash', stashName)
    else
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashName, { maxweight = maxweight, slots = slots })
        TriggerEvent('inventory:client:SetCurrentStash', stashName)
    end
end
exports('OpenStash', OpenStash)

-- This handles the opening of the management/boss menu. This allows players with boss privileges to manage their businesses.
local function OpenManagement()
    if Config.Management == 'qb' then
        TriggerEvent('qb-bossmenu:client:OpenMenu')
    end
end
exports('OpenManagement', OpenManagement)

-- This handles the cash register/till payments. This is optional, but will charge the player for a given payment amount. By default, this is only configured for jim-payments (https://github.com/jimathy/jim-payments).
local function ChargePlayer()
    if Config.Payments == 'jim' then
        TriggerEvent('jim-payments:client:Charge')
    end
end
exports('ChargePlayer', ChargePlayer)

-- This handles the triggering of player animations. If you are configuring this to handle a different animations menu, use the event that triggers an emote here.
local function StartEmote(emote)
    if Config.Animations == 'rpemotes' then
        TriggerEvent('animations:client:EmoteCommandStart', {emote})
    else
        TriggerEvent('animations:client:EmoteCommandStart', {emote})
    end
end
exports('StartEmote', StartEmote)

-- Similar to the above, this handles the cancelling of player animations. If you are configuring this to handle a different animations menu, use the event that cancels an emote here.
local function CancelEmote()
    if Config.Animations == 'rpemotes' then
        exports['rpemotes']:EmoteCancel()
    else
        TriggerEvent('animations:client:EmoteCommandStart', {'c'})
    end
end
exports('CancelEmote', CancelEmote)

-- This handles stating whether the player is in an active animation, or not. This may not be required for all animations menus.
local function SetPlayerInAnimation(bool)
    if Config.Animations == 'rpemotes' then
        exports['rpemotes']:IsPlayerInAnim(bool)
    end
end
exports('SetPlayerInAnimation', SetPlayerInAnimation)

-- This handles the toggling of duty status. This is used to toggle the player's duty status, such as on/off duty.
local function ToggleDuty()
    if Config.ToggleDuty == 'qb' then
        TriggerServerEvent('QBCore:ToggleDuty')
    end
end
exports('ToggleDuty', ToggleDuty)

-- This handles the opening of the wardrobe. This allows players to change their outfits.
local function OpenWardrobe()
    if Config.Wardrobe == 'qb' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    end
end
exports('OpenWardrobe', OpenWardrobe)

-- This handles the displaying of a notification message.
RegisterNetEvent('sw_lib:client:Notify', function(message, type)
    if Config.Notify == 'qb' then
        QBCore.Functions.Notify(message, type)
    elseif Config.Notify == 'ox' then
        lib.notify({
            title = message,
            type = type
        })
    end
end)

-- This handles the displaying of an item box. This is used to show the player when they have gained or lost an item.
RegisterNetEvent('sw_lib:client:ItemBox', function(item, type, amount)
	if Config.Inventory == 'qb' then
		TriggerEvent('qb-inventory:client:ItemBox', item, type, amount)
	else
		TriggerEvent('inventory:client:ItemBox', item, type, amount)
	end
end)

-- This handles the display of menu items. This will display a given menu image on screen to the player. By default, this is only set to use ps-ui (https://github.com/Project-Sloth/ps-ui).
RegisterNetEvent('sw_lib:client:displayImage', function(imageLink)
    if Config.MenuDisplay == 'ps-ui' then
        exports['ps-ui']:ShowImage(imageLink)
    end
end)

-- This handles the starting of a skillbar. This is used to show the player a skillbar to complete a task. If set to 'none', it will automatically complete the task without a minigame.
RegisterNetEvent('sw_lib:client:startSkillbar', function(args)
	if Config.Skillbar == 'none' then
		TriggerEvent(args.resource..':client:finishSkillbar', args, 1)
	elseif Config.Skillbar == 'ps-ui' then
		exports['ps-ui']:Circle(function(success)
			if success then
				TriggerEvent(args.resource..':client:finishSkillbar', args, 1)
			else
				TriggerEvent(args.resource..':client:finishSkillbar', args)
			end
		end, 4, 10) -- NumberOfCircles, MS
	elseif Config.Skillbar == 'ox' then
		local success = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
		if success then
			TriggerEvent(args.resource..':client:finishSkillbar', args, 1)
		else
			TriggerEvent(args.resource..':client:finishSkillbar', args)
		end
	elseif Config.Skillbar == 'qb' then
		local success = exports['qb-minigames']:Skillbar()
		if success then
			TriggerEvent(args.resource..':client:finishSkillbar', args, 1)
		else
			TriggerEvent(args.resource..':client:finishSkillbar', args)
		end
	end
end)

-- This handles the triggering of police dispatch alerts.
RegisterNetEvent('sw_lib:client:startDispatch', function(alert)
    if Config.Dispatch == 'ps' then
        if alert == 'GraveRobbery' then
            exports['ps-dispatch']:GraveRobbery()
        elseif alert == 'CoralRobbery' then
            exports['ps-dispatch']:CoralRobbery()
        elseif alert == 'ContainerRobbery' then
            exports['ps-dispatch']:ContainerRobbery()
        elseif alert == 'SuspiciousActivity' then
            exports['ps-dispatch']:SuspiciousActivity()
        elseif alert == 'Poaching' then
            exports['ps-dispatch']:Poaching()
        elseif alert == 'TerminalHack' then
            exports['ps-dispatch']:TerminalHack()
        elseif alert == 'TrainRobbery' then
            exports['ps-dispatch']:TrainRobbery()
        end
    end
end)