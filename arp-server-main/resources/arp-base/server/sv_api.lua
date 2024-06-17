local apiURL = GetConvar('arp_apiUrl', 'NOT_SET')
local apiKey = GetConvar('arp_apiKey', 'NOT_SET')
local apiSecret = GetConvar('arp_apiSecret', 'NOT_SET')

local function _b64enc( data )
    -- character table string
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

    return ( (data:gsub( '.', function( x ) 
        local r,b='', x:byte()
        for i=8,1,-1 do r=r .. ( b % 2 ^ i - b % 2 ^ ( i - 1 ) > 0 and '1' or '0' ) end
        return r;
    end ) ..'0000' ):gsub( '%d%d%d?%d?%d?%d?', function( x )
        if ( #x < 6 ) then return '' end
        local c = 0
        for i = 1, 6 do c = c + ( x:sub( i, i ) == '1' and 2 ^ ( 6 - i ) or 0 ) end
        return b:sub( c+1, c+1 )
    end) .. ( { '', '==', '=' } )[ #data %3 + 1] )
end

local authHeader = 'Basic ' .. _b64enc(apiKey ..':'.. apiSecret)

COMPONENTS.API = {
    _protected = true,
    Initialised = false,
    DoRequest = function(self, method, endPoint, data)
        if apiURL ~= 'NOT_SET' and apiKey ~= 'NOT_SET' and apiSecret ~= 'NOT_SET' then
            local p = promise.new()
            PerformHttpRequest(apiURL .. endPoint, function(code, resultData, resultHeader)
                p:resolve({
                    success = code == 200 and true or false,
                    code = code,
                    results = resultData and json.decode(resultData) or false,
                    headers = resultHeader
                })
            end, method, json.encode(data), {
                ["Authorization"] = authHeader,
                ["Content-Type"] = "application/json",
            })

            local res = Citizen.Await(p)
            return res
        else return false; end
    end,
    Init = function(self)
        local data = COMPONENTS.API:DoRequest('GET', 'game/serverAuth', {})
        if data and data.success and data.results.active then 
            local retData = data.results
            retData.keyID = apiKey
            COMPONENTS.API.Initialised = true
            return retData
        end
        return false
    end,
    GetUser = function(self, src, steam)
        if not steam then return false end
        local request = COMPONENTS.API:DoRequest('GET', 'game/users/'.. steam, { identifiers = true })
        if request.success then 
            return request.results
        else
            return false
        end 
    end,
    UpdateUser = function(self, steam, newdata)
        local request = COMPONENTS.API:DoRequest('POST', 'game/users/'.. steam .. '/update', {
            update = newdata
        })
        return request.success
    end
}