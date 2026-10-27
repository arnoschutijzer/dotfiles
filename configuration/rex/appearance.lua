-- Reset first so repeated runs keep the same font size.
local reset, err = pcall(rex.client.queue, "client.font.reset")
if not reset then
    -- A disabled reset is harmless only if the increases below can still run.
    local unavailable = [["Reset Font Size" isn't available here right now.]]
    if not tostring(err):find(unavailable, 1, true) then
        error(err, 0)
    end
end

rex.client.queue("client.font.increase")
rex.client.queue("client.font.increase")
