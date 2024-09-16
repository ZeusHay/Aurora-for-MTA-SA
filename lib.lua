local aurora = {
    cache = { fonts = {} },

    client = {
        loaded = false,
        width = nil,
        height = nil
    },

    internal = {
        _fontReducer = 0;
        _fontSet = 0.99;
        client = {
            width = nil,
            height = nil
        },

        convertPosition = function(self, x, y)
            local basew, baseh = 1920, 1080;
            local scale = math.min(self.client.width / basew, self.client.height / baseh);

            return (x - basew / 2) * scale + self.client.width / 2, (y - baseh / 2) * scale + self.client.height / 2;
        end,

        convertScale = function(self, w, h)
            local basew, baseh = 1920, 1080;
            local scalew, scaleh = self.client.width / basew, self.client.height / baseh;

            return w * scalew, h * scaleh;
        end,

        cache = { fonts = {} },
        loadFont = function(self, name, size, ...)
            if not self.cache.fonts[name] then self.cache.fonts[name] = {} end

            if not isElement(self.cache.fonts[name][size]) then
                self.cache.fonts[name][size] = dxCreateFont('assets/fonts/' .. name .. '.ttf', size - self._fontReducer, ...);
            end

            return self.cache.fonts[name][size];
        end
    },

    initialize = function(self, ...)
        self.client.loaded = true; self.client.width, self.client.height = guiGetScreenSize(); self.internal.client.width, self.internal.client.height = self.client.width, self.client.height;
        local __, ToReduce = nil, 0;

        local _Ranges = {
            {minRx = 1920, minRy = 1080, maxRx = 9999, maxRy = 9999, label = "Ultra", fontset = 0.92, reduce = 4},
            {minRx = 1760, minRy = 990, maxRx = 1920, maxRy = 1080, label = "0", fontset = 0.99, reduce = 0},
            {minRx = 1680, minRy = 1050, maxRx = 1760, maxRy = 990, label = "1", fontset = 1.03, reduce = 1},
            {minRx = 1600, minRy = 900, maxRx = 1680, maxRy = 1050, label = "2", fontset = 1.02, reduce = 2},
            {minRx = 1366, minRy = 768, maxRx = 1600, maxRy = 900, label = "3", fontset = 0.87, reduce = 2.5},
            {minRx = 1280, minRy = 720, maxRx = 1366, maxRy = 768, label = "4", fontset = 0.8148, reduce = 2.5},
            {minRx = 1152, minRy = 870, maxRx = 1280, maxRy = 720, label = "5", fontset = 0.92, reduce = 3},
            {minRx = 1152, minRy = 864, maxRx = 1280, maxRy = 720, label = "6", fontset = 0.92, reduce = 3},
            {minRx = 1128, minRy = 634, maxRx = 1280, maxRy = 720, label = "7", fontset = 0.90, reduce = 3},
            {minRx = 1024, minRy = 768, maxRx = 1128, maxRy = 634, label = "8", fontset = 1.015, reduce = 4},
            {minRx = 800, minRy = 600, maxRx = 1024, maxRy = 768, label = "9", fontset = 0.86, reduce = 5},
        }
        
        for _, range in ipairs(_Ranges) do
            if self.client.width >= range.minRx and self.client.height >= range.minRy then
                self.internal._fontReducer = range.reduce;
                self.internal._fontSet = range.fontset;
                break
            end
        end
    end,

    drawText = function(self, text, startx, starty, width, height, color, font, ...)
        local x, y = self.internal:convertPosition(startx, starty);
        local w, h = self.internal:convertScale(width, height);

        local size = self.internal._fontSet - (self.internal._fontSet * 0.18) 
        dxDrawText(text, x, y, w, h, color, size, self.internal:loadFont(font['name'], font['size'], false, 'antialiased'), ...);
    end
}

function getAurora()
    if not aurora.client.loaded then aurora:initialize() end

    return aurora
end