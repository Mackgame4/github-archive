Config = {}

Config.Locale = 'en'

Config.Bennys = {
	{
		name = "Benny's Customs",
		points = {
			vector2(-203.5546, -1311.264),
			vector2(-204.0865, -1327.311),
			vector2(-207.8225, -1327.589),
			vector2(-207.5313, -1329.796),
			vector2(-217.698, -1331.712),
			vector2(-227.3517, -1331.48),
			vector2(-227.0457, -1326.718),
			vector2(-217.6555, -1326.437),
			vector2(-214.6668, -1316.333),
			vector2(-213.541, -1315.679),
			vector2(-213.4045, -1311.339)
		},
		minZ = 29.8,
		maxZ = 37.0
	}
}

Config.Colors = {
	{label = _U('black'), value = 'black'},
	{label = _U('white'), value = 'white'},
	{label = _U('grey'), value = 'grey'},
	{label = _U('red'), value = 'red'},
	{label = _U('pink'), value = 'pink'},
	{label = _U('blue'), value = 'blue'},
	{label = _U('yellow'), value = 'yellow'},
	{label = _U('green'), value = 'green'},
	{label = _U('orange'), value = 'orange'},
	{label = _U('brown'), value = 'brown'},
	{label = _U('purple'), value = 'purple'},
	{label = _U('chrome'), value = 'chrome'},
	{label = _U('gold'), value = 'gold'}
}

Config.vehicleModsList = {
	--CONVERTION = { index = -1, label = "Convertion", description = "Realize an engine swap or convert your car into something else.", icon = "mdi-reload", multiplier = 0.2, sale = false },
	modSpoilers = { index = 0, label = "Spoiler", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-sports", multiplier = 0.2, sale = true },
	modFrontBumper = { index = 1, label = "Front Bumper", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car", multiplier = 0.2, sale = false },
	modRearBumper = { index = 2, label = "Rear Bumper", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-back", multiplier = 0.2, sale = false },
	modSideSkirt = { index = 3, label = "Skirt", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-side", multiplier = 0.2, sale = false },
	modExhaust = { index = 4, label = "Exhaust", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-smoke", multiplier = 0.2, sale = false },
	modFrame = { index = 5, label = "Chassis", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-select", multiplier = 0.2, sale = false },
	modGrille = { index = 6, label = "Grill", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-settings", multiplier = 0.2, sale = false },
	modHood = { index = 7, label = "Bonnet", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-windshield", multiplier = 0.2, sale = false },
	modFender = { index = 8, label = "Left Wing", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-arrow-left", multiplier = 0.2, sale = false },
	modRightFender = { index = 9, label = "Right Wing", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-arrow-right", multiplier = 0.2, sale = false },
	modRoof = { index = 10, label = "Roof", description = "Pimp your ride by changing your vehicle body kit.", icon = "mdi-car-convertible", multiplier = 0.2, sale = false },
	modEngine = { index = 11, label = "Engine", description = "Change your vehicle performance by upgrading his engine.", icon = "mdi-engine", multiplier = 0.2, sale = true },
	modBrakes = { index = 12, label = "Brakes", description = "Change your vehicle brake performance by upgrading his brakes.", icon = "mdi-car-brake-worn-linings", multiplier = 0.2, sale = false },
	modTransmission = { index = 13, label = "Transmission", description = "Change your vehicle performance by upgrading his transmission.", icon = "mdi-image-filter-tilt-shift", multiplier = 0.2, sale = false },
	modHorns = { index = 14, label = "Horn", description = "Change your vehicle horn sound by upgrading his horn.", icon = "mdi-bugle", multiplier = 0.2, sale = false },
	modSuspension = { index = 15, label = "Suspension", description = "Change your vehicle height by upgrading his suspension.", icon = "mdi-car-clutch", multiplier = 0.2, sale = false },
	modArmor = { index = 16, label = "Armour", description = "Change your vehicle armour by upgrading his armour.", icon = "mdi-shield", multiplier = 0.2, sale = false },
	modNitrous = { index = 17, label = "Nitrous", description = "Install a nitrous system and let your vehicle shoot big falmes.", icon = "mdi-car-speed-limiter", multiplier = 0.2, sale = false },
	modTurbo = { index = 18, label = "Turbo", description = "Put a big boy air intake by slamming turbo on your engine.", icon = "mdi-car-turbocharger", multiplier = 0.2, sale = false, isToggle = true },
	modSubwoofer = { index = 19, label = "Subwoofer", description = "Install a subwoofer and let ear your bangers out loud.", icon = "mdi-soundbar", multiplier = 0.2, sale = false },
	tyreSmokeColor = { index = 20, label = "Tyre Smoke", description = "Change your tyre smoke color.", icon = "mdi-format-color-fill", multiplier = 0.2, sale = false, hasColor = true },
	--modHydraulics = { index = 21, label = "Hydraulics", description = "Put a big boy hydraulic system and slam your car on the ground.", icon = "mdi-hydraulic-oil-level", multiplier = 0.2, sale = false },
	modXenon = { index = 22, label = "Xenon Lights", description = "Install xenon lights and let your vehicle with nice bright headlights.", icon = "mdi-car-light-high", multiplier = 0.2, sale = false, isToggle = true, hasColor = true },
	modFrontWheels = { index = 23, label = "Wheels", description = "Change your vehicle style by changing his wheels.", icon = "mdi-tire", multiplier = 0.2, sale = false, hasColor = true },
	modBackWheels = { index = 24, label = "Rear Wheels", description = "Change your vehicle style by changing his wheels.", icon = "mdi-tire", multiplier = 0.2, sale = false, hasColor = true },
	modPlateHolder = { index = 25, label = "Plate Holder", description = "Change your plate style by changing his holder.", icon = "mdi-card-outline", multiplier = 0.2, sale = false },
	modVanityPlate = { index = 26, label = "Plate Vanity", description = "Change your plate style by changing his vanity.", icon = "mdi-card", multiplier = 0.2, sale = false },
	modTrimA = { index = 27, label = "Trim", description = "Put some uncle things on your ride.", icon = "mdi-cards-variant", multiplier = 0.2, sale = false },
	modOrnaments = { index = 28, label = "Ornaments", description = "Pimp your car and dashboard with some ornaments.", icon = "mdi-cards-playing-spade", multiplier = 0.2, sale = false },
	modDashboard = { index = 29, label = "Dashboard", description = "Change your dashboard texture and material.", icon = "mdi-carabiner", multiplier = 0.2, sale = false },
	modDial = { index = 30, label = "Speedometer", description = "Change you dashboard speedometer style and graphics.", icon = "mdi-speedometer", multiplier = 0.2, sale = false },
	modDoorSpeaker = { index = 31, label = "Door Interior", description = "Change your vehicle doors texture and material.", icon = "mdi-car-door", multiplier = 0.2, sale = false },
	modSeats = { index = 32, label = "Seats", description = "Put yourself confortable in your ride by changing is seats.", icon = "mdi-car-seat", multiplier = 0.2, sale = false },
	modSteeringWheel = { index = 33, label = "Steering Wheel", description = "Change your performance behind the wheel by changing the steering wheel.", icon = "mdi-steering", multiplier = 0.2, sale = false },
	modShifterLeavers = { index = 34, label = "Shift Knob", description = "Change your performance behind the wheel by changing the shift knob.", icon = "mdi-car-shift-pattern", multiplier = 0.2, sale = false },
	--modAPlate = { index = 35, label = "Plaque", description = "Change your plate style by changing his plate.", icon = "mdi-card-bulleted", multiplier = 0.2, sale = false },
	modSpeakers = { index = 36, label = "Speakers", description = "Play your bangger out loud with a speaker.", icon = "mdi-speaker", multiplier = 0.2, sale = false },
	modTrunk = { index = 37, label = "Trunk", description = "Change your car booty by changing is trunk.", icon = "mdi-caravan", multiplier = 0.2, sale = false },
	modHydrolic = { index = 38, label = "Hydrolic", description = "Put a big boy hydraulic system and slam your car on the ground.", icon = "mdi-hydraulic-oil-level", multiplier = 0.2, sale = false },
	modEngineBlock = { index = 39, label = "Engine Block", description = "Change your HP maker block and pimp it while spitting fire.", icon = "mdi-engine-outline", multiplier = 0.2, sale = false },
	modAirFilter = { index = 40, label = "Air Filter", description = "Change your air filter.", icon = "mdi-air-filter", multiplier = 0.2, sale = false },
	modStruts = { index = 41, label = "Struts", description = "Change your engine block struts.", icon = "mdi-hammer-screwdriver", multiplier = 0.2, sale = false },
	modArchCover = { index = 42, label = "Arch Cover", description = "Change your arch cover.", icon = "mdi-ruler-square-compass", multiplier = 0.2, sale = false },
	modAerials = { index = 43, label = "Aerials", description = "Change your aerials and hood strips.", icon = "mdi-car-windshield-outline", multiplier = 0.2, sale = false },
	modTrimB = { index = 44, label = "Roof Scoop", description = "Change your roof accessories.", icon = "mdi-car-emergency", multiplier = 0.2, sale = false },
	modTank = { index = 45, label = "Tank", description = "Change your vehicle tank texture and material.", icon = "mdi-car-coolant-level", multiplier = 0.2, sale = false },
	modWindows = { index = 46, label = "Windows", description = "Change your vehicle window accessories.", icon = "mdi-window-closed", multiplier = 0.2, sale = false },
	--DOOR_R = { index = 47, label = "Right Door", description = "", icon = "", multiplier = 0.2, sale = false },
	modLivery = { index = 48, label = "Livery", description = "Call attention to you paint job by slamming some liveries.", icon = "mdi-cards", multiplier = 0.2, sale = false },
	modLightbar = { index = 49, label = "Lightbar", description = "Put a lightbar to help lightning the road.", icon = "mdi-lightbulb-fluorescent-tube-outline", multiplier = 0.2, sale = false }
}