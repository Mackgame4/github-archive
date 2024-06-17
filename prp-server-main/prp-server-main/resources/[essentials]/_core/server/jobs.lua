ESX.Jobs = {}

function RegisterJob(job)
    if ESX.Jobs[job.name] then
        Logger.warning(("Job %s exists already. Recreating it..."):format(job.name))
    end

    if not job.name then
        Logger.error("No Job name for Job Registration")
        return
    end

    if not job.label then
        local label = ("%s%s"):format(job.name:sub(1, 1):upper(), job.name:sub(2))
        Logger.warning(("No Job Label for %s for Job Registration. Setting to %s"):format(job.name, label))
        job.label = label
    end

    if not job.boss then
        Logger.warning(("No Boss for %s for Job Registration"):format(job.name))
    else
        local boss = {
            name = ("%s:boss"):format(job.name),
            render = {
                location = job.boss.location,
                heading = job.boss.heading,
                distance = 50,
                model = job.boss.model,
                freeze = true,
                blockevents = true
            },
            interact = {
                options = {
                    {
                        event = "_core:Server:GetSalary",
                        icon = "fas fa-dollar-sign",
                        label = "Get Salary",
                        type = 'server'
                    },
                },
                distance = 1.2
            }
        }
        if job.boss.interact then
            Logger.info(("Adding Interaction config for %s for Job Registration"):format(job.name))
            for k, v in ipairs(job.boss.interact) do
                table.insert(boss.interact.options, v)
            end
        end
        RegisterNPC(boss)
    end
    if not job.grades then
        Logger.warning(("No Job Grades for %s for Job Registration. Defaulting to Employee Grade"):format(job.name))
        job.grades = {
            employee = {
                salary = 0
            }
        }
    end
    local grade = 0
    for k, v in pairs(job.grades) do
        job.grades[k].level = grade
        grade = grade + 1
    end

    ESX.Jobs[job.name] = job
end

exports('RegisterJob', RegisterJob)

RegisterJob({
    name = "unemployed",
    grades = {
        unemployed = {
            salary = 0
        }
    }
})

RegisterServerEvent('_core:Server:GetSalary')
AddEventHandler('_core:Server:GetSalary', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local salary = xPlayer.getAccount('salary')
    xPlayer.showNotification(("Received Salary of $%s"):format(salary.money))
    xPlayer.addMoney(salary.money)
    xPlayer.setAccountMoney('salary', 0)
end)

