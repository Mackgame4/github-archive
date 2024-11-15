local Components = {
	{label = _U('sex'),						name = 'sex',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('mom'),						name = 'mom',				value = 21,		min = 21,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('dad'),						name = 'dad',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('resemblance'),				name = 'face_md_weight',	value = 50,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('skin_tone'),				name = 'skin_md_weight',	value = 50,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('nose_1'),					name = 'nose_1',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('nose_2'),					name = 'nose_2',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('nose_3'),					name = 'nose_3',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('nose_4'),					name = 'nose_4',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('nose_5'),					name = 'nose_5',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('nose_6'),					name = 'nose_6',			value = 0,		min = -10,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('cheeks_1'),				name = 'cheeks_1',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('cheeks_2'),				name = 'cheeks_2',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('cheeks_3'),				name = 'cheeks_3',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lip_fullness'),			name = 'lip_thickness',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('jaw_bone_width'),			name = 'jaw_1',				value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('jaw_bone_length'),			name = 'jaw_2',				value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('chin_height'),				name = 'chin_1',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('chin_length'),				name = 'chin_2',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('chin_width'),				name = 'chin_3',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('chin_hole'),				name = 'chin_4',			value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('neck_thickness'),			name = 'neck_thickness',	value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('hair_1'),					name = 'hair_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_2'),					name = 'hair_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_color_1'),			name = 'hair_color_1',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_color_2'),			name = 'hair_color_2',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('tshirt_1'),				name = 'tshirt_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 8},
	{label = _U('tshirt_2'),				name = 'tshirt_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'tshirt_1'},
	{label = _U('torso_1'),					name = 'torso_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 11},
	{label = _U('torso_2'),					name = 'torso_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'torso_1'},
	{label = _U('decals_1'),				name = 'decals_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 10},
	{label = _U('decals_2'),				name = 'decals_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'decals_1'},
	{label = _U('arms'),					name = 'arms',				value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('arms_2'),					name = 'arms_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('pants_1'),					name = 'pants_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	componentId	= 4},
	{label = _U('pants_2'),					name = 'pants_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	textureof	= 'pants_1'},
	{label = _U('shoes_1'),					name = 'shoes_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	componentId	= 6},
	{label = _U('shoes_2'),					name = 'shoes_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	textureof	= 'shoes_1'},
	{label = _U('mask_1'),					name = 'mask_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = _U('mask_2'),					name = 'mask_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'mask_1'},
	{label = _U('bproof_1'),				name = 'bproof_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 9},
	{label = _U('bproof_2'),				name = 'bproof_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bproof_1'},
	{label = _U('chain_1'),					name = 'chain_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 7},
	{label = _U('chain_2'),					name = 'chain_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'chain_1'},
	{label = _U('helmet_1'),				name = 'helmet_1',			value = -1,		min = -1,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 0 },
	{label = _U('helmet_2'),				name = 'helmet_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'helmet_1'},
	{label = _U('glasses_1'),				name = 'glasses_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 1},
	{label = _U('glasses_2'),				name = 'glasses_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'glasses_1'},
	{label = _U('watches_1'),				name = 'watches_1',			value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 6},
	{label = _U('watches_2'),				name = 'watches_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'watches_1'},
	{label = _U('bracelets_1'),				name = 'bracelets_1',		value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 7},
	{label = _U('bracelets_2'),				name = 'bracelets_2',		value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bracelets_1'},
	{label = _U('bag'),						name = 'bags_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	componentId	= 5},
	{label = _U('bag_color'),				name = 'bags_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bags_1'},
	{label = _U('eye_color'),				name = 'eye_color',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eye_squint'),				name = 'eye_squint',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_size'),			name = 'eyebrows_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_type'),			name = 'eyebrows_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_color_1'),			name = 'eyebrows_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_color_2'),			name = 'eyebrows_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_height'),			name = 'eyebrows_5',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_depth'),			name = 'eyebrows_6',		value = 0,		min = -10,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_type'),				name = 'makeup_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_thickness'),		name = 'makeup_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_color_1'),			name = 'makeup_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_color_2'),			name = 'makeup_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_type'),			name = 'lipstick_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_thickness'),		name = 'lipstick_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_color_1'),		name = 'lipstick_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_color_2'),		name = 'lipstick_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('ear_accessories'),			name = 'ears_1',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.65,	componentId	= 2},
	{label = _U('ear_accessories_color'),	name = 'ears_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65,	textureof	= 'ears_1'},
	{label = _U('chest_hair'),				name = 'chest_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('chest_hair_1'),			name = 'chest_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('chest_color'),				name = 'chest_3',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bodyb'),					name = 'bodyb_1',			value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bodyb_size'),				name = 'bodyb_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bodyb_extra'),				name = 'bodyb_3',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.15},
	{label = _U('bodyb_extra_thickness'),	name = 'bodyb_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.15},
	{label = _U('wrinkles'),				name = 'age_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('wrinkle_thickness'),		name = 'age_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blemishes'),				name = 'blemishes_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blemishes_size'),			name = 'blemishes_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blush'),					name = 'blush_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blush_1'),					name = 'blush_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blush_color'),				name = 'blush_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('complexion'),				name = 'complexion_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('complexion_1'),			name = 'complexion_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('sun'),						name = 'sun_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('sun_1'),					name = 'sun_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('freckles'),				name = 'moles_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('freckles_1'),				name = 'moles_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_type'),				name = 'beard_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_size'),				name = 'beard_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_color_1'),			name = 'beard_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_color_2'),			name = 'beard_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65}
}

local LastSex		= -1
local LoadSkin		= nil
local LoadClothes	= nil
local Character		= {}

for i=1, #Components, 1 do
	Character[Components[i].name] = Components[i].value
end

function LoadDefaultModel(malePed, cb)
	local playerPed = PlayerPedId()
	local characterModel

	if malePed then
		characterModel = GetHashKey('mp_m_freemode_01')
	else
		characterModel = GetHashKey('mp_f_freemode_01')
	end

	RequestModel(characterModel)

	Citizen.CreateThread(function()
		while not HasModelLoaded(characterModel) do
			RequestModel(characterModel)
			Citizen.Wait(0)
		end

		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(playerPed)
		end

		SetModelAsNoLongerNeeded(characterModel)

		if cb ~= nil then
			cb()
		end

		TriggerEvent('skinchanger:modelLoaded')
	end)
end

function GetMaxVals()
	local playerPed = PlayerPedId()

	local data = {
		sex				= 1,
		mom				= 45, -- numbers 21-41 and 45 are female (22 total)
		dad				= 44, -- numbers 0-20 and 42-44 are male (24 total)
		face_md_weight	= 100,
		skin_md_weight	= 100,
		nose_1			= 10,
		nose_2			= 10,
		nose_3			= 10,
		nose_4			= 10,
		nose_5			= 10,
		nose_6			= 10,
		cheeks_1		= 10,
		cheeks_2		= 10,
		cheeks_3		= 10,
		lip_thickness	= 10,
		jaw_1			= 10,
		jaw_2			= 10,
		chin_1			= 10,
		chin_2			= 10,
		chin_3			= 10,
		chin_4			= 10,
		neck_thickness	= 10,
		age_1			= GetNumHeadOverlayValues(3)-1,
		age_2			= 10,
		beard_1			= GetNumHeadOverlayValues(1)-1,
		beard_2			= 10,
		beard_3			= GetNumHairColors()-1,
		beard_4			= GetNumHairColors()-1,
		hair_1			= GetNumberOfPedDrawableVariations		(playerPed, 2) - 1,
		hair_2			= GetNumberOfPedTextureVariations		(playerPed, 2, Character['hair_1']) - 1,
		hair_color_1	= GetNumHairColors()-1,
		hair_color_2	= GetNumHairColors()-1,
		eye_color		= 31,
		eye_squint		= 10,
		eyebrows_1		= GetNumHeadOverlayValues(2)-1,
		eyebrows_2		= 10,
		eyebrows_3		= GetNumHairColors()-1,
		eyebrows_4		= GetNumHairColors()-1,
		eyebrows_5		= 10,
		eyebrows_6		= 10,
		makeup_1		= GetNumHeadOverlayValues(4)-1,
		makeup_2		= 10,
		makeup_3		= GetNumHairColors()-1,
		makeup_4		= GetNumHairColors()-1,
		lipstick_1		= GetNumHeadOverlayValues(8)-1,
		lipstick_2		= 10,
		lipstick_3		= GetNumHairColors()-1,
		lipstick_4		= GetNumHairColors()-1,
		blemishes_1		= GetNumHeadOverlayValues(0)-1,
		blemishes_2		= 10,
		blush_1			= GetNumHeadOverlayValues(5)-1,
		blush_2			= 10,
		blush_3			= GetNumHairColors()-1,
		complexion_1	= GetNumHeadOverlayValues(6)-1,
		complexion_2	= 10,
		sun_1			= GetNumHeadOverlayValues(7)-1,
		sun_2			= 10,
		moles_1			= GetNumHeadOverlayValues(9)-1,
		moles_2			= 10,
		chest_1			= GetNumHeadOverlayValues(10)-1,
		chest_2			= 10,
		chest_3			= GetNumHairColors()-1,
		bodyb_1			= GetNumHeadOverlayValues(11)-1,
		bodyb_2			= 10,
		bodyb_3			= GetNumHeadOverlayValues(12)-1,
		bodyb_4			= 10,
		ears_1			= GetNumberOfPedPropDrawableVariations	(playerPed, 2) - 1,
		ears_2			= GetNumberOfPedPropTextureVariations	(playerPed, 2, Character['ears_1'] - 1),
		tshirt_1		= GetNumberOfPedDrawableVariations		(playerPed, 8) - 1,
		tshirt_2		= GetNumberOfPedTextureVariations		(playerPed, 8, Character['tshirt_1']) - 1,
		torso_1			= GetNumberOfPedDrawableVariations		(playerPed, 11) - 1,
		torso_2			= GetNumberOfPedTextureVariations		(playerPed, 11, Character['torso_1']) - 1,
		decals_1		= GetNumberOfPedDrawableVariations		(playerPed, 10) - 1,
		decals_2		= GetNumberOfPedTextureVariations		(playerPed, 10, Character['decals_1']) - 1,
		arms			= GetNumberOfPedDrawableVariations		(playerPed, 3) - 1,
		arms_2			= 10,
		pants_1			= GetNumberOfPedDrawableVariations		(playerPed, 4) - 1,
		pants_2			= GetNumberOfPedTextureVariations		(playerPed, 4, Character['pants_1']) - 1,
		shoes_1			= GetNumberOfPedDrawableVariations		(playerPed, 6) - 1,
		shoes_2			= GetNumberOfPedTextureVariations		(playerPed, 6, Character['shoes_1']) - 1,
		mask_1			= GetNumberOfPedDrawableVariations		(playerPed, 1) - 1,
		mask_2			= GetNumberOfPedTextureVariations		(playerPed, 1, Character['mask_1']) - 1,
		bproof_1		= GetNumberOfPedDrawableVariations		(playerPed, 9) - 1,
		bproof_2		= GetNumberOfPedTextureVariations		(playerPed, 9, Character['bproof_1']) - 1,
		chain_1			= GetNumberOfPedDrawableVariations		(playerPed, 7) - 1,
		chain_2			= GetNumberOfPedTextureVariations		(playerPed, 7, Character['chain_1']) - 1,
		bags_1			= GetNumberOfPedDrawableVariations		(playerPed, 5) - 1,
		bags_2			= GetNumberOfPedTextureVariations		(playerPed, 5, Character['bags_1']) - 1,
		helmet_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 0) - 1,
		helmet_2		= GetNumberOfPedPropTextureVariations	(playerPed, 0, Character['helmet_1']) - 1,
		glasses_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 1) - 1,
		glasses_2		= GetNumberOfPedPropTextureVariations	(playerPed, 1, Character['glasses_1'] - 1),
		watches_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 6) - 1,
		watches_2		= GetNumberOfPedPropTextureVariations	(playerPed, 6, Character['watches_1']) - 1,
		bracelets_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 7) - 1,
		bracelets_2		= GetNumberOfPedPropTextureVariations	(playerPed, 7, Character['bracelets_1'] - 1)
	}

	return data
end

function ApplySkin(skin, clothes)
	local playerPed = PlayerPedId()

	for k,v in pairs(skin) do
		Character[k] = v
	end

	if clothes ~= nil then
		for k,v in pairs(clothes) do
			if
				k ~= 'sex'				and
				k ~= 'mom'				and
				k ~= 'dad'				and
				k ~= 'face_md_weight'	and
				k ~= 'skin_md_weight'	and
				k ~= 'nose_1'			and
				k ~= 'nose_2'			and
				k ~= 'nose_3'			and
				k ~= 'nose_4'			and
				k ~= 'nose_5'			and
				k ~= 'nose_6'			and
				k ~= 'cheeks_1'			and
				k ~= 'cheeks_2'			and
				k ~= 'cheeks_3'			and
				k ~= 'lip_thickness'	and
				k ~= 'jaw_1'			and
				k ~= 'jaw_2'			and
				k ~= 'chin_1'			and
				k ~= 'chin_2'			and
				k ~= 'chin_3'			and
				k ~= 'chin_4'			and
				k ~= 'neck_thickness'	and
				k ~= 'age_1'			and
				k ~= 'age_2'			and
				k ~= 'eye_color'		and
				k ~= 'eye_squint'		and
				k ~= 'beard_1'			and
				k ~= 'beard_2'			and
				k ~= 'beard_3'			and
				k ~= 'beard_4'			and
				k ~= 'hair_1'			and
				k ~= 'hair_2'			and
				k ~= 'hair_color_1'		and
				k ~= 'hair_color_2'		and
				k ~= 'eyebrows_1'		and
				k ~= 'eyebrows_2'		and
				k ~= 'eyebrows_3'		and
				k ~= 'eyebrows_4'		and
				k ~= 'eyebrows_5'		and
				k ~= 'eyebrows_6'		and
				k ~= 'makeup_1'			and
				k ~= 'makeup_2'			and
				k ~= 'makeup_3'			and
				k ~= 'makeup_4'			and
				k ~= 'lipstick_1'		and
				k ~= 'lipstick_2'		and
				k ~= 'lipstick_3'		and
				k ~= 'lipstick_4'		and
				k ~= 'blemishes_1'		and
				k ~= 'blemishes_2'		and
				k ~= 'blemishes_3'		and
				k ~= 'blush_1'			and
				k ~= 'blush_2'			and
				k ~= 'blush_3'			and
				k ~= 'complexion_1'		and
				k ~= 'complexion_2'		and
				k ~= 'sun_1'			and
				k ~= 'sun_2'			and
				k ~= 'moles_1'			and
				k ~= 'moles_2'			and
				k ~= 'chest_1'			and
				k ~= 'chest_2'			and
				k ~= 'chest_3'			and
				k ~= 'bodyb_1'			and
				k ~= 'bodyb_2'			and
				k ~= 'bodyb_3'			and
				k ~= 'bodyb_4'
			then
				Character[k] = v
			end
		end
	end

	local face_weight = 		(Character['face_md_weight'] / 100) + 0.0
	local skin_weight =			(Character['skin_md_weight'] / 100) + 0.0
	SetPedHeadBlendData			(playerPed, Character['mom'], Character['dad'], 0, Character['mom'], Character['dad'], 0, face_weight, skin_weight, 0.0, false)

	SetPedFaceFeature			(playerPed,			0,								(Character['nose_1'] / 10) + 0.0)			-- Nose Width
	SetPedFaceFeature			(playerPed,			1,								(Character['nose_2'] / 10) + 0.0)			-- Nose Peak Height
	SetPedFaceFeature			(playerPed,			2,								(Character['nose_3'] / 10) + 0.0)			-- Nose Peak Length
	SetPedFaceFeature			(playerPed,			3,								(Character['nose_4'] / 10) + 0.0)			-- Nose Bone Height
	SetPedFaceFeature			(playerPed,			4,								(Character['nose_5'] / 10) + 0.0)			-- Nose Peak Lowering
	SetPedFaceFeature			(playerPed,			5,								(Character['nose_6'] / 10) + 0.0)			-- Nose Bone Twist
	SetPedFaceFeature			(playerPed,			6,								(Character['eyebrows_5'] / 10) + 0.0)		-- Eyebrow height
	SetPedFaceFeature			(playerPed,			7,								(Character['eyebrows_6'] / 10) + 0.0)		-- Eyebrow depth
	SetPedFaceFeature			(playerPed,			8,								(Character['cheeks_1'] / 10) + 0.0)			-- Cheekbones Height
	SetPedFaceFeature			(playerPed,			9,								(Character['cheeks_2'] / 10) + 0.0)			-- Cheekbones Width
	SetPedFaceFeature			(playerPed,			10,								(Character['cheeks_3'] / 10) + 0.0)			-- Cheeks Width
	SetPedFaceFeature			(playerPed,			11,								(Character['eye_squint'] / 10) + 0.0)		-- Eyes squint
	SetPedFaceFeature			(playerPed,			12,								(Character['lip_thickness'] / 10) + 0.0)	-- Lip Fullness
	SetPedFaceFeature			(playerPed,			13,								(Character['jaw_1'] / 10) + 0.0)			-- Jaw Bone Width
	SetPedFaceFeature			(playerPed,			14,								(Character['jaw_2'] / 10) + 0.0)			-- Jaw Bone Length
	SetPedFaceFeature			(playerPed,			15,								(Character['chin_1'] / 10) + 0.0)			-- Chin Height
	SetPedFaceFeature			(playerPed,			16,								(Character['chin_2'] / 10) + 0.0)			-- Chin Length
	SetPedFaceFeature			(playerPed,			17,								(Character['chin_3'] / 10) + 0.0)			-- Chin Width
	SetPedFaceFeature			(playerPed,			18,								(Character['chin_4'] / 10) + 0.0)			-- Chin Hole Size
	SetPedFaceFeature			(playerPed,			19,								(Character['neck_thickness'] / 10) + 0.0)	-- Neck Thickness

	SetPedHairColor				(playerPed,			Character['hair_color_1'],		Character['hair_color_2'])					-- Hair Color
	SetPedHeadOverlay			(playerPed, 3,		Character['age_1'],				(Character['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay			(playerPed, 0,		Character['blemishes_1'],		(Character['blemishes_2'] / 10) + 0.0)		-- Blemishes + opacity
	SetPedHeadOverlay			(playerPed, 1,		Character['beard_1'],			(Character['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor				(playerPed,			Character['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(playerPed, 2,		Character['eyebrows_1'],		(Character['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedHeadOverlay			(playerPed, 4,		Character['makeup_1'],			(Character['makeup_2'] / 10) + 0.0)			-- Makeup + opacity
	SetPedHeadOverlay			(playerPed, 8,		Character['lipstick_1'],		(Character['lipstick_2'] / 10) + 0.0)		-- Lipstick + opacity
	SetPedComponentVariation	(playerPed, 2,		Character['hair_1'],			Character['hair_2'], 2)						-- Hair
	SetPedHeadOverlayColor		(playerPed, 1, 1,	Character['beard_3'],			Character['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(playerPed, 2, 1,	Character['eyebrows_3'],		Character['eyebrows_4'])					-- Eyebrows Color
	SetPedHeadOverlayColor		(playerPed, 4, 2,	Character['makeup_3'],			Character['makeup_4'])						-- Makeup Color
	SetPedHeadOverlayColor		(playerPed, 8, 1,	Character['lipstick_3'],		Character['lipstick_4'])					-- Lipstick Color
	SetPedHeadOverlay			(playerPed, 5,		Character['blush_1'],			(Character['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor		(playerPed, 5, 2,	Character['blush_3'])														-- Blush Color
	SetPedHeadOverlay			(playerPed, 6,		Character['complexion_1'],		(Character['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay			(playerPed, 7,		Character['sun_1'],				(Character['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay			(playerPed, 9,		Character['moles_1'],			(Character['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay			(playerPed, 10,		Character['chest_1'],			(Character['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor		(playerPed, 10, 1,	Character['chest_3'])														-- Torso Color

	if Character['bodyb_1'] == -1 then
		SetPedHeadOverlay		(playerPed, 11,		255,						(Character['bodyb_2'] / 10) + 0.0)		-- Body Blemishes + opacity
	else
		SetPedHeadOverlay		(playerPed, 11,		Character['bodyb_1'],		(Character['bodyb_2'] / 10) + 0.0)
	end

	if Character['bodyb_3'] == -1 then
		SetPedHeadOverlay		(playerPed, 12,		255,							(Character['bodyb_4'] / 10) + 0.0)
	else
		SetPedHeadOverlay		(playerPed, 12,		Character['bodyb_3'],			(Character['bodyb_4'] / 10) + 0.0)			-- Blemishes 'added body effect' + opacity
	end

	if Character['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex			(playerPed, 2,		Character['ears_1'],			Character['ears_2'], 2)						-- Ears Accessories
	end

	SetPedComponentVariation	(playerPed, 8,		Character['tshirt_1'],			Character['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(playerPed, 11,		Character['torso_1'],			Character['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(playerPed, 3,		Character['arms'],				Character['arms_2'], 2)						-- Amrs
	SetPedComponentVariation	(playerPed, 10,		Character['decals_1'],			Character['decals_2'], 2)					-- decals
	SetPedComponentVariation	(playerPed, 4,		Character['pants_1'],			Character['pants_2'], 2)					-- pants
	SetPedComponentVariation	(playerPed, 6,		Character['shoes_1'],			Character['shoes_2'], 2)					-- shoes
	SetPedComponentVariation	(playerPed, 1,		Character['mask_1'],			Character['mask_2'], 2)						-- mask
	SetPedComponentVariation	(playerPed, 9,		Character['bproof_1'],			Character['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(playerPed, 7,		Character['chain_1'],			Character['chain_2'], 2)					-- chain
	SetPedComponentVariation	(playerPed, 5,		Character['bags_1'],			Character['bags_2'], 2)						-- Bag

	if Character['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex			(playerPed, 0,		Character['helmet_1'],			Character['helmet_2'], 2)					-- Helmet
	end

	if Character['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex			(playerPed, 1,		Character['glasses_1'],			Character['glasses_2'], 2)					-- Glasses
	end

	if Character['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex			(playerPed, 6,		Character['watches_1'],			Character['watches_2'], 2)					-- Watches
	end

	if Character['bracelets_1'] == -1 then
		ClearPedProp(playerPed,	7)
	else
		SetPedPropIndex			(playerPed, 7,		Character['bracelets_1'],		Character['bracelets_2'], 2)				-- Bracelets
	end
end

AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
	LoadDefaultModel(loadMale, cb)
end)

AddEventHandler('skinchanger:getData', function(cb)
	local components = json.decode(json.encode(Components))

	for k,v in pairs(Character) do
		for i=1, #components, 1 do
			if k == components[i].name then
				components[i].value = v
				--components[i].zoomOffset = Components[i].zoomOffset
				--components[i].camOffset = Components[i].camOffset
			end
		end
	end

	cb(components, GetMaxVals())
end)

AddEventHandler('skinchanger:change', function(key, val)
	Character[key] = val

	if key == 'sex' then
		TriggerEvent('skinchanger:loadSkin', Character)
	else
		ApplySkin(Character)
	end
end)

AddEventHandler('skinchanger:getSkin', function(cb)
	cb(Character)
end)

AddEventHandler('skinchanger:modelLoaded', function()
	ClearPedProp(PlayerPedId(), 0)

	if LoadSkin ~= nil then
		ApplySkin(LoadSkin)
		LoadSkin = nil
	end

	if LoadClothes ~= nil then
		ApplySkin(LoadClothes.playerSkin, LoadClothes.clothesSkin)
		LoadClothes = nil
	end
end)

RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	if skin['sex'] ~= LastSex then
		LoadSkin = skin

		if skin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true, cb)
		else
			TriggerEvent('skinchanger:loadDefaultModel', false, cb)
		end
	else
		ApplySkin(skin)

		if cb ~= nil then
			cb()
		end
	end

	LastSex = skin['sex']
end)

RegisterNetEvent('skinchanger:loadClothes')
AddEventHandler('skinchanger:loadClothes', function(playerSkin, clothesSkin)
	if playerSkin['sex'] ~= LastSex then
		LoadClothes = {
			playerSkin	= playerSkin,
			clothesSkin	= clothesSkin
		}

		if playerSkin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true)
		else
			TriggerEvent('skinchanger:loadDefaultModel', false)
		end
	else
		ApplySkin(playerSkin, clothesSkin)
	end

	LastSex = playerSkin['sex']
end)

RegisterNetEvent('skinchanger:clearPed')
AddEventHandler('skinchanger:clearPed', function()
	--local playerPed = PlayerPedId()
	--SetPedDefaultComponentVariation(playerPed) -- useful command but doesnt alter props (hemlet, watches etc)

	for k in pairs(Character) do
		if 	k ~= 'helmet_1' 	and
			k ~= 'bracelets_1' 	and
			k ~= 'watches_1' 	and
			k ~= 'glasses_1'	and
			k ~= 'sex' 	
		then
			Character[k] = 0	
		else
			Character[k] = -1
		end
	end
	
	--[[ClearPedProp(playerPed, 0) --helmet
	ClearPedProp(playerPed,	7) --bracelets
	ClearPedProp(playerPed, 6) --watch
	ClearPedProp(playerPed, 1) --glasses
	]]--#region
	LastSex = Character['sex']
	TriggerEvent('skinchanger:loadSkin', Character)
end)

RegisterNetEvent('skinchanger:givePlayerSkin')	
AddEventHandler('skinchanger:givePlayerSkin', function()
	TriggerEvent("clotheShops:getPlayerSkin", Character)
end)

RegisterNetEvent('skinchanger:getJacketVariations')	-- arm/torso_1 variations for clipping issues...
AddEventHandler('skinchanger:getJacketVariations', function(value , gender)
	if gender == 0 then
		TriggerEvent('skinchanger:change', 'arms', MVariations[value + 1])
	end
	if gender == 1 then
		TriggerEvent('skinchanger:change', 'arms', FVariations[value + 1])
	end
end)

MVariations = 
{
--	0	1	2	3	4	5	6	7	8	9	10	
	15,	0,	2,	14,	14,	5,	14,	14,	11,	0,	14, -- 0 -> 10
		5,	1,	11,	4,	15,	0,	5,	0,	14,	14,		--20
		5,	0,	14,	14,	15,	0,	14,	14,	14,	14, 	--30
		14,	14,	0,	0,	14,	5,	14,	8,	0,	5,		--40
		1,	11,	11,	0,	5,	14,	0,	1,	1,	5,		--50
		1,	8,	8,	14,	5,	0,	0,	14,	14,	15,		--60
		1,	14,	11,	14,	14,	15,	14,	14,	14,	14,		--70
		0,	14,	0,	14,	14,	15,	14,	14,	14,	0,		--80
		0,	0,	0,	14,	14,	0,	14,	14,	14,	0,		--90
		15,	14,	0,	0,	8,	0,	0,	14,	14,	14,		--100
		14,	14,	14,	14,	0,	14,	0,	14,	2,	14,		--110
		4,	14,	11,	4,	14,	14,	14,	14,	14,	5,		--120
		14,	14,	0,	15,	15,	0,	14,	0,	14,	14, 	--130
		0,	0,	0,	0,	0,	14,	2,	8,	14,	14,		--140
		12,	14,	11,	14,	14,	0,	4,	1,	14,	14,		--150
		14,	8,	8,	14,	5,	14,	15,	15,	15,	15,		--160
		14,	15,	14,	11,	14,	15,	14,	14,	14,	15,		--170
		0,	14,	15,	14,	15,	15,	15,	14,	15,	15,		--180
		14,	0,	14,	14,	14,	0,	14,	14,	14,	0,		--190
		15,	14,	0,	0,	8,	0,	0,	14,	14,	14,		--200
		13,	15,	14,	14,	15,	15,	15,	0,	14,	14,		--210
		4,	14,	2,	4,	14,	15,	14,	14,	15,	5,		--220
		14,	11,	15,	12,	8,	0,	4,	4,	14,	14, 	--230
		4,	14,	14,	0,	0,	5,	2,	5,	5,	14,		--240
		0,	0,	11,	14,	14,	3,	0,	1,	6,	11,		--250
		14,	15,	8,	12,	11,	14,	6,	15,	15,	15,		--260
		14,	15,	14,	6,	14,	15,	14,	14,	14,	4,		--270
		0,	14,	0,	4,	15,	15,	164,14,	15,	15,		--280
		14,	0,	15,	14,	14,	0,	14,	14,	0,	5,		--290
		0,	14,	6,	6,	6,	0,	0,	14,	5,	14,		--300
		14,	14,	14,	14,	0,	14,	0,	14,	14,	15,		--310	--314 -> 320 firefighter + police 
		14,	14,	0,	4,	14,	14,	14,	0,	0,	5,		--320
		8,	8,	0,	15,	15,	0,	15,	0,	14,	14, 	--330
		0,	0,	169,0,	8,	14,	0,	14,14,	14,		--340	--333 + 277 custom arms (164 ,169)
		12,	14,	11,	14,	0,	15,	15,	1,	14,	0,		--350
		0,	15,	8,	0,	15,	8,	15,	15,	15,	14,		--360
		14,	14,	15,	15,	15,	15,	15,	15,	15,	12,		--370
		0,	7,	0,	4,	15,	14,	2,	14,	4,	4,		--380
		14,
	--	1	2	3	4	5	6	7	8	9	10	
}

FVariations = {
--	0	1	2	3	4	5	6	7	8	9	10	
	15,	5,	2,	3,	15,	15,	5,	5,	5,	0,	5, -- 0 -> 10
		15,	15,	15,	4,	15,	15,	0,	15,	15,	5,		--20
		15,	15,	15,	5,	5,	15,	0,	15,	9,	2, 		--30 -- 29 is... just broken
		5,	15,	15,	5,	5,	15,	15,	2,	0,	2,		--40
		1,	3,	3,	3,	3,	3,	3,	14,	14,	3,		--50
		5,	5,	5,	3,	3,	14,	5,	5,	5,	5,		--60
		3,	5,	5,	5,	5,	5,	2,	14,	5,	5,		--70
		5,	14,	14,	15,	0,	11,	14,	14,	14,	0,		--80	--82 full nude torso
		0,	15,	0,	14,	14,	0,	14,	14,	14,	5,		--90
		5,	5,	5,	5,	5,	9,	5,	3,	15,	15,		--100
		15,	3,	3,	5,	15,	6,	5,	5,	0,	3,		--110
		15,	11,	11,	11,	11,	11,	11,	11,	0,	5,		--120
		14,	14,	0,	4,	14,	14,	3,	0,	14,	0, 		--130	--124 has no good torso combo
		3,	0,	5,	11,	3,	3,	5,	6,	5,	3,		--140
		14,	14,	5,	3,	3,	7,	3,	5,	3,	3,		--150
		4,	7,	5,	15,	15,	15,	15,	4,	15,	5,		--160
		14,	14,	5,	5,	4,	5,	15,	15,	15,	15,		--170
		15,	3,	15,	5,	15,	4,	15,	4,	11,	3,		--180
		15,	11,	5,	3,	6,	3,	5,	3,	1,	3,		--190
		5,	14,	5,	5,	15,	3,	3,	14,	14,	4,		--200
		4,	3,	8,	15,	3,	7,	15,	11,	15,	15,		--210
		4,	14,	3,	3,	3,	5,	11,	3,	5,	15,		--220	--325 -> 331 firefighter + police torso
		15,	15,	15,	14,	11,	11,	3,	3,	4,	3, 		--230
		4,	14,	11,	7,	14,	14,	3,	3,	3,	5,		--240
		3,	1,	5,	14,	14,	14,	15,	5,	14,	14,		--250
		3,	1,	11,	8,	11,	1,	7,	14,	15,	15,		--260	--260 full nude torso
		14,	15,	3,	3,	3,	1,	1,	1,	14,	5,		--270
		3,	9,	0,	3,	5,	7,	6,	5,	15,	14,		--280
		14,	3,	15,	15,	11,	14,	8,	3,	3,	205,	--290	--290 has its own arms & 348
		3,	3,	3,	1,	14,	3,	3,	3,	3,	3,		--300
		1,	11,	11,	1,	6,	6,	3,	3,	3,	14,		--310
		3,	3,	3,	5,	6,	3,	3,	1,	3,	5,		--320
		15,	11,	11,	14,	3,	3,	3,	3,	14, 11,		--330
		3,	3,	3,	11,	14,	3,	14,	14,	5,	5,		--340
		1,	11,	3,	3,	3,	3,	3,	210,14,	0,		--350	--348 has no good torso combo
		3,	11,	5,	5,	5,	3,	11,	11,	11,	11,		--360
		3,	3,	5,	15,	15,	3,	3,	11,	14,	3,		--370
		3,	11,	15,	2,	11,	1,	14,	3,	5,	3,		--380
		15,	5,	5,	4,	15,	4,	1,	11,	4,	3,		--390
		8,	3,	3,	3,	14,	1,	3,	3,	5,			--399
	--	1	2	3	4	5	6	7	8	9	10	
}