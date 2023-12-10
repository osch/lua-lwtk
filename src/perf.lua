local time = require"chronos".nanotime -- https://luarocks.org/modules/ldrumm/chronos

local perf = {}

local t0
local timers = {}

function perf.reset() 
    t0 = nil
    timers = {}
end

function perf.start(name)
    if not t0 then
        t0 = time()
    end
    local timer = timers[name]
    if not timer then
        local timer = { name  = name, t0 = time(), dt = 0, count = 1, started = 1 }
        timers[name] = timer
        timers[#timers + 1] = timer
    else
        local started = timer.started
        if started > 0 then
            timer.started = started + 1
        else
            timer.t0 = time()
            timer.started = 1
        end
        timer.count = timer.count + 1
    end
end

function perf.stop(name)
    local timer = timers[name]
    local started = timer.started
    started = started - 1
    if started == 0 then
        local dt = time() - timer.t0
        timer.dt = timer.dt + dt
    end
    timer.started = started
end

function perf.finish() 
    print("----------------------------------------------------------------------------")
    local t1 = time()
    local nlen = 0
    local tlen = 0
    local clen = 0
    do
        for _, timer in ipairs(timers) do
            local len = #timer.name
            if len > nlen then
                nlen = len
            end
            local len = #string.format("%d", math.ceil(timer.dt * 1000))
            local len = #string.format("%d", timer.count)
            if len > clen then
                clen = len
            end
        end
        nlen = nlen + 8
        tlen = 4 + #string.format("%d", math.ceil((t1 - t0) * 1000))
    end
    for _, timer in ipairs(timers) do
        local name = timer.name
        io.write(string.format("%"..nlen.."s %"..tlen..".3f ms for %"..clen.."d", name..":", timer.dt * 1000, timer.count))
        if timer.count > 1 then
            io.write(string.format(" (avg: %.3f ms)", timer.dt * 1000 / timer.count))
        end
        io.write("\n")
        assert(timer.started == 0)
    end
    print(string.format("%"..nlen.."s %"..tlen..".3f ms", "total:", (t1 - t0) * 1000))
    print("----------------------------------------------------------------------------")
end

return perf