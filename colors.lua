local Color = {}

math.round = function(x)
    return x + 0.5 - (x + 0.5) % 1
end

Color.rgbToHsl = function(r, g, b)
    r = r / 255
    g = g / 255
    b = b / 255
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h
    local s
    local l = (max + min) / 2

    if max == min then
        -- achromatic
        h = 0
        s = 0
    else
        local d = max - min
        if l > 0.5 then
            s = d / (2 - max - min)
        else
            s = d / (max + min)
        end
        if max == r then
            if g < b then
                h = (g - b) / d + 6
            else
                h = (g - b) / d
            end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, l
end

Color.hslToRgb = function(h, s, l)
    local r, g, b
    if s == 0 then
        -- achromatic
        r, g, b = l, l, l
    else
        local hue2rgb = function(p, q, t)
            if t < 0 then
                print('1')
                t = t + 1
            end
            if t > 1 then
                print('2' .. t)
                t = t - 1
            end
            if t < (1 / 6) then
                print('3')
                return p + (q - p) * 6 * t
            end
            if t < (1 / 2) then
                print('4')
                return q
            end
            if t < (2 / 3) then
                print('5')
                return p + (q - p) * (2 / 3 - t) * 6
            end
            print('6')
            return p
        end

        local q
        if l < 0.5 then
            q = l * (1 + s)
        else
            q = (l + s) - (l * s)
        end
        local p = (2 * l) - q
        r = hue2rgb(p, q, (h + 1 / 3))
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, (h - 1 / 3))
    end
    print(r .. ' : ' .. g .. ' : ' .. b)
    return math.round(r * 255), math.round(g * 255), math.round(b * 255)
end

Color.hexToRgb = function(hex)
    local cutHex = function(h)
        if string.sub(h, 1, 1) == '#' then
            return string.sub(h, 2, 7)
        else
            return h
        end
    end
    local hexToR = function(h)
        return tonumber(string.sub(cutHex(h), 1, 2), 16)
    end
    local hexToG = function(h)
        return tonumber(string.sub(cutHex(h), 3, 4), 16)
    end
    local hexToB = function(h)
        return tonumber(string.sub(cutHex(h), 5, 6), 16)
    end

    return hexToR(hex), hexToG(hex), hexToB(hex)
end

Color.rgbToHex = function(r, g, b)
    return '#' .. string.format('%x', r) .. string.format('%x', g) .. string.format('%x', b)
end

-- todo add conversion for hsl as well
Color.toColor = function(rgb)
    rgb = rgb:gsub("%s+", "")

    if rgb:sub(1, 4) == "rgba" then
        -- rgba value
        rgb = rgb:sub(5, 12)
        
    elseif rgb:sub(1, 3) == "rgb" then
        -- rgb value

    end
end

-- Color.rgbToHsl(r, g, b)
Color.hslToRgb(330, 1, 0.4)

return Color
