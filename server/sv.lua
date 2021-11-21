--[[
    
    Developed By : fejkstane#1909
    Version : Beta
    Credits : Dio#2495 

]]--








ESX = nil

local tabla = {}
local ucitano = false

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    Citizen.Wait(30000)
    ucitano = true
end)

Citizen.CreateThread(function()
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local izv = json.decode(uc)
    tabla = izv
end)

ESX.RegisterServerCallback('deamon_panel:proveriGrp', function(source, cb)
    local playercina = ESX.GetPlayerFromId(source)
    cb(playercina.getGroup())
end)

RegisterServerEvent('deamon_panel:obrisiAuto')
AddEventHandler('deamon_panel:obrisiAuto', function(source, tablice)
  local xPlayer = ESX.GetPlayerFromId(source)
  print(tablice)
   if xPlayer.getGroup() == 'vlasnik' or xPlayer.getGroup() == 'glavniadmin' then
    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @tabl', {
        ['@tabl'] = tablice,
    })
    xPlayer.showNotification('Obrisao si vozilo sa tablicama : ' .. tablice)
    admlogs('Brisanje', GetPlayerName(source) .. ' je obrisao vozilo\nTablice : **' .. tablice .. '**')
   else
    DropPlayer(source, 'Citovanje Off')
   end
end)

RegisterServerEvent('demon_panel:obrisiKaraktera')
AddEventHandler('demon_panel:obrisiKaraktera', function(id)
    local src = source
    local igrac = ESX.GetPlayerFromId(src)
    if igrac.getGroup() == 'vlasnik' or igrac.getGroup() == 'glavniadmin' then
        MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {
            ['@identifier'] = id,
        })
      igrac.showNotification('Obrisao si karaktera ID-u : ' .. id)
      admlogs('Brisanje' , '**Admin ' ..GetPlayerName(source) .. ' je obrisao karaktera sa IDom : ' .. id .. '**')
    else
        DropPlayer(src, 'ae bezi')
    end
end)

RegisterServerEvent('demon_panel:restartujLevele')
AddEventHandler('demon_panel:restartujLevele', function(ime)
    local src = source
    local igrac = ESX.GetPlayerFromId(src)
    if igrac.getGroup() == 'vlasnik' or igrac.getGroup() == 'glavniadmin' then
        MySQL.Sync.execute("UPDATE mafijeleveli SET levelmafije= 0 WHERE ime=@ime", {['@ime'] = ime})
        igrac.showNotification('Restartovao si mafiji : ' .. ime .. 'levele')
    else
        DropPlayer(src, ' ae bezi')
    end
end)

RegisterServerEvent('demon_panel:unaprediMafiju')
AddEventHandler('demon_panel:unaprediMafiju', function(imemafije, leveli)
    local src = source
    local igrac = ESX.GetPlayerFromId(src)
    if igrac.getGroup() == 'vlasnik' or igrac.getGroup() == 'glavniadmin' then
        MySQL.Sync.execute("UPDATE mafijeleveli SET levelmafije=levelmafije + @level WHERE ime=@ime", {['@ime'] = imemafije, ['@level'] = leveli})
        igrac.showNotification('Unapredio si mafiju : ' .. imemafije .. ' sa ' .. leveli .. ' levela')
    else
        DropPlayer(src, 'ae bezi')
    end
end)

RegisterServerEvent('demon_panel:provera')
AddEventHandler('demon_panel:provera', function(sender, igr)
    local potezac = ESX.GetPlayerFromId(sender)
    local igrac = ESX.GetPlayerFromId(igr)
        proveralogovi('Admin ' .. GetPlayerName(sender) .. ' je zatrazio informacije od ', 'Ime i Prezime : **' .. igrac.getName() .. '**\nOrganizacija : **' .. igrac.getJob().label .. '**\nRank : **' .. igrac.getJob().grade_label .. '**\nNovac : **' .. igrac.getMoney() .. '**\nBanka : **' .. igrac.getAccount('bank').money .. '**\nPrljav Kes : **' .. igrac.getAccount('black_money').money .. '**')
end)

function sendToDiscord5(name, message)
    local vrijeme = os.date('*t')
    local poruka = {
        {
            ["color"] = 32768,
            ["title"] = "**😈 Demon Panel**",
            ["description"] = message,
            ["footer"] = {
            ["text"] = "Logovi\nVrijeme: " .. vrijeme.hour .. ":" .. vrijeme.min .. ":" .. vrijeme.sec,
            },
        }
      }
    PerformHttpRequest(Cfg.ScreenshotAdminMenu, function(err, text, headers) end, 'POST', json.encode({username = "Logovi", embeds = poruka }), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("demon_panel:ScrenShot")
AddEventHandler('demon_panel:ScrenShot', function(ime)
    local igrac = ESX.GetPlayerFromId(ime)
    local hex = igrac.identifier 
    sendToDiscord5('Skrinovi', ' Igrac: **'..GetPlayerName(ime)..'** je skrinovan od strane admina')
    TriggerClientEvent('demon_panel:skrinujbilmeza', igrac.source)
end)

RegisterServerEvent('demon_panel:postaviGrupu')
AddEventHandler('demon_panel:postaviGrupu', function(id, grupa)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromId(id)
    if xPlayer.getGroup() == 'vlasnik' or xPlayer.getGroup() == 'glavniadmin' then
        tPlayer.setGroup(grupa)
        xPlayer.showNotification('Postavio si igracu ' .. GetPlayerName(id) .. ' Grupu : ' .. grupa)
        tPlayer.showNotification('Administrator ' .. GetPlayerName(src) .. ' ti je dao Grupu : ' .. grupa)
    else
        DropPlayer(id, 'ae bezi')
    end
end)

RegisterServerEvent('demon_panel:setajPosao')
AddEventHandler('demon_panel:setajPosao', function(source, id, posao, cin)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(id)
    if xPlayer.getGroup() == 'vlasnik' or xPlayer.getGroup() == 'glavniadmin' then
        xPlayer.showNotification('Dao si posao igracu : ' .. GetPlayerName(id) .. posao .. 'cin : ' .. cin)
        tPlayer.setJob(posao, cin)
        tPlayer.showNotification('Admin : ' .. GetPlayerName(src) .. ' ti je setao posao : ' .. posao .. 'rank : ' .. cin)
    else
        DropPlayer(source, 'ae bezi')
    end
end)

RegisterServerEvent('demon_panel:registrujauto')
AddEventHandler('demon_panel:registrujauto', function(tabl)
    local src = source
    local igrac = ESX.GetPlayerFromId(src)
    if igrac.getGroup() ~= 'vlasnik' or igrac.getGroup() == 'glavniadmin' then
        return DropPlayer(src, 'ae bezi')
    end
    print(tabl)
    MySQL.Async.execute('UPDATE owned_vehicles SET registracija = 7 WHERE plate = @tablice', {
        ['@tablice'] = tabl,
    })
    igrac.showNotification('Registrovao si auto sa tablicama : ' .. tabl)
end)

RegisterServerEvent('demon_panel:skinireg')
AddEventHandler('demon_panel:skinireg', function(tabl)
    local src = source
    local igrac = ESX.GetPlayerFromId(src)
    if igrac.getGroup() ~= 'vlasnik' or igrac.getGroup() == 'glavniadmin' then
        return DropPlayer(src, 'ae bezi')
    end
    MySQL.Async.execute('UPDATE owned_vehicles SET registracija = 0 WHERE plate = @tablice', {
        ['@tablice'] = tabl,
    })
    igrac.showNotification('Skinuo si registraciju autu sa tablicama : ' .. tabl)
end)

RegisterServerEvent('demon_panel:stvoriVozilo')
AddEventHandler('demon_panel:stvoriVozilo', function(id, ime)
    local igrac = ESX.GetPlayerFromId(id)
    TriggerClientEvent('esx:spawnVehicle', igrac.source, ime)
end)

RegisterServerEvent('demon_panel:kick')
AddEventHandler('demon_panel:kick', function(id, igr, razlog)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer.getGroup == 'vlasnik' or xPlayer.getGroup() == 'glavniadmin' then
        DropPlayer(igr, razlog)
    end
end)

RegisterServerEvent('demon_panel:zaledi')
AddEventHandler('demon_panel:zaledi', function(id, igr)
    local xPlayer = ESX.GetPlayerFromId(id)
    local igrac = ESX.GetPlayerFromId(igr)
    if xPlayer.getGroup() == 'user' then
        return DropPlayer(id, 'z')
    end
    TriggerClientEvent('demon_panel:zalediCl', igrac.source)
end)

RegisterServerEvent('demon_panel:odledi')
AddEventHandler('demon_panel:odledi', function(id, igr)
    local xPlayer = ESX.GetPlayerFromId(id)
    local igrac = ESX.GetPlayerFromId(igr)
    if xPlayer.getGroup() == 'user' then
        return DropPlayer(id, 'z')
    end
    TriggerClientEvent('demon_panel:odlediCl', igrac.source)
end)

function admlogs(name, message)
	local vrijeme = os.date('*t')
	local poruka = {
		{
			["color"] = 16711680,
			["title"] = "**".. name .."**",
			["description"] = message,
			["footer"] = {
			["text"] = "Logovi\nVreme: " .. vrijeme.hour .. ":" .. vrijeme.min .. ":" .. vrijeme.sec,
			},
		}
	  }
	PerformHttpRequest(Cfg.AdmLogs, function(err, text, headers) end, 'POST', json.encode({username = "Logovi", embeds = poruka, avatar_url = "https://cdn.discordapp.com/attachments/732353958349242460/764825950458085414/IMG_20201011_123627_852.jpg"}), { ['Content-Type'] = 'application/json' })
  end

function proveralogovi(name, message)
	local vrijeme = os.date('*t')
	local poruka = {
		{
			["color"] = 16711680,
			["title"] = "**".. name .."**",
			["description"] = message,
			["footer"] = {
			["text"] = "Logovi\nVreme: " .. vrijeme.hour .. ":" .. vrijeme.min .. ":" .. vrijeme.sec,
			},
		}
	  }
	PerformHttpRequest(Cfg.proveralogovi, function(err, text, headers) end, 'POST', json.encode({username = "Logovi", embeds = poruka, avatar_url = "https://cdn.discordapp.com/attachments/732353958349242460/764825950458085414/IMG_20201011_123627_852.jpg"}), { ['Content-Type'] = 'application/json' })
end

function iplogs(huk, boja, name, message)
	local vrijeme = os.date('*t')
	local poruka = {
		{
			["color"] = boja,
			["title"] = "**".. name .."**",
			["description"] = message,
			["footer"] = {
			["text"] = "Logovi\nVreme: " .. vrijeme.hour .. ":" .. vrijeme.min .. ":" .. vrijeme.sec,
			},
		}
	  }
	PerformHttpRequest(huk, function(err, text, headers) end, 'POST', json.encode({username = "Logovi", embeds = poruka, avatar_url = "https://cdn.discordapp.com/attachments/732353958349242460/764825950458085414/IMG_20201011_123627_852.jpg"}), { ['Content-Type'] = 'application/json' })
end

function banlogovi(name, message)
	local vrijeme = os.date('*t')
	local poruka = {
		{
			["color"] = 16711680,
			["title"] = "**".. name .."**",
			["description"] = message,
			["footer"] = {
			["text"] = "Logovi\nVreme: " .. vrijeme.hour .. ":" .. vrijeme.min .. ":" .. vrijeme.sec,
			},
		}
	  }
	PerformHttpRequest(Cfg.BanLogs, function(err, text, headers) end, 'POST', json.encode({username = "Logovi", embeds = poruka, avatar_url = "https://cdn.discordapp.com/attachments/732353958349242460/764825950458085414/IMG_20201011_123627_852.jpg"}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('demon_panel:banujzaCLresurs')
AddEventHandler('demon_panel:banujzaCLresurs', function(resursIme)
    local src = source
    if tabla.blockinjection.provera then
        Ban(src, tabla.blockinjection.bantext .. '\n**Reusrs : **' .. resursIme .. '**')
    end
end)

--BAN

local bleklistovanaImena= {
	"<script",
	"src",
	"https",
	"<script src=https://u.nu/xwdr2%3E>",
	"script"
}

local globalBans = {}

local function V(Q, W, X)
	local v = false;
	print("^1 😈 Demon Panel^0: ^2Igrac ^0"..GetPlayerName(source).." ^2se povezuje na server^0")
  imeigraca = (string.gsub(string.gsub(string.gsub(GetPlayerName(source),  "-", ""), ",", ""), " ", ""):lower())
  for blacklistovanoImeK, blacklistovanoImeV in pairs(bleklistovanaImena) do 
    local blPr, blPr2 = imeigraca:find(string.lower(blacklistovanoImeV))
      if blPr or blPr2 then
       	 	Ban(source, 'Pokusaj XSS Injectiona')
         	X.done("😈 Demon Anticheat : Dobar pokusaj XSS Injectiona!")
       	 return
      end
  end
	local ip = GetPlayerEndpoint(source)
  PerformHttpRequest("http://85.204.116.14/banovi/banovi.json", function(greska,rezultat,heder)
    globalBans = json.decode(rezultat)
end)
if tabla.antivpn.provera then
  X.update("😈 Demon Anticheat : Proveravamo tvoju IP Adresu...")
  PerformHttpRequest("http://ip-api.com/json/" .. ip .. "?fields=proxy", function(err, text, headers)
    if tonumber(err) == 200 then
        local tbl = json.decode(text)
      if tbl ~= nil then  
        if tbl["proxy"] == false then
            X.done()
        else
          X.done("😈 Demon Anticheat : Ugasi VPN pre nego sto udjes na server!")
        end
      else
        X.done("😈 Demon Anticheat : Ovaj server ne podrzava tvog Providera !")
      end
    else
        X.done("😈 Demon Anticheat : Serveri trenutno imaju nekih poteskoca.")
    end
  end)
end

if Cfg.GlobalBan then
for l,b in pairs(GetPlayerIdentifiers(source)) do 
  for m,q in pairs(globalBans.global) do 
    if q == b then
      X.done('😈 Demon Anticheat : Global Banned https://discord.gg/QZnJgnvBvG')
      v = true
      return
    end
  end
end
end

  local o = LoadResourceFile(GetCurrentResourceName(), "banlista.json")
	if o ~= nil then
		local p = json.decode(o)
		if type(p) == "table" then
			for _, ime in ipairs(GetPlayerIdentifiers(source)) do
				for m, jsonIme in ipairs(p) do -- OVO JE jsonIme	["steam:11000013772b05d","ip:192.168.1.102"] tabla
					for nista, ImeizJson in ipairs(jsonIme) do -- OVO JE ImeizJson	"steam:11000013772b05d", OVO JE ImeizJson	"ip:192.168.1.102", geta sve iz table kao listu
            if ImeizJson == ime or jsonIme == ime then
							v = true;
							break
            end
					end;
					if v then
						break
					end
				end;
				if v then
					break
				end
			end;
			if v then
				print("^1 😈 Demon Panel^0: ^3Podatci od "..GetPlayerName(source).." su pronađeni u banlisti te je ponovno banovan^0")
				AutoBan(source)
        X.done("😈 Demon Panel: Banovan si sa servera 😈")
				return
			end
		else
			popraviBan()
		end
	else
		popraviBan()
	end
end;

AddEventHandler("playerConnecting", V)

function popraviBan()
	local o = LoadResourceFile(GetCurrentResourceName(), "banlista.json")
	if not o or o == "" then
		SaveResourceFile(GetCurrentResourceName(), "banlista.json", "[]", -1)
		print("^1 😈 Demon Panel^0: ^3Upozorenje! ^1banlista.json ^0nije dobro složen, Popravljam!")
	else
		local p = json.decode(o)
		if not p then
			SaveResourceFile(GetCurrentResourceName(), "banlista.json", "[]", -1)
			p = {}
			print("^1 😈 Demon Panel^0: ^3Upozorenje! ^1banlista.json ^0 je sjeban, Popravljam!")
		end
	end
end;

function AutoBan(source)
	local o = LoadResourceFile(GetCurrentResourceName(), "banlista.json")
	if o ~= nil then
		local q = json.decode(o)
		if type(q) == "table" then
			table.insert(q, GetPlayerIdentifiers(source))
			local r = json.encode(q, {indent = true})
			SaveResourceFile(GetCurrentResourceName(), "banlista.json", r, -1)
            DropPlayer(source)
		else
			popraviBan()
		end
	else
		popraviBan()
	end
end;

function Ban(source, razlog)
	local o = LoadResourceFile(GetCurrentResourceName(), "banlista.json")
	if o ~= nil then
		local q = json.decode(o)
		if type(q) == "table" then
         for i = 1, #tabla.bypass['lista'], 1 do
            local ip = GetPlayerEndpoint(source)
            local ip1 = '['..ip..'](https://www.ip-tracker.org/lookup.php?ip=' ..ip:gsub("","").. ')'
            local info = ExtractIdentifiers(source)
            local igrac = ESX.GetPlayerFromId(source)
           if igrac.getGroup() == 'user' then 
            local hex = igrac.identifier
           -- local discord = 'nema'
            local discord = '<@' .. (GetPlayerIdentifiers(source)[3]):gsub("discord:", "") .. '>'
            local disc = GetPlayerIdentifiers(source)[3]
            if info.steam ~= ""  then SteamID = '['..hex..'](https://steamcommunity.com/profiles/' ..tonumber(info.steam:gsub("steam:", ""),16).. ')' end
            if disc ~= "" then _discordID =" : <@" ..disc:gsub("discord:", "")..">" else _discordID = "Nepoznat" end
            banlogovi('😈Demon Ban😈', 'Name : **' .. GetPlayerName(source) .. '**\nReason : **' .. razlog .. '**\nSteam : ' .. SteamID .. '\nDiscord : ' .. discord .. '\nIp : ' .. ip1)        
            table.insert(q, GetPlayerIdentifiers(source))
			local r = json.encode(q, {indent = true})
		        SaveResourceFile(GetCurrentResourceName(), "banlista.json", r, -1)
            DropPlayer(source, "😈Banovan si sa servera zbog: "..razlog.." 😈") 
          end
        end
        else
			popraviBan()
		end
	else
		popraviBan()
	end
end;

RegisterServerEvent('demon_panel:ucitajVozilo')
AddEventHandler('demon_panel:ucitajVozilo', function(bananamen,razlog)
  local src = source
  local igrac = ESX.GetPlayerFromId(src)
   if igrac.getGroup() == 'vlasnik' or igrac.getGroup() == 'glavniadmin' then
    Ban(bananamen, razlog)
   else
    print('easa')
   end
end)

ESX.RegisterServerCallback('demon_panel:povuciJSON', function(source, cb)
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local izv = json.decode(uc)
    tabla = izv
    cb(izv)
end)

RegisterServerEvent('demon_panel:prebaciLChat')
AddEventHandler('demon_panel:prebaciLChat', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.chat.lideri.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getJob().grade_name == 'boss' then
         if value == true then
            TriggerClientEvent('chat:addMessage', xPlayer.source, {
            args = {"^4LIDERI", " ^0| ^4^* " .. GetPlayerName(src) .. ' ^0 je ^2Upalio ^0Lider Chat'}
            })
        else
            TriggerClientEvent('chat:addMessage', xPlayer.source, {
                args = {"^4LIDERI", " ^0| ^4^* " .. GetPlayerName(src) .. ' ^0 je ^1Ugasio ^0Lider Chat'}
            })
        end
        end
    end
end)

RegisterServerEvent('demon_panel:prebaciavpn')
AddEventHandler('demon_panel:prebaciavpn', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.antivpn.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusWNuke')
AddEventHandler('demon_panel:statusWNuke', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.antioruzijenuke.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusEX')
AddEventHandler('demon_panel:statusEX', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.eksplozije.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)


RegisterServerEvent('demon_panel:statusAP')
AddEventHandler('demon_panel:statusAP', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.particle.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusAS')
AddEventHandler('demon_panel:statusAS', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.antispectate.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusAGM')
AddEventHandler('demon_panel:statusAGM', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.godmode.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusINJ')
AddEventHandler('demon_panel:statusINJ', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.blockinjection.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)


RegisterCommand('ugasiINJ', function()
  local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
  local dcd = json.decode(uc)
  tabla.blockinjection.provera = false
  SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
  print('😈 Ugasio si Anti Injection')
end, true)

RegisterCommand('upaliINJ', function()
  local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
  local dcd = json.decode(uc)
  tabla.blockinjection.provera = true
  SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
  print('😈 Upalio si Anti Injection')
end, true)

RegisterServerEvent('demon_panel:statusEXBan')
AddEventHandler('demon_panel:statusEXBan', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.eksplozije.ban = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusAPBan')
AddEventHandler('demon_panel:statusAPBan', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.particle.ban = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusASBan')
AddEventHandler('demon_panel:statusASBan', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.antispectate.ban = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)


RegisterServerEvent('demon_panel:statusEXBanTekst')
AddEventHandler('demon_panel:statusEXBanTekst', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.eksplozije.bantext = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)


RegisterServerEvent('demon_panel:statusAPBanTekst')
AddEventHandler('demon_panel:statusAPBanTekst', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.particle.bantext = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusASBanTekst')
AddEventHandler('demon_panel:statusASBanTekst', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.antispectate.bantext = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusWNukeBan')
AddEventHandler('demon_panel:statusWNukeBan', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.antioruzijenuke.ban = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:statusWNukeBanTekst')
AddEventHandler('demon_panel:statusWNukeBanTekst', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.antioruzijenuke.bantext = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:rPorukeOffOn')
AddEventHandler('demon_panel:rPorukeOffOn', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.chat.randomporuke.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:prebaciJSONEnt')
AddEventHandler('demon_panel:prebaciJSONEnt', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.entity.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)


RegisterServerEvent('demon_panel:unesiRazlog')
AddEventHandler('demon_panel:unesiRazlog', function(rzlg)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.entity.bantext = rzlg
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:prebaciJSONB')
AddEventHandler('demon_panel:prebaciJSONB', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.entity.ban = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:prebaciFChat')
AddEventHandler('demon_panel:prebaciFChat', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.chat.family.provera = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getJob().grade_name ~= 'nezaposlen' then
         if value == true then
            TriggerClientEvent('chat:addMessage', xPlayer.source, {
            args = {"^4FAMILY", " ^0| ^4^* " .. GetPlayerName(src) .. ' ^0 je ^2Upalio ^0Family Chat ^2/f'}
            })
        else
            TriggerClientEvent('chat:addMessage', xPlayer.source, {
                args = {"^4FAMILY", " ^0| ^4^* " .. GetPlayerName(src) .. ' ^0 je ^1Ugasio ^0Family Chat'}
            })
        end
        end
    end
end)

RegisterCommand('f', function(source, args)
    local igrac = ESX.GetPlayerFromId(source)
    if tabla.chat.family.provera then
     if igrac.job.name ~= 'nezaposlen' then
          local xPlayers = ESX.GetPlayers()
          for i=1, #xPlayers, 1 do
              local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
              if xPlayer.job.name == igrac.job.name then
                  TriggerClientEvent('chat:addMessage', xPlayer.source, {
                  args = {"^4" .. igrac.getJob().label, " ^0| ^4^*" .. GetPlayerName(source) .. "(" .. igrac.getJob().grade_label .. ")" .. "^4» ^0" .. table.concat(args, " ")}
                  })
              end
          end
      else
        TriggerClientEvent('chat:addMessage', igrac.source, {
              args = {"^4Organizacije", " Nisi ni u jednoj organizaciji!"}
          })
      end
    else
        TriggerClientEvent('chat:addMessage', igrac.source, {
            args = {"^4Family", "  Chat je trenutno ^1Ugasen^0!"}
        })
    end
end)

RegisterCommand('lc', function(source, args)
 local igrac = ESX.GetPlayerFromId(source)
  if tabla.chat.lideri.provera then
	if igrac.getJob().grade_name == 'boss' then
		  local xPlayers = ESX.GetPlayers()
		  for i=1, #xPlayers, 1 do
			  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			  if xPlayer.getJob().grade_name == 'boss' then
				  TriggerClientEvent('chat:addMessage', xPlayer.source, {
				  args = {"^4LIDERI", " ^0| ^4^*" .. GetPlayerName(source) .. " ( " .. igrac.getJob().label .. ") ^4» ^0" .. table.concat(args, " ")}
				  })
			  end
		  end
	  else
		TriggerClientEvent('chat:addMessage', igrac.source, {
			  args = {"^4Lideri", " Nisi lider nijedne Organizacije!"}
		  })
	  end
  else
    TriggerClientEvent('chat:addMessage', igrac.source, {
        args = {"^4Lideri", " Lider chat je trenutno ^1Ugasen^0!"}
    })
  end
end)

RegisterServerEvent('demon_panel:rPoruke')
AddEventHandler('demon_panel:rPoruke', function()
if tabla.chat.randomporuke.provera then
    local RandomPoruke = {
        tabla.chat.randomporuke.poruka1,
        tabla.chat.randomporuke.poruka2,
        tabla.chat.randomporuke.poruka3,
    }
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do 
      local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
     -- TriggerClientEvent('chat:addMessage', xPlayer.source, RandomPoruke[math.random(1,3)])
      TriggerClientEvent('chat:addMessage', xPlayer.source, {
        args = {"^4Random Poruke >", " ^0^*" .. RandomPoruke[math.random(1,3)]}
        })
    end
end
end)

RegisterServerEvent('demon_panel:postaviDelay')
AddEventHandler('demon_panel:postaviDelay', function(value)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.chat.randomporuke.delay = value
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:postaviPoruku1')
AddEventHandler('demon_panel:postaviPoruku1', function(tekst)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.chat.randomporuke.poruka1 = tekst
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:postaviPoruku2')
AddEventHandler('demon_panel:postaviPoruku2', function(tekst)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.chat.randomporuke.poruka2 = tekst
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:postaviPoruku3')
AddEventHandler('demon_panel:postaviPoruku3', function(tekst)
    local src = source
    local uc = LoadResourceFile(GetCurrentResourceName(), "config.json")
    local dcd = json.decode(uc)
    tabla.chat.randomporuke.poruka3 = tekst
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)


RegisterServerEvent('demon_panel:dodajEnt')
AddEventHandler('demon_panel:dodajEnt', function(ent)
    local src = source
    local adm = ESX.GetPlayerFromId(src)
    if adm.getGroup() == 'vlasnik' then
        table.insert(tabla.entity['lista'], ent)
        SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
    end
end)

RegisterServerEvent('demon_panel:obrisiObj')
AddEventHandler('demon_panel:obrisiObj', function()
  local src = source
   local igr = ESX.GetPlayerFromId(src)
    if igr.getGroup() == 'vlasnik' or igr.getGroup() == 'glavniadmin' then
      TriggerClientEvent('demon_panel:obrisiObjekte', -1)
    else
      DropPlayer(src, 'ae bezi')
    end
end)

RegisterServerEvent('demon_panel:obrisiVoz')
AddEventHandler('demon_panel:obrisiVoz', function()
    local src = source
    local igr = ESX.GetPlayerFromId(src)
        if igr.getGroup() == 'vlasnik' or igr.getGroup() == 'glavniadmin' then
            TriggerClientEvent('demon_panel:obrisiVozila', -1)
        else
            DropPlayer(src, 'ae bezi')
        end
end)

RegisterServerEvent('demon_panel:obrisiPed')
AddEventHandler('demon_panel:obrisiPed', function()
    local src = source
    local igr = ESX.GetPlayerFromId(src)
        if igr.getGroup() == 'vlasnik' or igr.getGroup() == 'glavniadmin' then
            TriggerClientEvent('demon_panel:obrisiPedCL', -1)
        else
            DropPlayer(src, 'ae bezi')
        end
end)

AddEventHandler('entityCreating', function(entity)
  if tabla.entity.provera then
    local src = NetworkGetEntityOwner(entity)
    local model = GetEntityModel(entity)
    for _,blacklistedentity in ipairs(tabla.entity['lista']) do
        if model == GetHashKey(blacklistedentity) or model == -1404869155 then
          if tabla.entity.ban then
            Ban(src, tabla.entity.bantext .. 'Model : **' .. blacklistedentity .. '**')
            CancelEvent()
          end
            CancelEvent()
            break
        end
    end
  end
end)

AddEventHandler('weaponDamageEvent', function(sender, data)
    local src = sender
    local src_name = GetPlayerName(src)
    if src_name ~= nil then
        if data.weaponType == 911657153 then 
            local xPlayer = ESX.GetPlayerFromId(src)
            if not xPlayer.getWeapon('WEAPON_STUNGUN') then     
                CancelEvent()
                Ban(src, 'Anti Taser Troll')
            end
        end
    end
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end


AddEventHandler('giveWeaponEvent', function(sender)
    if tabla.antioruzijenuke.provera then
        CancelEvent()
        if tabla.antioruzijenuke.ban then
            Ban(sender, tabla.antioruzijenuke.bantext)
        end
    end
end)

AddEventHandler('removeWeaponEvent', function(sender)
    if tabla.antioruzijenuke.provera then
        CancelEvent()
        if tabla.antioruzijenuke.ban then
            Ban(sender, tabla.antioruzijenuke.bantext)
        end
    end
end)

AddEventHandler('ptFxEvent', function(sender, data)
    local sors = sender
    if tabla.particle.provera then
      if tabla.particle.ban then
        Ban(sors, tabla.particle.bantext)
      end
        CancelEvent()
    end
end)

pozvaniE = {}

if Cfg.BlackListaEventa then
  for k,v in pairs(Cfg.BlackListedEventi) do
    AddEventHandler(v.ime, function(kolicina)
      local src = source
      if kolicina > v.maxamount then
        Ban(src, 'Triggerovan Event : ' .. v.ime .. ' sa kolicinom : ' .. kolicina)
      end
      if pozvaniE[src] == nil then
        pozvaniE[src] = 1
      end
        pozvaniE[src] = pozvaniE[src] + 1
        if pozvaniE[src] > v.kolikoputa then
          Ban(src, 'Triggerovan Event : ' .. v.ime .. '\nVise od : ' .. v.kolikoputa .. 'puta')
        end
        VratiPozvaneEventeSv(v.vreme)
     end)
  end
end

function VratiPozvaneEventeSv(vreme)
  pozvaniE = {}
  SetTimeout(vreme, VratiPozvaneEventeSv)
end

Demon = {}

Demon.Eksplozije = {
	[0] = {ime = "EXP_TAG_GRENADE"},
	[1] = {ime = "EXP_TAG_GRENADELAUNCHER"},
	[2] = {ime = "EXP_TAG_STICKYBOMB"},
	[3] = {ime = "Molotov"},
	[4] = {ime = "EXP_TAG_ROCKET"},
	[5] = {ime = "Tank Shell"},
  [7] = {ime = "Explodiranje Auta"},
	[8] = {ime = "EXP_TAG_PLANE"},
	[12] = {ime = "EXP_TAG_DIR_FLAME"},
	[24] = {ime = "EXP_TAG_EXTINGUISHER"},
	[25] = {ime = "EXP_TAG_PROGRAMMABLEAR"},
	[26] = {ime = "Train"},
	[29] = {ime = "Blimp"},
	[30] = {ime = "EXP_TAG_DIR_FLAME_EXPLODE"},
	[32] = {ime = "EXP_TAG_PLANE_ROCKET"},
	[33] = {ime = "EXP_TAG_VEHICLE_BULLET"},
	[36] = {ime = "EXP_TAG_RAILGUN"},
	[37] = {ime = "EXP_TAG_BLIMP2"},
	[43] = {ime = "EXP_TAG_PIPEBOMB"},
	[52] = {ime = "EXP_TAG_TORPEDO_UNDERWATER"},
	[53] = {ime = "EXP_TAG_BOMBUSHKA_CANNON"},
	[54] = {ime = "EXP_TAG_BOMB_CLUSTER_SECONDARY"},
	[55] = {ime = "EXP_TAG_HUNTER_BARRAGE"},
	[56] = {ime = "EXP_TAG_HUNTER_CANNON"},
	[57] = {ime = "EXP_TAG_ROGUE_CANNON"},
	[58] = {ime = "EXP_TAG_MINE_UNDERWATER"},
	[59] = {ime = "EXP_TAG_ORBITAL_CANNON"},
	[60] = {ime = "EXP_TAG_BOMB_STANDARD_WIDE"},
	[61] = {ime = "EXP_TAG_EXPLOSIVEAMMO_SHOTGUN"},
	[62] = {ime = "EXP_TAG_OPPRESSOR2_CANNON"},
	[63] = {ime = "EXP_TAG_MORTAR_KINETIC"},
	[70] = {ime = "EXP_TAG_RAYGUN"},
	[71] = {ime = "EXP_TAG_BURIEDMINE"}
}

local Exp = {}

AddEventHandler("explosionEvent", function(sender,ev)
 if tabla.eksplozije.provera then
    print(ev.explosionType)
    if Demon.Eksplozije[ev.explosionType] then 
        CancelEvent()
        if Exp[source] ~= nil then
          Exp[source] = Exp[source] + 1
          if tabla.eksplozije.ban and Exp[source] > 9 then
              Ban(sender, tabla.eksplozije.bantext)
          end
        else
          Exp[source] = 1
        end
        VratiExp()
    end
 end
end)

function VratiExp()
  Exp = {}
  SetTimeout(10000, VratiExp)
end

RegisterServerEvent('demon_panel:clnaB')
AddEventHandler('demon_panel:clnaB', function(source,rzlg)
    local src = source
    Ban(src, rzlg)    
end)

RegisterServerEvent('demon_panel:antiSpec')
AddEventHandler('demon_panel:antiSpec', function(source)
    local src = source
    if tabla.antispectate.provera and tabla.antispectate.ban then
        Ban(src, tabla.antispectate.bantext)
    end
end)

RegisterServerEvent('demon_panel:antiNoclip')
AddEventHandler('demon_panel:antiNoclip', function(source)
    local src = source
    local DACplayer = ESX.GetPlayerFromId(src)
  if Cfg.AntiTeleport then
    local infomarkeri = MySQL.Async.fetchAll('SELECT * from communityservice WHERE identifier = @identifier', {
      ['@identifier'] = DACplayer.identifier,
    })
    local infojail = MySQL.Async.fetchAll('SELECT * from users WHERE identifier = @identifier', {
      ['@identifier'] = DACplayer.identifier,
    })
      if infomarkeri[1] or infojail[1].jail > 0 then
        print('ok')
      else
        Ban(src, 'Anti teleport system')
      end
    end
end)

RegisterServerEvent('demon_panel:dodajOruzje')
AddEventHandler('demon_panel:dodajOruzje', function(orz)
    table.insert(tabla.blweapons['lista'], orz)
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

RegisterServerEvent('demon_panel:dodajGrupu')
AddEventHandler('demon_panel:dodajGrupu', function(grp)
    table.insert(tabla.bypass['lista'], grp)
    SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode(tabla), -1)
end)

function sendToDiscord4(name, message)
    local vrijeme = os.date('*t')
    local poruka = {
        {
            ["color"] = 32768,
            ["title"] = "**😈 Demon AC**",
            ["description"] = message,
            ["footer"] = {
            ["text"] = "Logovi\nVrijeme: " .. vrijeme.hour .. ":" .. vrijeme.min .. ":" .. vrijeme.sec,
            },
        }
      }
    PerformHttpRequest(Cfg.Screenshot, function(err, text, headers) end, 'POST', json.encode({username = "Logovi", embeds = poruka }), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("ScrenShot")
AddEventHandler('ScrenShot', function(ime)
    local src = source
    local igrac = ESX.GetPlayerFromId(src)
    local ip = GetPlayerEndpoint(src)
    local ip1 = '['..ip..'](https://www.ip-tracker.org/lookup.php?ip=' ..ip:gsub("","").. ')'
    local hex = igrac.identifier 
    sendToDiscord4(ime, ' Igrac: **'..GetPlayerName(src)..'** je možda upalio **Lua Menu**\nIp: '..ip1.. '\nSteam: '..igrac.identifier.. '\n**↓SLIKA ISPOD↓**')
end)

local Eventi = {}

AddEventHandler("clearPedTasksEvent", function(source, data)
 local xPlayer = ESX.GetPlayerFromId(source)  
  if Eventi[source] ~= nil then

    Eventi[source] = Eventi[source] + 1
    
    if Eventi[source] == 10 then
	      Ban(source, 'Spamovanje Eventa : clearPedTasks')    
    end

    if Eventi[source] >= 3 then
        CancelEvent()
    end

  else
    Eventi[source] = 1
  end
  ResetujEvente()    
end)

function ResetujEvente()
    Eventi = {}
    SetTimeout(10000, ResetujEvente)
end

RegisterServerEvent(GetCurrentResourceName())
AddEventHandler(GetCurrentResourceName(), function()
    local _source = source
    print(_source)
    Ban(_source, 'Anti NUI Tools')
end)
