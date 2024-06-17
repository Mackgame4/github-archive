local menuOpen = false
local storedMenus = {}
local currentMenu = false

local function handleMenuResponse(data)
    --ARP.PrintTable(data)
    if menuOpen and currentMenu and storedMenus[currentMenu] and type(data.element) == 'number' and data.data ~= nil then 
        local elem = data.element + 1 -- add 1 because lua is cool
        if storedMenus[currentMenu].elements[elem] then 
            storedMenus[currentMenu].elements[elem]:DoCallback(data.data)
        end
    end
end

MENUS = {
    New = function(self, identifier, title, openFunc, closeFunc, subtitle)
        local _m = {
            id = identifier,
            data = {
                header = {
                    type = 'text',
                    title = title,
                    subtitle = subtitle and subtitle or '',
                    url = ''
                },
                controls = { type = 'Close', data = {} },
                data = {},
            },
            elements = {},
            callbacks = {},
            controlCallback = false,
        }

        _m.Open = function(self)
            if not menuOpen then 
                if openFunc then 
                    openFunc(_m)
                end
    
                menuOpen = true
                currentMenu = _m.id
                _m:Update(true)
                Components.UI:Send('menuOpen')
                Components.UI:SetFocus(true)
            end
        end

        _m.Close = function(self, skipFocus)
            if skipFocus == nil then 
                skipFocus = false 
            end
            if menuOpen and currentMenu == _m.id then 
                if closeFunc then 
                    closeFunc(_m)
                end

                if not skipFocus then 
                    Components.UI:SetFocus(false)
                end

                Components.UI:Send('menuClose')  
                menuOpen = false
                currentMenu = false  
            end
        end

        _m.Update = function(self, force)
            if force or (menuOpen and currentMenu == _m.id) then 
                local elementData = {}
                for id, elem in ipairs(_m.elements) do 
                    if elem then
                        elementData[id] = elem:GetData()
                    else 
                        elementData[id] = false
                    end
                end
                _m.data.data = elementData
                Components.UI:Send('menuSetData', _m.data)
            end
        end

        _m.UpdateOne = function(self, elementID, element)
            if menuOpen and currentMenu == _m.id then 
                if _m.elements[elementID] then
                    _m.elements[elementID] = element
                    if _m.data.data[elementID] then 
                        Components.UI:Send('menuUpdateElement', {
                            element = elementID,
                            update = true,
                            data = _m.elements[elementID]:GetData()
                        })
                    else
                        _m:Update(true)
                    end
                else 
                    Components.UI:Send('menuUpdateElement', {
                        element = elementID,
                        update = false,
                    })
                end
            end
        end

        _m.RemoveElement = function(self, id)
            if _m.elements[id] then 
                _m.elements[id] = false
                _m:UpdateOne(id)
            end
        end

        _m.SetTextHeader = function(self, title, subtitle)
            _m.data.header = {
                type = 'text',
                title = title,
                subtitle = subtitle,
                url = ''
            }
            if menuOpen and currentMenu == _m.id then 
                Components.UI:Send('menuUpdateHeader', _m.data.header)
            end
        end

        _m.SetControlsToClose = function(self)
            _m.data.controls = { type = 'Close', data = {} }
        end

        _m.SetControlsAsDoubleButton = function(self, b1text, b1options, b2text, b2options, cbFunc)
            _m.data.controls = { 
                type = 'DoubleButton', 
                data = {
                    buttons = {
                        {
                            text = b1text,
                            loading = b1options.loading,
                            disabled = b1options.disabled,
                            color = b1options.color,
                            icon = b1options.icon
                        },
                        {
                            text = b2text,
                            loading = b2options.loading,
                            disabled = b2options.disabled,
                            color = b2options.color,
                            icon = b2options.icon
                        },
                    }
                } 
            }
            _m.controlCallback = cbFunc
        end

        _m.SetControlsAsButton = function(self, text, options, cbFunc)
            _m.data.controls = { 
                type = 'Button', 
                data = {
                    text = text,
                    loading = options.loading,
                    disabled = options.disabled,
                    color = options.color,
                    icon = options.icon
                },
            }
            _m.controlCallback = cbFunc
        end

        _m.DisableControl = function(self)
            _m.data.controls = { type = 'None', data = {} }
        end

        _m.ClearElements = function(self)
            _m.data.data = {}
            _m.elements = {}
            _m:Update()
        end

        _m.Add = {
            Button = function(self, buttonText, buttonOptions, cbFunc)
                local elementID = #_m.elements + 1

                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'SimpleButton',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, text, options)
                    if not text then text = "" end
                    self.data.data = {
                        text = text,
                        loading = options.loading,
                        disabled = options.disabled,
                        color = options.color,
                        icon = options.icon
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(buttonText, buttonOptions)
                return _elem
            end,

            DoubleButton = function(self, button1Text, button1Options, button2Text, button2Options, cbFunc)
                local elementID = #_m.elements + 1

                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'DoubleButton',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, b1text, b1options, b2text, b2options)
                    if not b1text then b1text = "" end
                    if not b2text then b2text = "" end
                    self.data.data = {
                        buttons = {
                            {
                                text = b1text,
                                loading = b1options.loading,
                                disabled = b1options.disabled,
                                color = b1options.color,
                                icon = b1options.icon
                            },
                            {
                                text = b2text,
                                loading = b2options.loading,
                                disabled = b2options.disabled,
                                color = b2options.color,
                                icon = b2options.icon
                            },
                        }
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.buttonNum)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(button1Text, button1Options, button2Text, button2Options)
                return _elem
            end,

            TextField = function(self, textValue, textLabel, textOptions, cbFunc)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'TextField',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value, label, options)
                    if not value then value = "" end
                    self.data.data = {
                        value = value,
                        label = label,

                        color = options.color,
                        readonly = options.readonly,
                        counter = options.counter,
                        icon = options.icon,
                        hint = options.hint,
                        persistentHint = options.persistentHint
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.newValue)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(textValue, textLabel, textOptions)
                return _elem
            end,

            NumberField = function(self, numValue, numLabel, numOptions, cbFunc)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'NumberField',
                        data = {}
                    },
                    lastValUpdate = 0
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value, label, options)
                    if not value then value = "" end
                    self.data.data = {
                        value = value,
                        label = label,

                        min = options.min,
                        max = options.max,
                        step = options.step,
                        prefix = options.prefix,
                        color = options.color,
                        readonly = options.readonly,
                        hint = options.hint,
                        persistentHint = options.persistentHint
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.newValue)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(numValue, numLabel, numOptions)
                return _elem
            end,

            Slider = function(self, sliderValue, sliderLabel, sliderOptions, cbFunc)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'SliderField',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value, label, options)
                    if not value then value = 1 end
                    self.data.data = {
                        value = value,
                        label = label,

                        min = options.min,
                        max = options.max,
                        step = options.step,
                        --prefix = options.prefix,
                        color = options.color,
                        readonly = options.readonly,
                        hint = options.hint,
                        persistentHint = options.persistentHint,
                        icon = options.icon,
                        thumbColor = options.thumbColor,
                        trackColor = options.trackColor,
                        sliderLabel = options.sliderLabel,
                        thumbLabel = options.thumbLabel,
                        customThumbLabels = options.customThumbLabels,
                        showField = options.showField,
                        showTicks = options.showTicks,
                        tickLabels = options.tickLabels,
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.newValue)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(sliderValue, sliderLabel, sliderOptions)
                return _elem
            end,

            Picker = function(self, pickerValue, pickerItems, pickerLabel, pickerOptions, cbFunc)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'Picker',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value, items, label, options)
                    if not value then value = "" end
                    self.data.data = {
                        value = value,
                        label = label,
                        items = items,
                        multiple = options.multiple,
                        multipleLimiter = options.multipleLimiter,
                        color = options.color,
                        readonly = options.readonly,
                        hint = options.hint,
                        persistentHint = options.persistentHint,
                        loading = options.loading,
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.newValue)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(pickerValue, pickerItems, pickerLabel, pickerOptions)
                return _elem
            end,

            Toggler = function(self, toggleValue, toggleLabel, toggleOptions, cbFunc)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'Toggler',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value, label, options)
                    if not value then value = false end
                    self.data.data = {
                        value = value,
                        label = label,
                        color = options.color,
                        readonly = options.readonly,
                        type = options.type,
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.newValue)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(toggleValue, toggleLabel, toggleOptions)
                return _elem
            end,

            Palette = function(self, hexValue, hexSwatches, hexLabel, hexOptions, cbFunc)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'ColorPalette',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value, swatches, label, options)
                    if not value then value = "" end
                    self.data.data = {
                        value = value,
                        label = label,
                        swatches = swatches,
                        readonly = options.readonly,
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.newValue)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(hexValue, hexSwatches, hexLabel, hexOptions)
                return _elem
            end,

            Color = function(self, cValue, cLabel, cOptions, cbFunc)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    cb = cbFunc,
                    data = {
                        type = 'Color',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value, label, options)
                    if not value then value = "" end
                    self.data.data = {
                        value = value,
                        label = label,
                        swatches = swatches,
                        readonly = options.readonly,
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self, data)
                    self.cb(self, data.newValue)
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(cValue, cLabel, cOptions)
                return _elem
            end,

            TextDisplay = function(self, textValue)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    data = {
                        type = 'TextDisplay',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value)
                    if not value then value = false end
                    self.data.data = {
                        value = value,
                    }
                    _m:UpdateOne(self.id, self)
                end
                _elem.DoCallback = function(self)
                    return
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                _elem:Update(textValue)
                return _elem
            end,

            MenuSpacer = function(self)
                local elementID = #_m.elements + 1
                _elem = {
                    id = elementID,
                    data = {
                        type = 'MenuSpacer',
                        data = {}
                    }
                }

                table.insert(_m.elements, _elem)
                _elem.Update = function(self, value) -- keep function incase
                    return
                end
                _elem.DoCallback = function(self)
                    return
                end
                _elem.Remove = function(self)
                    _m:RemoveElement(self.id)
                    self = nil
                end
                _elem.GetData = function(self)
                    return self.data
                end

                return _elem
            end
        }

        storedMenus[identifier] = _m
        return _m;  
    end,
}


function RegisterMenuUICallbacks() 
    Components.UI:RegisterCallback('menuValueUpdate', function(data, cb)
        handleMenuResponse(data)
        cb({ success = true })
    end)
    
    Components.UI:RegisterCallback('menuButtonClick', function(data, cb)
        PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false, false, true)
        handleMenuResponse(data)
        cb({ success = true })
    end)
    
    Components.UI:RegisterCallback('menuStartClose', function(data, cb)
        PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false, false, true)
        if menuOpen and currentMenu and storedMenus[currentMenu] and storedMenus[currentMenu].data.controls and storedMenus[currentMenu].data.controls.type == 'Close' then
            storedMenus[currentMenu]:Close()
        end
        cb({ success = true })
    end)
    
    Components.UI:RegisterCallback('menuControlButton', function(data, cb)
        PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false, false, true)
        if menuOpen and currentMenu and storedMenus[currentMenu] and storedMenus[currentMenu].data.controls and storedMenus[currentMenu].controlCallback then
            storedMenus[currentMenu].controlCallback(data.index)
        end
        cb({ success = true })
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    if menuOpen and currentMenu and storedMenus[currentMenu] then 
        storedMenus[currentMenu]:Close()
    end
end)






--[[Citizen.CreateThread(function()
    print('menu started')

    

    Citizen.Wait(3000)
    local testMenu = Menu:New('testMenu', 'Test Menu Here', function()
        print('testmenu opened')
    end, function(s)
        print('testmenu closed')
    end)

    local testMenu2 = Menu:New('testMenu2', 'Test Menu 2 Here', function()
        print('testmenu2 opened')
    end, function(s)
        print('testmenu2 closed')
    end)

    testMenu2:SetControlsAsDoubleButton('Dicks', {}, 'Dicks 2', {}, function(button)
        print('apples')
    end)
    
    testMenu:SetControlsAsDoubleButton('Cunt', {
        color = 'blue darken-4',
    }, 'Cunt 2', {}, function(button)
        if button == 0 then 
            testMenu:Close()
            --Citizen.Wait(1000)
            --testMenu2:Open()
            return
        end
        print('bananas', button)
        testMenu:SetTextHeader('Nice', 'Even nicer')
    end) 

    local thisButton = testMenu.Add:Toggler(true, 'Cool Toggle', { type = 'checkbox' }, function(element)
        print('button WOOOOOO??????????????????????????????????????????????????????????')
    end)

    -- local text = testMenu.Add:TextDisplay('Some <b>bold</b> text.')

    -- local thisButton2 = testMenu.Add:Button('Cooler Button', { color = 'red darken-4' }, function(element)
    --     print('button WOOOOOO 2')
    --     testMenu:ClearElements()
    -- end)

    -- local picker = testMenu.Add:Picker('option1', { 
    --     { id = 'option1', name = 'The First Option' },
    --     { id = 'optionz', name = 'The Last Letter of the Alphabet' },
    -- }, 'Pretty Label', {}, function(element, new) 
    --     print('huh', new)
    -- end)

    local number = testMenu.Add:NumberField(20, 'This Number Here', {}, function(element, new) 
        print('huh new number', new)
    end)

    
    testMenu:Open()
    
end)]]
