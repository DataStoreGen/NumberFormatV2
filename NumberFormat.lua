local suffixes = {
	"", "k", "m", "b", "t", "qd", "qn", "sx", "sp",
	"oc", "No", "De", "UDe", "DDe", "TDe", "QdDe", "QnDe", "SxDe",
	"SpDe", "OcDe", "NoDe", "Vt", "UVt", "DVt", "TVt", "QdVt", "QnVt",
	"SxVt", "SpVt", "OcVt", "NoVt", "Tg", "UTg", "DTg", "TTg", "QdTg",
	"QnTg", "SxTg", "SpTg", "OcTg", "NoTg", "qg", "Uqg", "Dqg", "Tqg",
	"Qdqg", "Qnqg", "Sxqg", "Spqg", "Ocqg", "Noqg", "Qg", "UQg", "DQg",
	"TQg", "QdQg", "QnQg", "SxQg", "SpQg", "OcQg", "NoQg", "sg", "Usg",
	"Dsg", "Tsg", "Qdsg", "Qnsg", "Sxsg", "Spsg", "Ocsg", "Nosg", "Sg",
	"USg", "DSg", "TSg", "QdSg", "QnSg", "SxSg", "SpSg", "OcSg", "NoSg",
	"Og", "UOg", "DOg", "TOg", "QdOg", "QnOg", "SxOg", "SpOg", "OcOg",
	"NoOg", "Ng", "UNg", "DNg", "QdNg", "QnNg", "SxNg", "SpNg", "OcNg",
	"NoNg", "Ce", "UCe"
}

local Number = {}

function Number.isNan(val1: number)
	return val1 ~= val1
end

function Number.eq(val1: number, val2: number)
	return val1 == val2
end

function Number.me(val1: number, val2: number)
	return val1 > val2
end

function Number.le(val1: number, val2: number)
	return val1 < val2
end

function Number.meeq(val1: number, val2: number)
	return (val1 > val2) or (val1 == val2)
end

function Number.leeq(val1: number, val2: number)
	return (val1 < val2) or (val1 == val2)
end

function Number.ne(val1: number, val2: number)
	if val1 ~= val1 or val2 ~= val2 then return end
	return not (val1 == val2)
end

function Number.correct(val1: number)
	if val1 == 1/0 then
		val1 = 0
	elseif val1 == 0/0 then
		val1 = 0
	elseif val1 == -1/0 then
		val1 = 0
	elseif val1 == -0/0 then
		val1 = 0
	end
	return val1
end

function Number.add(val1: number, val2: number)
	return val1 + val2
end

function Number.div(val1: number, val2: number)
	return val1 / val2
end

function Number.sub(val1: number, val2: number)
	local sub = val1 - val2
	if sub <= 0 then return 0 end
	return sub
end

function Number.mul(val1: number, val2: number)
	return val1*val2
end

function Number.pow(base: number, exp: number)
	return base ^ exp
end

function Number.floor(val1: number)
	return (val1*100+0.5-(val1*100+0.5)%1)/100
end

function Number.logx(val1)
	return math.log(val1)
end

function Number.log(val1: number, val2: number)
	return Number.logx(val1)/Number.logx(val2)
end

function Number.log10(val1: number)
	return Number.log(val1, 10)
end

function Number.abs(val1: number)
	if val1 ~= val1 then return val1 end
	return (val1 < 0) and -val1 or val1
end

function Number.max(val1: number, val2: number)
	return (val1 > val2) and val1 or val2
end

function Number.min(val1: number, val2: number)
	return (val1 < val2) and val1 or val2
end

function Number.clamp(val1: number, min: number, max: number)
	if val1 ~= val1 or min ~= min or max ~= max then
		return nil
	end
	if min > max then
		min, max = max, min
	end
	return (val1 < min) and min or ((val1 > max) and max or val1)
end

function Number.pi(): number
	return 3.141592653589793
end

function Number.rad(degree: number): number
	local pi = Number.pi()
	local first = degree * pi
	return first / 180
end

function Number.sin(x: number): number
	local pi = Number.pi()
	x = x % (2 * pi)
	if x > pi then
		x = x - 2 * pi
	end
	local sine, facts, power = 0, 1, x
	local max = 10
	for i = 0, max do
		if i > 0 then
			facts = facts * (2 * i) * (2 * i + 1)
			power = power * (-1) * x * x
		end
		sine = sine + power / facts
	end
	return sine
end

function Number.asin(x: number): number
	if x<-1 or x>1 then
		error('must contain -1 or 1')
	end
	local asin, power = x, x
	local max = 10

	for i = 1, max do
		power = power *x*x
		asin = asin+(power/((2*i)*(2*i+1)))
	end
	return asin
end

function Number.sinh(x: number): number
	local sinh, facts, power = x, 1, x
	local max = 10

	for i = 1, max do
		facts = facts * (2*i)*(2*i+1)
		power = power *x*x
		sinh = sinh+power/facts
	end
	return sinh
end

type option = 'shortformat' | 'short'
function Number.shortformat(val1: number): string
	local index = 1
	while Number.meeq(val1, 1000) do
		val1 = val1 / 1000
		index = index + 1
	end
	return string.format('%.2f%s', val1, suffixes[index])
end

function Number.new(man: number, base: number): {number}
	return {man, base}
end

function Number.tt(val1: number): {number}
	if val1 == 0 then return {0,0} end
	local exp = math.floor(math.log10(math.abs(val1)))
	return Number.new(val1/10^exp, exp)
end

function Number.tn(val1: {number}) : number
	return (val1[1] * (10^val1[2]))
end

function Number.short(val1: number): string
	local toTable = Number.tt(val1)
	local SNum = toTable[2]
	local SNum1 = toTable[1]
	local lf = math.fmod(SNum, 3)
	SNum = math.floor(SNum/3)
	SNum -= 1
	if SNum < -1 then return tostring(math.floor(Number.tn(toTable) * 100 + 0.001) / 100) end
	if SNum > #suffixes then return 'inf' end
	SNum1 = SNum1 * 10^lf
	return Number.floor(SNum1) / 100 .. suffixes[SNum+1]
end

function Number.toScience(val1: number): string
	local exp = math.floor(math.abs(math.log10(val1)))
	exp = Number.correct(exp)
	local man = val1/10^exp
	return man .. 'e' .. exp
end

function Number.shortE(val: number, setting: option): string
	local meeq = Number.meeq
	if setting == 'shortformat' then
		local result
		if meeq(val, 10^30) then
			result = Number.toScience(val)
		end
		result = Number.shortformat(val)
		return result
	else
		local result 
		if meeq(val, 10^30) then
			result = Number.toScience(val)
		end
		result = Number.short(val)
		return result
	end
end

function Number.Comma(val1: number)
	local meeq = Number.meeq
	if meeq(val1, 1000) then
		if meeq(val1, 10^12) then
			return '999,999,999,999+'
		end
		local format = tostring(math.floor(val1))
		local sep = ','
		for i = #format-3, 1, -3 do
			format = format:sub(1, i) .. sep .. format:sub(i+1)
		end
		return format
	else
		return tostring(val1)
	end
end

function Number.Percentage(val1: number, val2: number): string
	local precentage = Number.mul(Number.div(val1, val2), 100)
	return precentage .. '%'
end

function Number.CommaToShort(val: number)
	local result
	local meeq = Number.meeq
	if meeq(val, 1e12) then
		result = Number.short(val)
	else
		result = Number.Comma(val)
	end
	return result
end

function Number.Concat(val1: number): 'Returns 1,000 then 1Qg to 1e153'
	local result
	local meeq = Number.meeq
	local leeq = Number.leeq
	if meeq(val1, 1e153) then
		result = Number.toScience(val1)
	else
		result = Number.CommaToShort(val1)
	end
	return result
end

function Number.CorrectTime(value: number)
	local days = math.floor(value / 86400)
	local hours = math.floor((value % 86400) / 3600)
	local minutes = math.floor((value % 3600) / 60)
	local seconds = value % 60
	local result = ""

	if days > 0 then
		result = string.format('%dd', days)
		if hours > 0 then
			result = result .. string.format(':%dh', hours)
		end
		if minutes > 0 then
			result = result .. string.format(':%dm', minutes)
		end
		if seconds > 0 then
			result = result .. string.format(':%ds', seconds)
		end
	elseif hours > 0 then
		result = string.format('%dh', hours)
		if minutes > 0 then
			result = result .. string.format(':%dm', minutes)
		end
		if seconds > 0 then
			result = result .. string.format(':%ds', seconds)
		end
	elseif minutes > 0 then
		result = string.format('%dm', minutes)
		if seconds > 0 then
			result = result .. string.format(':%ds', seconds)
		end
	else
		result = string.format('%ds', seconds)
	end
	return result
end

function Number.maxBuy(c, b, r, k)
	local en = Number
	local max = en.div(math.log(en.add(en.div(en.mul(c , en.sub(r , 1)) , en.mul(b , en.pow(r,k))) , 1)) , en.log(r))
	local cost =  en.mul(b , en.div(en.mul(en.pow(r,k) , en.sub(en.pow(r,max) , 1)), en.sub(r , 1)))
	local nextCost = en.mul(b, en.pow(r,max))
	return max, cost, nextCost
end

return table.freeze(Number)
