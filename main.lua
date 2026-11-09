local previous_clock

function on_enable(config, context)
    previous_clock = jackal.modules.exists("Clock") and jackal.modules.get("Clock")
    jackal.notify(config["Lua Greeting"] .. " | FPS: " .. jackal.variables.get("fps"), "success", context.module)
end

function on_update(config, context)
    if not jackal.modules.exists("Clock") then return end
    local current_clock = jackal.modules.get("Clock")
    if current_clock ~= previous_clock then
        previous_clock = current_clock
        jackal.notify(current_clock and "Clock enabled" or "Clock disabled", "info", context.module)
    end
end

function on_disable(config, context)
    jackal.notify("Lua module stopped", "info", context.module)
end
