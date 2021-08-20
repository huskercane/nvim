require('settings')    -- lua/settings.lua
require('maps')    -- lua/maps.lua
local cmd = vim.cmd

cmd 'packadd paq-nvim'
require('plugins') -- plugins
require('lsp')    --- lua/lsp.lua

-- Compe setup
local compe = require 'compe'
compe.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        nvim_lsp = true;
    };
}

-- local t = function(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

local tag_file = function(ctag_dir, ending)
	tag_files = {}
    local uv = require("luv")
    local x_ctag_dir = ctag_dir

    if ending == nil then
        ending = '.tags'
    end

    if x_ctag_dir == nil then
        local temp_ctag_dir = uv.os_homedir()
        if temp_ctag_dir == nil then
            return
        end
       x_ctag_dir = temp_ctag_dir..'/'..'.ctags.d' 
    end


    local scan_dir = function(err, success)
        -- check err
        if err ~= nil then return end
        while true do
            -- if file then add to tags list
            local name, type = uv.fs_scandir_next(success)
            if  name == nil then
                break
            end
            if type == 'file' and name:sub(-#ending) == ending then
                table.insert(tag_files, x_ctag_dir..'/'..name)
	        end
        end
    end

    local x = uv.fs_scandir(x_ctag_dir)
    if x ~= nil then
        scan_dir(nil, x)
	    vim.o.tags = table.concat(tag_files, ",")
    end
end
tag_file()
