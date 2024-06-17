Core.Internal = Core.Internal or {}
Core.Internal.DeferralCards = {
    Card = {},
    CardElement = {},
    Container = {},
    Action = {},
    Input = {}
}
--------------------------------------------------[[ Cards ]]--------------------------------------------------

function Core.Internal.DeferralCards.Card.Create(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'AdaptiveCard'
    pOptions.version = pOptions.version or '1.4'
    pOptions.body = pOptions.body or {}
    pOptions['$schema'] = 'http://adaptivecards.io/schemas/adaptive-card.json'
    return json.encode(pOptions)
end
--[[
    DeferralCards.Card:Create({
        body = {
            DeferralCards.CardElement:Image({
                url = '',
                size = 'small',
                horizontalAlignment = 'center'
            }),
            DeferralCards.CardElement:TextBlock({
                text = 'Text',
                weight = 'Light',
                horizontalAlignment = 'center'
            }),
        }
    })
]]

--------------------------------------------------[[ Card Elements ]]--------------------------------------------------

function Core.Internal.DeferralCards.CardElement.TextBlock(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'TextBlock'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end
--[[
    DeferralCards.CardElement:TextBlock({
        size = 'small',
        weight = 'Light',
        text = 'Some text',
        wrap = true
    })
]]

function Core.Internal.DeferralCards.CardElement.Image(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Image'
    pOptions.url = pOptions.url or 'https://via.placeholder.com/100x100?text=Temp+Image'
    return pOptions
end
--[[
    DeferralCards.CardElement:Image({
        url = 'https://via.placeholder.com/100x100?text=Temp+Image'
    })
]]

function Core.Internal.DeferralCards.CardElement.Media(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Media'
    pOptions.sources = pOptions.sources or {}
    return pOptions
end
--[[
    DeferralCards.CardElement:Media({
        poster = 'https://adaptivecards.io/content/poster-video.png',
        sources = {}
    })
]]

function Core.Internal.DeferralCards.CardElement.MediaSource(self, pOptions)
    if not pOptions then return end
    pOptions.mimeType = pOptions.mimeType or 'video/mp4'
    pOptions.url = pOptions.url or ''
    return pOptions
end
--[[
    DeferralCards.CardElement:MediaSource({
        mimeType = 'video/mp4',
        url = ''
    })
]]

function Core.Internal.DeferralCards.CardElement.RichTextBlockItem(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'TextRun'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end
--[[
    DeferralCards.CardElement:RichTextBlockItem({
        text = 'Item 1',
        size = 'small',
        color = 'good',
        isSubtle = true,
        weight = 'small',
        highlight = true,
        italic = false,
        strikethrough = false,
        fontType = 'monospace'
    })
]]

function Core.Internal.DeferralCards.CardElement.RichTextBlock(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'RichTextBlock'
    pOptions.inline = pOptions.inline or {}
    return pOptions
end
--[[
    DeferralCards.CardElement:RichTextBlock({
        horizontalAlignment = 'center',
        inline = {
            DeferralCards.CardElement:RichTextBlockItem({
                text = 'Item 1',
                size = 'small',
                color = 'good',
                isSubtle = true,
                weight = 'small',
                highlight = true
            }),
            DeferralCards.CardElement:RichTextBlockItem({
                text = 'Item 2',
                size = 'medium',
                color = 'good',
                isSubtle = false,
                weight = 'large',
                highlight = false
            })
        }
    })
]]

function Core.Internal.DeferralCards.CardElement.TextRun(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'TextRun'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end
--[[
    DeferralCards.CardElement:TextRun({
        text = 'Text',
        color = 'good',
        fontType = 'monospace',
        highlight = false,
        isSubtle = false,
        italic = false,
        size = 'small',
        strikethrough = false,
        underline = false,
        weight = 'medium'
    })
]]

--------------------------------------------------[[ Containers ]]--------------------------------------------------

function Core.Internal.DeferralCards.Container.Create(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Container'
    pOptions.items = pOptions.items or {}
    return pOptions
end
--[[
    DeferralCards.Container:Create({
        items = {}
    })
]]

function Core.Internal.DeferralCards.Container.ActionSet(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'ActionSet'
    pOptions.actions = pOptions.actions or {}
    return pOptions
end
--[[
    DeferralCards.Container:ActionSet({
        actions = {},
    })
]]

function Core.Internal.DeferralCards.Container.ColumnSet(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'ColumnSet'
    pOptions.columns = pOptions.columns or {}
    return pOptions
end
--[[
    DeferralCards.Container:ColumnSet({
        columns = {}
    })
]]

function Core.Internal.DeferralCards.Container.Column(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Column'
    pOptions.items = pOptions.items or {}
    return pOptions
end
--[[
    DeferralCards.Container:Column({
        items = {},
        width = 'auto'
    })
]]

function Core.Internal.DeferralCards.Container.Fact(self, pOptions)
    if not pOptions then return end
    pOptions.title = pOptions.title or 'Title'
    pOptions.value = pOptions.value or 'Value'
    return pOptions
end
--[[
    DeferralCards.Container:Fact({
        title = 'Title',
        value = 'Value'
    })
]]

function Core.Internal.DeferralCards.Container.FactSet(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'FactSet'
    pOptions.facts = pOptions.facts or {}
    return pOptions
end
--[[
    DeferralCards.Container:FactSet({
        facts = {
            DeferralCards.Container:Fact({
                title = 'Title 1',
                value = 'Value 1'
            }),
            DeferralCards.Container:Fact({
                title = 'Title 2',
                value = 'Value 2'
            })
        }
    })
]]

function Core.Internal.DeferralCards.Container.ImageSetItem(self, pOptions)
    if not pOptions then return end
    pOptions.type = pOptions.type or 'Image'
    pOptions.url = pOptions.url or 'https://adaptivecards.io/content/cats/1.png'
    return pOptions
end
--[[
    DeferralCards.Container:ImageSetItem({
        type = 'Image',
        url = 'https://adaptivecards.io/content/cats/1.png'
    })
]]

function Core.Internal.DeferralCards.Container.ImageSet(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'ImageSet'
    pOptions.images = pOptions.images or {}
    return pOptions
end
--[[
    DeferralCards.Container:ImageSet({
        images = {
            DeferralCards.Container:ImageSetItem({
                type = 'Image',
                url = 'https://adaptivecards.io/content/cats/1.png'
            }),
            DeferralCards.Container:ImageSetItem({
                type = 'Image',
                url = 'https://adaptivecards.io/content/cats/2.png'
            })
        }
    })
]]

--------------------------------------------------[[ Actions ]]--------------------------------------------------

function Core.Internal.DeferralCards.Action.OpenUrl(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.OpenUrl'
    pOptions.url = pOptions.url or 'https://www.google.co.uk/'
    return pOptions
end
--[[
    DeferralCards.Action:OpenUrl({
        title = 'Title',
        url = 'https://www.google.co.uk/'
    })
]]

function Core.Internal.DeferralCards.Action.Submit(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.Submit'
    return pOptions
end
--[[
    DeferralCards.Action:Submit({
        title = 'Title',
        data = {
            x = 10
        }
    })
]]

function Core.Internal.DeferralCards.Action.ShowCard(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.ShowCard'
    return pOptions
end
--[[
    DeferralCards.Action:ShowCard({
        title = 'Title',
        card = {}
    })
]]

function Core.Internal.DeferralCards.Action.TargetElement(self, pOptions)
    if not pOptions then return end
    pOptions.elementId = pOptions.elementId or 'target_element'
    return pOptions
end
--[[
    DeferralCards.Action:TargetElement({
        elementId = 'element_1',
        isVisible = true
    })
]]

function Core.Internal.DeferralCards.Action.ToggleVisibility(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.ToggleVisibility'
    pOptions.targetElements = pOptions.targetElements or {}
    return pOptions
end
--[[
    DeferralCards.Action:ToggleVisibility({
        title = 'Title',
        targetElements = {
            Deferralcards.Action:TargetElement({
                elementId = 'element_1',
                isVisible = true
            }),
            Deferralcards.Action:TargetElement({
                elementId = 'element_2',
                isVisible = true
            })
        }
    })
]]

function Core.Internal.DeferralCards.Action.Execute(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.Execute'
    return pOptions
end
--[[
    DeferralCards.Action:Execute({
        title = 'Title',
        verb = 'Verb',
        data = {
            x = 10
        }
    })
]]

--------------------------------------------------[[ Inputs ]]--------------------------------------------------

function Core.Internal.DeferralCards.Input.Text(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Text'
    pOptions.id = pOptions.id or 'input_text'
    return pOptions
end
--[[
    DeferralCards.Input:Text({
        id = 'input_text',
        text = 'Text',
        title = 'Title',
        placeholder = 'Placeholder'
    })
]]

function Core.Internal.DeferralCards.Input.Number(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Number'
    pOptions.id = pOptions.id or 'input_number'
    return pOptions
end
--[[
    DeferralCards.Input:Number({
        id = 'input_number',
        placeholder = 'Placeholder',
        min = 1,
        max = 10,
        value = 5
    })
]]

function Core.Internal.DeferralCards.Input.Date(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Date'
    pOptions.id = pOptions.id or 'input_date'
    return pOptions
end
--[[
    DeferralCards.Input:Date({
        id = 'input_date',
        placeholder = 'Placeholder',
        value = '2021-08-13'
    })
]]

function Core.Internal.DeferralCards.Input.Time(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Time'
    pOptions.id = pOptions.id or 'input_time'
    return pOptions
end
--[[
    DeferralCards.Input:Time({
        id = 'input_time',
        placeholder = 'Placeholder',
        min = '00:00',
        max = '23:59',
        value = '19:00'
    })
]]

function Core.Internal.DeferralCards.Input.Toggle(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Toggle'
    pOptions.title = pOptions.title or 'Title'
    pOptions.id = pOptions.id or 'input_toggle'
    return pOptions
end
--[[
    DeferralCards.Input:Toggle({
        id = 'input_toggle',
        title = 'Title',
        value = 'true',
        valueOn = 'true',
        valueOff = 'false'
    })
]]

function Core.Internal.DeferralCards.Input.Choice(self, pOptions)
    if not pOptions then return end
    pOptions.title = pOptions.title or 'Title'
    pOptions.value = pOptions.value or 'Value'
    return pOptions
end
--[[
    DeferralCards.Input:Choice({
        title = 'Title',
        value = 'Value'
    })
]]

function Core.Internal.DeferralCards.Input.ChoiceSet(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.ChoiceSet'
    pOptions.choices = pOptions.choices or {}
    pOptions.id = pOptions.id or 'choice_set'
    return pOptions
end
--[[
    DeferralCards.Input:ChoiceSet({
        placeholder = 'Text',
        choices = {
            DeferralCards.Input:Choice({
                title = 'Title 1',
                value = 'Value 1'
            }),
            DeferralCards.Input:Choice({
                title = 'Title 2',
                value = 'Value 2'
            })
        }
    })
]]

Core.Modules.DeferralCards = {
    PresentQueue = function(self, plyr)
        Citizen.CreateThread(function()
            local queues = {}
            table.insert(queues, { title = "Standard Queue", data = { queue = "standard" } })
            if plyr:HasJobQueue() then
                table.insert(queues, { title = "LEO/EMS Queue", data = { queue = "job" } })
            end

            if plyr:HasStaffQueue() then
                table.insert(queues, { title = "Staff Queue", data = { queue = "staff" } })
            end
            
            if plyr:HasDevelopmentQueue() then
                table.insert(queues, { title = "Bypass Queue (DevMode)", data = { queue = "developer" } })
            end
            self:PresentOfferCard(plyr.Deferrals, "Select Queue", "Please select one of the avaliable queue options to you below to start connecting to the city.", queues, function(data)
                if data and data.queue then
                    local processQueue = nil
                    if data.queue == "standard" then 
                        Core.Modules.Logger:Info('Queue', plyr.User.Name..' has selected to join the Standard Prio queue', {discord={channel="queue"}})
                        processQueue = true
                    end

                    if data.queue == "staff" then
                        Core.Modules.Logger:Info('Queue', plyr.User.Name..' has selected to join the Staff Prio queue', {discord={channel="queue"}})
                        plyr:AddBoost('Staff Queue Boost', 10000)
                        plyr:SelectQueue('staff')
                        processQueue = true
                    end

                    if data.queue == "job" then
                        local jobOptions = {
                            { title = "Confirm Selection", data = { confirm = "Confirm" } },
                            { title = "Change Queue", data = { confirm = "change" } }
                        }               
                        self:PresentOfferCard(plyr.Deferrals, "Job Queue Warning", "This Queue is restricted to if your playing on your LEO or EMS Character only, Only your EMS and PD characters will show in the character selection screens.", jobOptions, function(data)
                            Citizen.CreateThread(function()
                                if data and data.confirm == "Confirm" then
                                    if plyr:RestrictToJobs() then
                                        Core.Modules.Logger:Info('Queue', plyr.User.Name..' has selected to join the Job Prio queue', {discord={channel="queue"}})
                                        plyr:AddBoost('LEO/EMS Queue Boost', 1000)
                                        plyr:SelectQueue('job')
                                        processQueue = true
                                        return
                                    end
                                end
                                Core.Modules.DeferralCards:PresentQueue(plyr)
                                processQueue = false
                                return
                            end)
                        end)
                    end

                    if data.queue == "developer" then
                        Core.Modules.Logger:Info('Queue', plyr.User.Name..' has selected to join the Development Bypass queue', {discord={channel="queue"}})
                        plyr:AddBoost('Development Mode', 1000000)
                        processQueue = true
                        plyr:SelectQueue('developer')
                    end
                    repeat Wait(1) until processQueue ~= nil
                    Wait(250)
                    if processQueue then
                        plyr:ProcessPriority()
                        Wait(250)
                        Core.Modules.Queue:QueuePlayer(plyr)
                    end
                end
                return
            end)
        end)
    end,
    TextCard = function(self, deferrals, heading, text)
        local card = Core.Internal.DeferralCards.Card:Create({
            backgroundImage = Core.Config.Queue.Images.Background,
            verticalContentAlignment = "center",
            minHeight = '200px',
            body = {
                Core.Internal.DeferralCards.CardElement:TextBlock({
                    size = 'ExtraLarge',
                    weight = 'Bolder',
                    text = heading
                }),
                Core.Internal.DeferralCards.CardElement:TextBlock({
                    text = text,
                    wrap = true
                }),
                
            }
        })
        deferrals.presentCard(card)
    end,
    PresentOfferCard = function(self, deferrals, heading, text, options, cb)
        Citizen.CreateThread(function()
            local insert = {}
            local card = {
                backgroundImage = Core.Config.Queue.Images.Background,
                verticalContentAlignment = "center",
                minHeight = '250px',
                body = {
                    Core.Internal.DeferralCards.CardElement:TextBlock({
                        size = 'ExtraLarge',
                        weight = 'Bolder',
                        text = heading
                    }),
                    Core.Internal.DeferralCards.CardElement:TextBlock({
                        text = text,
                        wrap = true
                    })
                }
            }

            if type(options) == "table" and #options > 0 then
                for k, v in pairs(options) do
                    table.insert(insert, Core.Internal.DeferralCards.Action:Submit({
                        title = v.title, 
                        data = v.data
                    }))
                end
                table.insert(card.body, Core.Internal.DeferralCards.Container:ActionSet({
                    actions = insert
                }))
            end
            
            Core.Internal.DeferralCards.Card:Create(card)
            deferrals.presentCard(card, cb)
        end)
    end,
    QueueInfo = function(self, plyr, position, reqQueue, time)
        local insertFacts = {}
        table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
            title = 'Requested Queue',
            value = reqQueue
        }))

        if time then
            if time > 0 then
                table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
                    title = 'Queue Opening',
                    value = 'In '..time..' Minutes'
                }))
            end

            if time == 0 then
                table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
                    title = 'Queue Opening',
                    value = 'In less than a minute'
                }))
            end
        end
        table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
            title = 'Queue Count:',
            value = tostring(#Core.Queue.Queued)
        }))
        table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
            title = 'Queue Position:',
            value = tostring(position)
        }))
        table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
            title = 'Time in Queue:',
            value = tostring(plyr.Timer:Output())
        }))
        table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
            title = "Activated",
            value = "Standard Queue Prio"
        }))
        
        for k, v in pairs(plyr:GetBoosts()) do
            table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
                title = "Activated",
                value = "🌟 "..v.Label
            }))
        end
        if plyr.TimeBoost > 0 then
            table.insert(insertFacts, Core.Internal.DeferralCards.Container:Fact({
                title = "🌟 Time Boost",
                value = "+"..plyr.TimeBoost..' Minute'..(plyr.TimeBoost ~= 1 and "s" or "")
            }))
        end
        local queueingCard = {
            backgroundImage = Core.Config.Queue.Images.Background,
            verticalContentAlignment = "center",
            minHeight = '300px',
            body = {
                Core.Internal.DeferralCards.Container:Create({
                    items = {
                        Core.Internal.DeferralCards.CardElement:TextBlock({
                            size = 'Medium',
                            weight = 'Bolder',
                            text = 'Queue to Join...'
                        }),
                        Core.Internal.DeferralCards.Container:ColumnSet({
                            columns = {
                                Core.Internal.DeferralCards.Container:Column({
                                    items = {
                                        Core.Internal.DeferralCards.CardElement:Image({
                                            style = 'Person',
                                            url = plyr.User.Avatar,
                                            size = 'Small'
                                        })
                                    },
                                    width = 'auto'
                                }),
                                Core.Internal.DeferralCards.Container:Column({
                                    items = {
                                        Core.Internal.DeferralCards.CardElement:TextBlock({
                                            weight = 'Bolder',
                                            text = plyr.User.Name,
                                            wrap = true
                                        }),
                                        Core.Internal.DeferralCards.CardElement:TextBlock({
                                            spacing = 'None',
                                            text = 'Registered '..plyr.User.Dates.Registered.Human,
                                            isSubtle = true,
                                            wrap = true
                                        })
                                    },
                                    width = 'stretch'
                                })
                            }
                        })
                    }
                }),
                Core.Internal.DeferralCards.Container:Create({
                    items = {
                        Core.Internal.DeferralCards.CardElement:TextBlock({
                            text = 'You are currently in a queue to connect to the city, Please Wait...',
                            wrap = true
                        }),
                        Core.Internal.DeferralCards.Container:FactSet({
                            facts = insertFacts
                        })
                    }
                })
            },
        }
        plyr.Deferrals.presentCard(queueingCard)
    end
}