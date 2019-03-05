function deepCopy(t)
    local nt={}
    for k,v in pairs(t) do
        if(type(v)=="table") then
            nt[k]=deepCopy(v)
        else
            nt[k]=v
        end
    end
    return nt
end

function mergeTable(a,b) -- merge b in to a and return a.
    for k,v in pairs(b) do
        a[k]=v
    end
    return a
end
    

data:extend({
    mergeTable(deepCopy(data.raw['arithmetic-combinator']['arithmetic-combinator']),{
        name="microchip",
        minable={hardness=0.2,mining_time=0.5,result="microchip"}
    }),
    {
        type="item",
        name="microchip",
        place_result="microchip",
        icon="__base__/graphics/icons/constant-combinator.png",
        icon_size=32,
        stack_size=10,
        subgroup='circuit-network'
    },
    {
        type="recipe",
        name="microchip",
        ingredients={{"iron-plate",1}},
        energy_required=1,
        results={{"microchip",1}}
    },
    {
        type="custom-input",
        name="microchip-open",
        key_sequence="mouse-button-1"
    }
})