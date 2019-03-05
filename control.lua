function debugPrint(fmt,...)
    game.players[1].print(string.format(fmt,...))
end

function shallowCopy(t)
    local nt={}
    for k,v in pairs(t) do 
        nt[k]=v
    end
    return nt
end

function makeEnv()
    return {
        _VERSION=_G._VERSION,
        assert=_G.assert,
        error=_G.error,
        getmetatable=_G.getmetatable,
        ipairs=_G.ipairs,
        load=function(c,n,m,e)
            return _G.load(c,n,"t",e)
        end,
        next=_G.next,
        pairs=_G.pairs,
        pcall=_G.pcall,
        print=nil, -- see below.
        rawequal=_G.rawequal,
        rawget=_G.rawget,
        rawlen=_G.rawlen,
        rawset=_G.rawset,
        select=_G.select,
        setmetatable=_G.setmetatable,
        tonumber=_G.tonumber,
        tostring=_G.tostring,
        type=_G.type,
        xpcall=_G.xpcall,

        math=shallowCopy(math),
        string=shallowCopy(string),
        table=shallowCopy(table)
    }
end

script.on_event({
    defines.events.on_built_entity, 
    defines.events.on_robot_built_entity
},function(event)
    local entity=event.created_entity
    if(entity.name and entity.name=="microchip") then
        debugPrint("microchip placed")
        if(not global.microchips) then
            global.microchips={}
        end
        global.microchips[entity]={
            code="",
            env=makeEnv(),
            running=false
        }
    end
end)

script.on_event("microchip-open",function(event)
    local player=game.players[event.player_index]
    local entity=player.selected
    if entity and entity.name=="microchip" then
        entity.operable=false -- This disable the original combinator window poped up.
        if(not global.player_chip) then
            global.player_chip={}
        end
        -- Save the entity to opened chip list.
        local tdata=global.player_chip[event.player_index] or {}
        tdata.viewing=entity
        global.player_chip[event.player_index]=tdata

        chipGUI(player,entity)
    end
end)

script.on_event(defines.events.on_gui_click,function(event)
    local player=game.players[event.player_index]
    local element=event.element
    if(element.name and element.name=="btn-close") then
        debugPrint("GUI Close")
        if(player.gui.center.microchip) then
            player.gui.center.microchip.destroy()
        end
    end
end)

function chipGUI(player, entity)
    local guiRoot=player.gui.center
    if(guiRoot.microchip) then
        guiRoot.microchip.destroy()
    end

    local window=guiRoot.add({
        type="frame",
        name="microchip",
        caption="Micro Chip GUI"
    })

    local outerflow=window.add({
        type="flow",
        name="outer",
        direction="vertical"
    })

    local buttons_row=outerflow.add({
        type="flow",
        name="buttons_row",
        direction="horizontal"
    })

    buttons_row.add({
        type="button",
        name="btn-save",
        caption="Save & Compile"
    })

    buttons_row.add({
        type="button",
        name="btn-run",
        caption="Run & Restart"
    })

    buttons_row.add({
        type="button",
        name="btn-stop",
        caption="Stop"
    })

    buttons_row.add({
        type="button",
        name="btn-close",
        caption="Close"
    })

    local textrow=outerflow.add({
        type="flow",
        name="textflow",
        direction="vertical"
    })

    textrow.add({
        type="label",
        name="status",
        caption="Ready"
    })

    textrow.add({
        type="label",
        name="running",
        caption=global.microchips[entity].running and "Chip: Running" or "Chip: Stopped"
    })

    textrow.add({
        type="text-box",
        name="codepanel",
        text="print('Hello World')"
    })

    debugPrint("GUI created.")
end

