settings_table = {
    {
        name='time',
        arg='%d',
        max=31,
        bg_colour=0xcccccc,
        bg_alpha=1.0,
        fg_colour=0xffffff,  -- Set outer ring to white
        fg_alpha=1.0,
        x=200, y=200,
        radius=120,
        thickness=5,
        start_angle=0,
        end_angle=360
    },
}

clock_r = 65
clock_x = 200
clock_y = 200
show_seconds = true  -- Enable seconds hand

require 'cairo'
require 'cairo_xlib'

function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr, t, pt)
    local xc, yc, ring_r, ring_w, sa, ea = pt['x'], pt['y'], pt['radius'], pt['thickness'], pt['start_angle'], pt['end_angle']
    local bgc, bga, fgc, fga = pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']
    
    local angle_0 = sa * (2 * math.pi / 360) - math.pi / 2
    local angle_f = ea * (2 * math.pi / 360) - math.pi / 2

    -- Draw full white ring
    cairo_arc(cr, xc, yc, ring_r, angle_0, angle_f)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(fgc, fga))  -- White color for full ring
    cairo_set_line_width(cr, ring_w)
    cairo_stroke(cr)
end

function draw_clock_hands(cr, xc, yc)
    local secs = os.date("%S")
    local mins = os.date("%M")
    local hours = os.date("%I")
        
    local secs_arc = (2 * math.pi / 60) * secs
    local mins_arc = (2 * math.pi / 60) * mins + secs_arc / 60
    local hours_arc = (2 * math.pi / 12) * hours + mins_arc / 12
        
    -- Draw hour hand (white)
    local xh = xc + 0.9 * clock_r * math.sin(hours_arc)
    local yh = yc - 0.9 * clock_r * math.cos(hours_arc)
    cairo_move_to(cr, xc, yc)
    cairo_line_to(cr, xh, yh)
    
    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr, 12)
    cairo_set_source_rgba(cr, 1.0, 1.0, 1.0, 1.0)  -- White color for hour hand
    cairo_stroke(cr)
    
    -- Draw minute hand (white)
    local xm = xc + 1.28 * clock_r * math.sin(mins_arc)
    local ym = yc - 1.28 * clock_r * math.cos(mins_arc)
    cairo_move_to(cr, xc, yc)
    cairo_line_to(cr, xm, ym)
    
    cairo_set_line_width(cr, 10)
    cairo_stroke(cr)
    
    -- Draw seconds hand (white)
    if show_seconds then
        local xs = xc + 1.28 * clock_r * math.sin(secs_arc)
        local ys = yc - 1.28 * clock_r * math.cos(secs_arc)
        cairo_move_to(cr, xc, yc)
        cairo_line_to(cr, xs, ys)
    
        cairo_set_line_width(cr, 2)  -- Seconds hand should be thinner
        cairo_stroke(cr)
    end
end

function conky_clock_rings()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    
    local cr = cairo_create(cs)    
    local updates = conky_parse('${updates}')
    local update_num = tonumber(updates)
    
    if update_num > 5 then
        for i in pairs(settings_table) do
            local pt = settings_table[i]
            local str = string.format('${%s %s}', pt['name'], pt['arg'])
            local value = tonumber(conky_parse(str))
            local pct = value / pt['max']
            draw_ring(cr, pct, pt)
        end
    end
    
    draw_clock_hands(cr, clock_x, clock_y)
end

