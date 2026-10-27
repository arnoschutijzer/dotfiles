-- Run inside a Rex session with cwd=/absolute/path/to/project.
local cwd = rex.args.cwd
if type(cwd) ~= "string" or cwd:sub(1, 1) ~= "/" then
    error("pass cwd=/absolute/path/to/project (on the Rex server)", 0)
end

local function shell()
    return rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        options = { cwd = cwd },
    }
end

local window, err = rex.session.new_window{
    window_label = "Development",
    layout = rex.layout.horizontal(0.5, shell(), shell()),
}
if err ~= nil then
    error(err, 0)
end
return window
