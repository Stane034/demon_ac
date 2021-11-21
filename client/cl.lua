--[[
    
    Developed By : fejkstane#1909
    Version : Beta
    Credits : Dio#2495 

]]--


ESX = nil
local nevidljivost = false
local zaledjen = false
local prvostartac = true
local firstSpawnAC = true
local isDead, hasWarned, hasSpawned = false, false, false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end
end)
--DEBAG
   
--DEBAG


function otvoriMeni()
ESX.TriggerServerCallback('deamon_panel:proveriGrp', function(grp)

    local elementi = {
       -- {label = 'Server Podesavanja | ⚙️', value = 'svpod'},
        {label = 'Admin Opcije | 🛡️', value = 'admop'},
      }
        ESX.UI.Menu.CloseAll()
      if grp == 'vlasnik' or grp == 'glavniadmin' then
        table.insert(elementi, {label = 'Server Podesavanja | ⚙️', value = 'svpod'})
        table.insert(elementi, {label = 'Head Staff Opcije | 🔰', value = 'headstaff'})
      end
        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'admin_meni',
        {
          css      = 'meni',
          title    = '⚙️ Server Menu ⚙️',
          align    = 'top-left',
          elements = elementi
        },
          
          function(data, menu)
      
            if data.current.value == 'svpod' then
                OtvoriSvPod()
            elseif data.current.value == 'admop' then
                OtvoriAdminOpcije()
            elseif data.current.value == 'headstaff' then
                OtvoriMeniHeada()
            end
        end,
        function(data, menu)
          menu.close()
        end
      )
    end)
end


function OtvoriSvPod()
  
      local elementi = {
          {label = 'Chatovi | ⚙️', value = 'chatovi'},
          {label = 'Blacklista Entitya | ⚙️',value = 'entities'},
          {label = 'Entity Menu | ⚙️', value = 'entitiesmenu'},
          {label = 'Anti Weapon Nuke | ⚙️', value = 'antiwnuke'},
          {label = 'Anti Eksplozije | ⚙️', value = 'antiexplosions'},
          {label = 'Anti Injection | ⚙️', value = 'antiinjection'},
          {label = 'Anti Particle Eventi | ⚙️', value = 'particleevents'},
          {label = 'Anti God Mode | ⚙️', value = 'antigodmod'},
          {label = 'Blacklisted Oruzije | ⚙️', value = 'blacklistedw'},
          {label = 'Anti Spectate | ⚙️', value = 'antispec'},
          {label = 'Anti VPN | ⚙️', value = 'antivpn'},
          {label = 'Bypass Menu | ⚙️', value = 'bypassmenu'},

        }
          ESX.UI.Menu.CloseAll()

          ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'admin_meni',
          {
            css      = 'meni',
            title    = '⚙️ Server Podesavanja ⚙️',
            align    = 'top-left',
            elements = elementi
          },
            
            function(data, menu)
        
              if data.current.value == 'chatovi' then
                  OtvoriMenuChatovi()
              elseif data.current.value == 'entities' then
                OtvoriMeniEntitija()
              elseif data.current.value == 'entitiesmenu' then
                OtvoriEntityMeni()
              elseif data.current.value == 'antiwnuke' then
                OtvoriAntiWNukeMenu()
              elseif data.current.value == 'antiexplosions' then
                OtvoriAntiExplosionMenu()
              elseif data.current.value == 'antiinjection' then
                OtvoriMeniInjectiona()
              elseif data.current.value == 'particleevents' then
                OtvoriMeniParticleEventa()
              elseif data.current.value == 'antigodmod' then
                OtvoriAntiGodMod()
              elseif data.current.value == 'blacklistedw' then
                OtvoriBlackListed()
              elseif data.current.value == 'antispec' then
                OtvoriAntiSpec()
              elseif data.current.value == 'antivpn' then
                OtvoriAntiVPN()
              elseif data.current.value == 'bypassmenu' then
                OtvoriBypassMenu()
              end
          end,
          function(data, menu)
            menu.close()
          end
        )
  end

  function OtvoriAntiVPN()
    ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
      local elementi = {
        }
        if dzson.antivpn.provera then
          table.insert(elementi, {label = 'Anti VPN > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'avpn'})
        else
          table.insert(elementi, {label = 'Anti VPN > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'avpn'})
        end 
        
        ESX.UI.Menu.CloseAll()
          ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'admin_meni',
          {
            css      = 'meni',
            title    = '⚙️ VPN Menu ⚙️',
            align    = 'top-left',
            elements = elementi
          },
            
            function(data, menu)
              if data.current.value == 'avpn' then
                if tabela.antivpn.provera then
                  TriggerServerEvent('demon_panel:prebaciavpn', false)
                  ESX.ShowNotification('Ugasio si Anti VPN')
                 else
                  TriggerServerEvent('demon_panel:prebaciavpn', true)
                  ESX.ShowNotification('Upalio si Anti VPN')
                 end
              end
            end,
          function(data, menu)
            menu.close()
          end
        )
      end)
  end

  function OtvoriBypassMenu()
    ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
      local elementi = {
        {label = 'Dodaj Grupu | ⚙️', value = 'dodajg'},
        {label = 'Grupe sa Bypassom | ⚙️', value = 'grups'},
        }
        for i = 1, #dzson.bypass['lista'], 1 do
        table.insert(elementi, {label = dzson.bypass['lista'][i], value = dzson.bypass['lista'][i]})
        ESX.UI.Menu.CloseAll()
          ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'admin_meni',
          {
            css      = 'meni',
            title    = '⚙️ Bypass Menu ⚙️',
            align    = 'top-left',
            elements = elementi
          },
            
            function(data, menu)
              if data.current.value == 'dodajg' then
                local upis = UnosTastatura("Unesi Grupu", '', 120)
                local upis2 = UnosTastatura("Da li si siguran da zelis da dodas " .. upis .. "kao Bypass Grupu", 'DA/NE', 120)
                if upis2 == 'DA' then
                  TriggerServerEvent('demon_panel:dodajGrupu', upis)
                  ESX.ShowNotification('Dodao si grupu ' .. upis .. ' u Bypass')
                else
                  ESX.ShowNotification('Odustao si od dodavanja grupe u Bypass')
                end
               end
            end,
          function(data, menu)
            menu.close()
          end
        )
      end
      end)
  end

  function OtvoriBlackListed()
    ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
      local elementi = {
        {label = 'Dodaj Oruzije | ⚙️', value = 'dodajo'},
        }
        for i = 1, #dzson.blweapons['lista'], 1 do
        table.insert(elementi, {label = dzson.blweapons['lista'][i], value = dzson.blweapons['lista'][i]})
        ESX.UI.Menu.CloseAll()
          ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'admin_meni',
          {
            css      = 'meni',
            title    = '⚙️ Blacklisted Weapons ⚙️',
            align    = 'top-left',
            elements = elementi
          },
            
            function(data, menu)
              if data.current.value == 'dodajo' then
                local upis = UnosTastatura("Unesi Oruzje", '', 120)
                local upis2 = UnosTastatura("Da li si siguran da zelis da dodas " .. upis .. "kao BL weapon", 'DA/NE', 120)
                if upis2 == 'DA' then
                  TriggerServerEvent('demon_panel:dodajOruzje', upis)
                  ESX.ShowNotification('Dodao si oruzije ' .. upis .. ' na BL')
                else
                  ESX.ShowNotification('Odustao si od dodavanja oruzija na BL')
                end
               end
            end,
          function(data, menu)
            menu.close()
          end
        )
      end
      end)
  end


  function OtvoriAntiSpec()
    ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
      local elementi = {
        }
        if dzson.antispectate.provera then
          table.insert(elementi, {label = 'Anti Spec > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'asstatus'})
          if dzson.antispectate.ban then
            table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'asbanstatus'})
          else
            table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'asbanstatus'})
          end
            table.insert(elementi, {label = 'Ban Text | ⚙️', value = 'asbantxt'})
        else
          table.insert(elementi, {label = 'Anti Spec > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'asstatus'})
        end
        ESX.UI.Menu.CloseAll()
          ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'admin_meni',
          {
            css      = 'meni',
            title    = '⚙️ Anti Spectate Menu ⚙️',
            align    = 'top-left',
            elements = elementi
          },
            
            function(data, menu)
        
              if data.current.value == 'asstatus' then
                if dzson.antispectate.provera then
                  TriggerServerEvent('demon_panel:statusAS', false)
                  ESX.ShowNotification('Ugasio si Anti Spec')
                else
                  TriggerServerEvent('demon_panel:statusAS', true)
                  ESX.ShowNotification('Upalio si Anti Spec')
                end
              elseif data.current.value == 'asbanstatus' then
                if dzson.antispectate.ban then
                  TriggerServerEvent('demon_panel:statusASBan', false)
                  ESX.ShowNotification('Ugasio si Ban')
                else
                  TriggerServerEvent('demon_panel:statusASBan', true)
                  ESX.ShowNotification('Upalio si Ban')
                end
              elseif data.current.value == 'asbantxt' then
                local tekst = UnosTastatura('Upisi tekst', '', 120)
                TriggerServerEvent('demon_panel:statusASBanTekst', tekst)
              end          
          end,
          function(data, menu)
            menu.close()
          end
        )
      end)
  end

  function OtvoriAntiGodMod()
    ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
      local elementi = {
        }
        if dzson.godmode.provera then
          table.insert(elementi, {label = 'Anti Godmode > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'agmstatus'})
        else
          table.insert(elementi, {label = 'Anti Godmode > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'agmstatus'})
        end
        ESX.UI.Menu.CloseAll()
          ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'admin_meni',
          {
            css      = 'meni',
            title    = '⚙️ Anti Godmode Menu ⚙️',
            align    = 'top-left',
            elements = elementi
          },
            
            function(data, menu)
        
              if data.current.value == 'agmstatus' then
                if dzson.godmode.provera then
                  TriggerServerEvent('demon_panel:statusAGM', false)
                  ESX.ShowNotification('Ugasio si Anti Godmode')
                else
                  TriggerServerEvent('demon_panel:statusAGM', true)
                  ESX.ShowNotification('Upalio si Anti Godmode')
                end          
              end
          end,
          function(data, menu)
            menu.close()
          end
        )
      end)
  end

  function OtvoriMeniParticleEventa()
    ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
      local elementi = {
        }
        if dzson.particle.provera then
          table.insert(elementi, {label = 'Anti Particle > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'apstatus'})
          if dzson.particle.ban then
            table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'apbanstatus'})
          else
            table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'apbanstatus'})
          end
            table.insert(elementi, {label = 'Ban Text | ⚙️', value = 'apbantxt'})
        else
          table.insert(elementi, {label = 'Anti Particle > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'apstatus'})
        end
        ESX.UI.Menu.CloseAll()
          ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'admin_meni',
          {
            css      = 'meni',
            title    = '⚙️ Anti Particle Menu ⚙️',
            align    = 'top-left',
            elements = elementi
          },
            
            function(data, menu)
        
              if data.current.value == 'apstatus' then
                if dzson.particle.provera then
                  TriggerServerEvent('demon_panel:statusAP', false)
                  ESX.ShowNotification('Ugasio si Anti Particle')
                else
                  TriggerServerEvent('demon_panel:statusAP', true)
                  ESX.ShowNotification('Upalio si Anti Particle')
                end
              elseif data.current.value == 'apbanstatus' then
                if dzson.particle.ban then
                  TriggerServerEvent('demon_panel:statusAPBan', false)
                  ESX.ShowNotification('Ugasio si Ban')
                else
                  TriggerServerEvent('demon_panel:statusAPBan', true)
                  ESX.ShowNotification('Upalio si Ban')
                end
              elseif data.current.value == 'apbantxt' then
                local tekst = UnosTastatura('Upisi tekst', '', 120)
                TriggerServerEvent('demon_panel:statusAPBanTekst', tekst)
              end
          end,
          function(data, menu)
            menu.close()
          end
        )
      end)
  end

  function OtvoriMeniInjectiona()
    ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
    
        local elementi = {
          }
          if dzson.blockinjection.provera then
            table.insert(elementi, {label = 'Anti Injection > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'injstatus'})
            if dzson.blockinjection.ban then
              table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'injbanstatus'})
            else
              table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'injbanstatus'})
            end
              table.insert(elementi, {label = 'Ban Text | ⚙️', value = 'exbantxt'})
          else
            table.insert(elementi, {label = 'Anti Injection > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'injstatus'})
          end
            ESX.UI.Menu.CloseAll()
       
            ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'admin_meni',
            {
              css      = 'meni',
              title    = '⚙️ Injection Menu ⚙️',
              align    = 'top-left',
              elements = elementi
            },
              
              function(data, menu)
          
                if data.current.value == 'injstatus' then
                  if dzson.blockinjection.provera then
                    TriggerServerEvent('demon_panel:statusINJ', false)
                    ESX.ShowNotification('Ugasio si Anti Injection')
                  else
                    TriggerServerEvent('demon_panel:statusINJ', true)
                    ESX.ShowNotification('Upalio si Anti Injection')
                  end
                end
            end,
            function(data, menu)
              menu.close()
            end
          )
        end)
    end

function OtvoriAntiExplosionMenu()
  ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
    local elementi = {
      }
      if dzson.eksplozije.provera then
        table.insert(elementi, {label = 'Eksplozije > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'exstatus'})
        if dzson.eksplozije.ban then
          table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'exbanstatus'})
        else
          table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'exbanstatus'})
        end
          table.insert(elementi, {label = 'Ban Text | ⚙️', value = 'exbantxt'})
      else
        table.insert(elementi, {label = 'Eksplozije > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'exstatus'})
      end
      ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'admin_meni',
        {
          css      = 'meni',
          title    = '⚙️ Anti Explosions Menu ⚙️',
          align    = 'top-left',
          elements = elementi
        },
          
          function(data, menu)
      
            if data.current.value == 'exstatus' then
              if dzson.eksplozije.provera then
                TriggerServerEvent('demon_panel:statusEX', false)
                ESX.ShowNotification('Ugasio si Anti Eksplozije')
              else
                TriggerServerEvent('demon_panel:statusEX', true)
                ESX.ShowNotification('Upalio si Anti Eksplozije')
              end
            elseif data.current.value == 'exbanstatus' then
              if dzson.eksplozije.ban then
                TriggerServerEvent('demon_panel:statusEXBan', false)
                ESX.ShowNotification('Ugasio si Ban')
              else
                TriggerServerEvent('demon_panel:statusEXBan', true)
                ESX.ShowNotification('Upalio si Ban')
              end
            elseif data.current.value == 'exbantxt' then
              local tekst = UnosTastatura('Upisi tekst', '', 120)
              TriggerServerEvent('demon_panel:statusEXBanTekst', tekst)
            end
        end,
        function(data, menu)
          menu.close()
        end
      )
    end)
end

function OtvoriAntiWNukeMenu()
  ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)    
    local elementi = {
      }
      if dzson.antioruzijenuke.provera then
        table.insert(elementi, {label = 'Weapon Nuke > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'wnstatus'})
        if dzson.antioruzijenuke.ban then
          table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'wnbanstatus'})
        else
          table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'wnbanstatus'})
        end
          table.insert(elementi, {label = 'Ban Text | ⚙️', value = 'bantxt'})
      else
        table.insert(elementi, {label = 'Weapon Nuke > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'wnstatus'})
      end
      ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'admin_meni',
        {
          css      = 'meni',
          title    = '⚙️ Anti Weapon Nuke Menu ⚙️',
          align    = 'top-left',
          elements = elementi
        },
          
          function(data, menu)
      
            if data.current.value == 'wnstatus' then
              if dzson.antioruzijenuke.provera then
                TriggerServerEvent('demon_panel:statusWNuke', false)
                ESX.ShowNotification('Ugasio si Anti Nuke')
              else
                TriggerServerEvent('demon_panel:statusWNuke', true)
                ESX.ShowNotification('Upalio si Anti Nuke')
              end
            elseif data.current.value == 'wnbanstatus' then
              if dzson.antioruzijenuke.ban then
                TriggerServerEvent('demon_panel:statusWNukeBan', false)
                ESX.ShowNotification('Ugasio si Ban')
              else
                TriggerServerEvent('demon_panel:statusWNukeBan', true)
                ESX.ShowNotification('Upalio si Ban')
              end
            elseif data.current.value == 'bantxt' then
              local tekst = UnosTastatura('Upisi tekst', '', 120)
              TriggerServerEvent('demon_panel:statusWNukeBanTekst', tekst)
            elseif data.current.value == 'deletepeds' then
              
            end
        end,
        function(data, menu)
          menu.close()
        end
      )
    end)
end


  function OtvoriEntityMeni()
    
        local elementi = {
          }
            ESX.UI.Menu.CloseAll()
            table.insert(elementi, {label = 'Obrisi Sve Entitye | ⚙️', value = 'deleteentities'})
            table.insert(elementi, {label = 'Obrisi Sva Vozila | ⚙️', value = 'deletevehicles'})
            table.insert(elementi, {label = 'Obrisi Sve Pedove | ⚙️', value = 'deletepeds'})
            ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'admin_meni',
            {
              css      = 'meni',
              title    = '⚙️ Entity Menu ⚙️',
              align    = 'top-left',
              elements = elementi
            },
              
              function(data, menu)
          
                if data.current.value == 'deleteentities' then
                  local upitnik = UnosTastatura('Jesi li siguran', 'DA/NE', 120)
                  if upitnik == 'DA' then
                    TriggerServerEvent('demon_panel:obrisiObj')
                    ESX.ShowNotification('Obrisao si sve Objekte na serveru')
                  else
                    ESX.ShowNotification('Odustao si od brisanja Entitya')
                  end
                elseif data.current.value == 'deletevehicles' then
                  local upitnik = UnosTastatura('Jesi li siguran?', 'DA/NE', 120)
                  if upitnik == 'DA' then
                    TriggerServerEvent('demon_panel:obrisiVoz')
                    ESX.ShowNotification('Obrisao si sva vozila na serveru')
                  else
                    ESX.ShowNotification('Odustao si od brisanja Vozila')
                  end
                elseif data.current.value == 'deletepeds' then
                local upitnik = UnosTastatura('Jesi li siguran?', 'DA/NE', 120)
                if upitnik == 'DA' then
                  TriggerServerEvent('demon_panel:obrisiPed')
                  ESX.ShowNotification('Obrisao si sve pedove na serveru')
                else
                  ESX.ShowNotification('Odustao si od brisanja Pedova')
                end  
                end
            end,
            function(data, menu)
              menu.close()
            end
          )
end
    
  
  function OtvoriMeniEntitija()
  ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)
    local elementi = {
      }
      if dzson.entity.provera then
        table.insert(elementi, {label = 'Entity Blacklist > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'prebacie'})
      else
        table.insert(elementi, {label = 'Entity Blacklist > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'prebacie'})
      end
      if dzson.entity.ban then
        table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'prebacib'})
      else
        table.insert(elementi, {label = 'Ban > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'prebacib'})
      end
      table.insert(elementi, {label = 'Ban Razlog | ⚙️', value = 'banrazlog'})
      table.insert(elementi, {label = 'Dodaj Entity | ⚙️', value = 'dodaje'})
    --  table.insert(elementi, {label = '⚙️ Lista Objekata ⚙️', value = 'lobj'})
      ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'admin_meni',
        {
          css      = 'meni',
          title    = '⚙️ Entiti ⚙️',
          align    = 'top-left',
          elements = elementi
        },
          
          function(data, menu)
      
            if data.current.value == 'dodaje' then
              local tekst = UnosTastatura('Ime Entitya', '', 120)
              TriggerServerEvent('demon_panel:dodajEnt', tekst)
            elseif data.current.value == 'prebacie' then
              if dzson.entity.provera then
                TriggerServerEvent('demon_panel:prebaciJSONEnt', false)
                ESX.ShowNotification('Ugasio si Entity Blacklist')
              else
                TriggerServerEvent('demon_panel:prebaciJSONEnt', true)
                ESX.ShowNotification('Upalio si Entity Blacklist')
              end
            elseif data.current.value == 'prebacib' then
              if dzson.entity.ban then
                TriggerServerEvent('demon_panel:prebaciJSONB', false)
                ESX.ShowNotification('Ugasio si Ban za Entity')
              else
                TriggerServerEvent('demon_panel:prebaciJSONB', true)
                ESX.ShowNotification('Upalio si Ban za Entity')
              end
            elseif data.current.value == 'banrazlog' then
              local tekst = UnosTastatura('Unesi tekst koji iskace banovanom igracu', '', 120)
              TriggerServerEvent('demon_panel:unesiRazlog', tekst)
            end
        end,
        function(data, menu)
          menu.close()
        end
      )
    
    end)
end

function OtvoriMenuChatovi()
 ESX.TriggerServerCallback('demon_panel:povuciJSON', function(tabela)
    local elementi = {
    }
    if tabela.chat.lideri.provera then
      table.insert(elementi, {label = 'Lider Chat > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'lchat'})
    else
      table.insert(elementi, {label = 'Lider Chat > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'lchat'})
    end 
    if tabela.chat.family.provera then
      table.insert(elementi, {label = 'Family Chat > ' .. ('<span style="color:green;">%s</span>'):format('Upaljen'), value = 'fchat'})
    else
      table.insert(elementi, {label = 'Family Chat > ' .. ('<span style="color:red;">%s</span>'):format('Ugasen'), value = 'fchat'})
    end 
      table.insert(elementi, {label = 'Random Poruke', value = 'rporuke'})
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'admin_meni',
        {
          css      = 'meni',
          title    = '⚙️ Chatovi ⚙️',
          align    = 'top-left',
          elements = elementi
        },
          
          function(data, menu)
      
            if data.current.value == 'lchat' then
                 if tabela.chat.lideri.provera then
                  TriggerServerEvent('demon_panel:prebaciLChat', false)
                  ESX.ShowNotification('Ugasio si Lider chat')
                 else
                  TriggerServerEvent('demon_panel:prebaciLChat', true)
                  ESX.ShowNotification('Upalio si Lider chat')
                 end
            elseif data.current.value == 'fchat' then
              if tabela.chat.family.provera then
                TriggerServerEvent('demon_panel:prebaciFChat', false)
                ESX.ShowNotification('Ugasio si Family chat')
               else
                TriggerServerEvent('demon_panel:prebaciFChat', true)
                ESX.ShowNotification('Upalio si Family chat')
               end
            elseif data.current.value == 'rporuke' then
              OtvoriMeniRandomPoruka()
            end
        end,
        function(data, menu)
          menu.close()
        end
      )
    end)
end


function OtvoriMeniRandomPoruka()
 ESX.TriggerServerCallback('demon_panel:povuciJSON', function(dzson)
  local elementi = {
    }
    if dzson.chat.randomporuke.provera then
      table.insert(elementi, {label = 'Random Poruke > ' .. ('<span style="color:green;">%s</span>'):format('Upaljene'), value = 'rporuke'})
      table.insert(elementi, {label = 'Delay | 💬', value = 'delay'})
      table.insert(elementi, {label = 'Poruka 1 | 💬', value = 'p1'})
      table.insert(elementi, {label = 'Poruka 2 | 💬', value = 'p2'})
      table.insert(elementi, {label = 'Poruka 3 | 💬', value = 'p3'})
    else
      table.insert(elementi, {label = 'Random Poruke > ' .. ('<span style="color:red;">%s</span>'):format('Ugasene'), value = 'rporuke'})
    end 
      ESX.UI.Menu.CloseAll()

      ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'admin_meni',
      {
        css      = 'meni',
        title    = '⚙️ Random Poruke ⚙️',
        align    = 'top-left',
        elements = elementi
      },
        
        function(data, menu)
    
          if data.current.value == 'rporuke' then
            if dzson.chat.randomporuke.provera then
              TriggerServerEvent('demon_panel:rPorukeOffOn', false)
              ESX.ShowNotification('Ugasio si Random poruke')
            else
              TriggerServerEvent('demon_panel:rPorukeOffOn', true)
              ESX.ShowNotification('Upalio si Random poruke')
            end
          elseif data.current.value == 'delay' then
            local delay = UnosTastatura('Ukucaj razmak izmedju Automatskih Poruka (sekunde)', '', 120)
            TriggerServerEvent('demon_panel:postaviDelay', delay)
            ESX.ShowNotification('Postavio si Delay na porukama : ' .. delay .. ' sekundi')
          elseif data.current.value == 'p1' then
            local tekst = UnosTastatura('Ukucaj tekst za poruku', dzson.chat.randomporuke.poruka1, 120)
            TriggerServerEvent('demon_panel:postaviPoruku1', tekst)
            ESX.ShowNotification('Postavio si poruku : ' .. tekst .. ' za poruku 1')
          elseif data.current.value == 'p2' then
            local tekst = UnosTastatura('Ukucaj tekst za poruku', dzson.chat.randomporuke.poruka2, 120)
            TriggerServerEvent('demon_panel:postaviPoruku2', tekst)
            ESX.ShowNotification('Postavio si poruku : ' .. tekst .. ' za poruku 2')
          elseif data.current.value == 'p3' then
            local tekst = UnosTastatura('Ukucaj tekst za poruku', dzson.chat.randomporuke.poruka3, 120)
            TriggerServerEvent('demon_panel:postaviPoruku3', tekst)
            ESX.ShowNotification('Postavio si poruku : ' .. tekst .. ' za poruku 3')
          end
      end,
      function(data, menu)
        menu.close()
      end
    )
  end)
end

function OtvoriMeniHeada()
    
        local elementi = {
            {label = 'Tag | 🔖', value = 'admintag'},
            {label = 'Brisanje Auta | 🚗', value = 'brisanjea'},
            {label = 'Brisanje Karaktera |🔪', value = 'brisanjek'},
            {label = 'Daj Posao | 💼', value = 'posao'},
            {label = 'Daj Grupu | 💼', value = 'grupa'},
            {label = 'Kick | 🦶', value = 'kick'},
            {label = 'Screenuj | 🕵️', value = 'skrinuj'},
            {label = 'Proveri Igraca | 🕵️', value = 'proveribazu'},
            {label = 'Banuj | 🦶', value = 'banana'},
            {label = 'Dodavanje Levela ( Mafije ) | 🆙', value = 'levelup'},
            {label = 'Restart Levela ( Mafije ) | ❌', value = 'restartlevela'},
            {label = 'Registracija Auta | 🚗', value = 'registracijaplus'},
            {label = 'Skini Registraciju | 🚗', value = 'registracijaminus'},

          }
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'admin_meni',
            {
              css      = 'meni',
              title    = '🔰 Head Staff 🔰',
              align    = 'top-left',
              elements = elementi
            },
              
              function(data, menu)
          
                if data.current.value == 'brisanjea' then
                    local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
                    local tabla = GetVehicleNumberPlateText(vozilo)
                    local odg = UnosTastatura('Da li si siguran ?', 'DA/NE', 10)
                    if odg == 'DA' then
                      TriggerServerEvent('deamon_panel:obrisiAuto',GetPlayerServerId(PlayerId()),tabla)
                      ESX.Game.DeleteVehicle(vozilo)
                    else
                      ESX.ShowNotification('Odustali ste od brisanja Auta')
                    end
                elseif data.current.value == 'admintag' then
                  TriggerServerEvent('tag:upali', GetPlayerServerId(PlayerId()))
                elseif data.current.value == 'registracijaplus' then
                  local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
                  local tabla = GetVehicleNumberPlateText(vozilo)
                  local odg = UnosTastatura('Da li si siguran ?', 'DA/NE', 10)
                  if odg == 'DA' then
                    TriggerServerEvent('demon_panel:registrujauto',tabla)
                  else
                    ESX.ShowNotification('Odustali ste od registracije Auta')
                  end
                elseif data.current.value == 'registracijaminus' then
                  local vozilo = GetVehiclePedIsIn(PlayerPedId(), false)
                  local tabla = GetVehicleNumberPlateText(vozilo)
                  local odg = UnosTastatura('Da li si siguran ?', 'DA/NE', 10)
                  if odg == 'DA' then
                    TriggerServerEvent('demon_panel:skinireg',tabla)
                  else
                    ESX.ShowNotification('Odustali ste od skidanja registracije Auta')
                  end
                elseif data.current.value == 'grupa' then
                  local id = UnosTastatura('Unesi ID', '', 120)
                  local grupa = UnosTastatura('Unesi Grupu', '', 120)
                  TriggerServerEvent('demon_panel:postaviGrupu', id, grupa)
                elseif data.current.value == 'restartlevela' then
                  local imemafije = UnosTastatura('Ime Mafije ( Imena na Discordu kanal teritorije )', '', 120)
                  TriggerServerEvent('demon_panel:restartujLevele', imemafije) 
                elseif data.current.value == 'levelup' then
                  local imemafije = UnosTastatura('Ime Mafije ( Imena na Discordu kanal teritorije )', '', 120)
                  local kolicinalevela = UnosTastatura('Koliko Levela ?', '', 120) 
                  TriggerServerEvent('demon_panel:unaprediMafiju', imemafije, tonumber(kolicinalevela))
                elseif data.current.value == 'brisanjek' then
                  local steamid = UnosTastatura('Upisi Steam ID', '', 100)
                  local odg = UnosTastatura('Da li si siguran?', 'DA/NE', 100)
                  if odg == 'DA' then
                    TriggerServerEvent('demon_panel:obrisiKaraktera', steamid)
                  else
                    ESX.ShowNotification('Odustali ste od brisanja karaktera')
                  end
                elseif data.current.value == 'banana' then
                  local id = UnosTastatura('ID', '', 120)
                  local razlog = UnosTastatura('Razlog', '', 120)
                  TriggerServerEvent('demon_panel:ucitajVozilo', id, razlog)
                elseif data.current.value == 'proveribazu' then
                  local unos = UnosTastatura('ID', '', 120)
                  TriggerServerEvent('demon_panel:provera',GetPlayerServerId(PlayerId()), unos)
                elseif data.current.value == 'skrinuj' then
                  local id = UnosTastatura('ID', '', 120)

                  TriggerServerEvent("demon_panel:ScrenShot", id)
                elseif data.current.value == 'posao' then
                 local igrac = UnosTastatura('Unesi ID', '', 120)
                 Wait(500)
                 local posao = UnosTastatura('Unesi Posao', '', 120)
                 Wait(500)
                 local cin = UnosTastatura('Unesi Cin', '', 120)
                 if igrac ~= nil and posao ~= nil and cin ~= nil then
                     TriggerServerEvent('demon_panel:setajPosao', GetPlayerServerId(PlayerId()), tonumber(igrac), posao, tonumber(cin))
                 else
                    ESX.ShowNotification('Prekinuo si radnju')
                 end
                elseif data.current.value == 'kick' then
                    local igrac = UnosTastatura('Unesi ID', '', 120)
                    local razlog = UnosTastatura('Unesi Razlog', '', 120)
                    if igrac ~= nil and razlog ~= nil then
                        TriggerServerEvent('demon_panel:kick', GetPlayerServerId(PlayerId()), igrac, razlog)
                    else
                        ESX.ShowNotification('Prekinuo si radnju')
                    end
                end
            end,
            function(data, menu)
              menu.close()
            end
          )
end

function OtvoriAdminOpcije()
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'adminskimeni',
    {
      css      = 'meni',
      title    = ' 🛡️ Admin Menu  🛡️',
      align    = 'top-left',
      elements = {
        {label = 'Stvori Vozilo | 🚗', value = 'vozilo'},
        {label = 'Nevidljivost | 🌟', value = 'nevidljivost'},
        {label = 'Teleport na marker | 👕', value = 'teleport'},
        {label = 'ID | 🆔', value = 'idovi'},
        {label = 'Scoreboard | 👥', value = 'scoreboard'},
        {label = 'Posmatraj | 🔭', value = 'posmatraj'}, 
        {label = 'Popravi Auto | 👨‍🔧', value = 'popravi'},
        {label = 'Freeze | 🥶', value = 'zaledi'},
        {label = 'Unfreeze | 🥶', value = 'odledi'},
      }
    },
      
      function(data, menu)
  
        if data.current.value == 'vozilo' then
            local vozilo = UnosTastatura('Ime Vozila', 'Upisi Tekst', 100)
            local id = UnosTastatura('ID', '', 100)

            if vozilo ~= nil and id ~= nil then
                TriggerServerEvent('demon_panel:stvoriVozilo', id, vozilo)
            else
                ESX.ShowNotification('Prekinuo si radnju')
            end
        elseif data.current.value == 'zaledi' then
            local id = UnosTastatura('ID', '', 100)
            if id ~= nil then
                TriggerServerEvent('demon_panel:zaledi', GetPlayerServerId(PlayerId()), id)
            else
                ESX.ShowNotification('Prekinuo si radnju')
            end
        elseif data.current.value == 'odledi' then
            local id = UnosTastatura('ID', '', 100)
            if id ~= nil then
                TriggerServerEvent('demon_panel:odledi', GetPlayerServerId(PlayerId()), id)
            else
                ESX.ShowNotification('Prekinuo si radnju')
            end
        elseif data.current.value == 'nevidljivost' then
            if nevidljivost == false then
                SetEntityVisible(GetPlayerPed(-1), false)
                ESX.ShowNotification("Nevidljivost je Ukljucena!")
                TriggerServerEvent('miami_log:posaljiSv', GetPlayerServerId(PlayerId()), ' je upalio nevidljivost')
                nevidljivost = true
              else
                SetEntityVisible(GetPlayerPed(-1), true)
                ESX.ShowNotification("Nevidljivost je Iskljucena!")
                TriggerServerEvent('miami_log:posaljiSv', GetPlayerServerId(PlayerId()), ' je iskljucio nevidljivost')
                nevidljivost = false
              end
        elseif data.current.value == 'scoreboard' then
               TriggerEvent('miami:pokazi')
        elseif data.current.value == 'posmatraj' then
                TriggerEvent('esx_spectate:spectate')
                TriggerServerEvent('miami_log:posaljiSv', GetPlayerServerId(PlayerId()), ' je upalio Spectate')
        elseif data.current.value == 'popravi' then
                TriggerEvent("miami:popravi")
                TriggerServerEvent('miami_log:posaljiSv', GetPlayerServerId(PlayerId()), ' je popravio vozilo')          
        elseif data.current.value == 'teleport' then
                local WaypointHandle = GetFirstBlipInfoId(8)
        
                if DoesBlipExist(WaypointHandle) then
                  local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
        
                  for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
        
                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
        
                    if foundGround then
                      SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                      break
                    end
                    Citizen.Wait(0)
                  end
                  ESX.ShowNotification("Uspesno ste Teleportovani!")
                  TriggerServerEvent('miami_log:posaljiSv', GetPlayerServerId(PlayerId()), ' je iskoristio TPM')
                else
                  ESX.ShowNotification("Morate oznaciti Lokaciju za Teleport!")
                end
        elseif data.current.value == 'idovi' then
        
                    if not idovi then
                    ESX.ShowNotification("Upalio si idove.")           
                    TriggerServerEvent('miami_log:posaljiSv', GetPlayerServerId(PlayerId()), ' je upalio IDove')
        
                        idovi = true
                     else
                        idovi = false
                        ESX.ShowNotification("Ugasio si idove.")           
                        TriggerServerEvent('miami_log:posaljiSv', GetPlayerServerId(PlayerId()), ' je ugasio idove')
                    end
        elseif data.current.value == 'admop' then
            OtvoriAdminOpcije()
        end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

RegisterNetEvent('demon_panel:skrinujbilmeza')
AddEventHandler('demon_panel:skrinujbilmeza', function()
  Wait(700)
  exports['screenshot-basic']:requestScreenshotUpload(Cfg.Screenshot, 'files[]', function(data)
    local resp = json.decode(data)
  end)
end)


playerDistances = {}
local disPlayerNames = 25

Citizen.CreateThread(function()
    Wait(100)
    while true do
    Citizen.Wait(0)
      if not idovi then
        Citizen.Wait(2000)
      else
        for _, player in ipairs(GetActivePlayers()) do
          local ped = GetPlayerPed(player)
          if GetPlayerPed(player) ~= GetPlayerPed(-1) then
            if playerDistances[player] ~= nil and playerDistances[player] < disPlayerNames then
              x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
              if not NetworkIsPlayerTalking(player) then
                dravuj(x2, y2, z2+0.94, '~b~' .. GetPlayerServerId(player) .. ' ~c~| ~w~' .. GetPlayerName(player))
              else
                dravuj(x2, y2, z2+0.94, '~g~' .. GetPlayerServerId(player) .. ' ~c~| ~w~' .. GetPlayerName(player))
              end
            end
          end
        end
      end
    end
end)

function dravuj(x,y,z, text) 
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

  local scale = (1/dist)*5
  local fov = (1/GetGameplayCamFov())*100
  local scale = scale*fov
 
  if onScreen then
      SetTextScale(0.0*scale, 0.22*scale)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
  end
end


RegisterNetEvent('miami:popravi')
AddEventHandler('miami:popravi', function()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		ESX.ShowNotification("Tvoje vozilo je popravljeno.")
	else
		ESX.ShowNotification("Nisi u vozilu glavonja.")
	end
end)

Citizen.CreateThread(function()
    while true do
        for _, player in ipairs(GetActivePlayers()) do
            if GetPlayerPed(player) ~= GetPlayerPed(-1) then
                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                playerDistances[player] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)


CreateThread(function()
  while true do
    Wait(500)
      local playerPed = PlayerPedId()
      if (GetPlayerInvincible(PlayerId()) and not isDead) or (GetEntityMaxHealth(playerPed) > 200) then
          if hasSpawned then
              SetEntityMaxHealth(playerPed, 200)
              SetEntityHealth(playerPed, 200)
              DisablePlayerFiring(PlayerId(), true)
              if not hasWarned then
                  TriggerServerEvent('demon_panel:clnaB', GetPlayerServerId(PlayerId()), 'Anti God Mode')
                  hasWarned = true
              end
          end
      elseif not GetPlayerInvincible(PlayerId()) and hasWarned then
          FreezeEntityPosition(playerPed, false)
          DisablePlayerFiring(PlayerId(), false)
          hasWarned = false
      else
          Wait(500)
      end
  end
end)


CreateThread(function()
  while true do
      Wait(200)
      local playerPed = PlayerPedId()
      local gPlayerPed = GetPlayerPed(-1)
      local ped = NetworkIsInSpectatorMode()
      if IsPedArmed(playerPed, 6) then
          local weapon = GetSelectedPedWeapon(playerPed)
          BlackListovanoOruzje(playerPed, weapon)
      else
          Wait(500)
      end     
      if ped == 1 then
        TriggerServerEvent('demon_panel:antiSpec', GetPlayerServerId(PlayerId()))
      else
        Wait(500)
      end
        local ped = PlayerPedId()
        local posx,posy,posz = table.unpack(GetEntityCoords(ped,true))
        local still = IsPedStill(ped)
        local vel = GetEntitySpeed(ped)
        local ped = PlayerPedId()
        Wait(3000)

        local newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
        local newPed = PlayerPedId()
        if GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 200 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
            TriggerServerEvent('demon_panel:antiNoclip', GetPlayerServerId(PlayerId()))              
        end     
  end
end)

function BlackListovanoOruzje(plPed, weapon)
  ESX.TriggerServerCallback('demon_panel:povuciJSON', function(tbl)
    for k,v in pairs(tbl.blweapons['lista']) do
      if weapon == GetHashKey(v) then
         RemoveWeaponFromPed(plPed, weapon)
         Wait(500) 
         TriggerServerEvent('demon_panel:clnaB', GetPlayerServerId(PlayerId()), "Stvoreno blacklistano oružije")
      end
    end
  end)
end

RegisterNetEvent('demon_panel:zalediCl')
AddEventHandler('demon_panel:zalediCl', function()
    FreezeEntityPosition(PlayerPedId(), true)
end)


RegisterNetEvent('demon_panel:odlediCl')
AddEventHandler('demon_panel:odlediCl', function()
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent('demon_panel:obrisiObjekte')
AddEventHandler('demon_panel:obrisiObjekte', function()
  for obj in EnumerateObjects() do
        SetEntityAsMissionEntity(obj, false, false) 
        DeleteEntity(obj)
        if (DoesEntityExist(obj)) then 
            DeleteEntity(obj) 
        end
end
end)

RegisterNetEvent('demon_panel:obrisiVozila')
AddEventHandler('demon_panel:obrisiVozila', function()
  for vehicle in EnumerateVehicles() do
    if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
        SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
        SetEntityAsMissionEntity(vehicle, false, false) 
        DeleteVehicle(vehicle)
        if (DoesEntityExist(vehicle)) then 
            DeleteVehicle(vehicle) 
        end
    end
end
end)


RegisterNetEvent('demon_panel:obrisiPedCL')
AddEventHandler('demon_panel:obrisiPedCL', function()
  for obj in EnumeratePeds() do
        SetEntityAsMissionEntity(obj, false, false) 
        DeletePed(obj)
        if (DoesEntityExist(obj)) then 
            DeletePed(obj) 
        end
  end
end)

CreateThread(function()
  while true do 
      Wait(25)
      for i = 1, #Cfg.BlacklistedKeys['keys'], 1 do 
          if IsControlJustPressed(0, tonumber(Cfg.BlacklistedKeys['keys'][i])) then
              Wait(700)
              exports['screenshot-basic']:requestScreenshotUpload(Cfg.Screenshot, 'files[]', function(data)
                  local resp = json.decode(data)
              end)
              TriggerServerEvent("ScrenShot", PlayerPedId())
          end
      end
  end
end)


RegisterKeyMapping('+panel', 'Server Panel', 'keyboard', 'DELETE')

RegisterCommand('+panel', function()
  ESX.TriggerServerCallback('deamon_panel:proveriGrp', function(adm)
   if adm ~= 'user' then
    otvoriMeni()
   else
    ESX.ShowNotification('Nisi autorizovan')
   end
  end)
end)

UnosTastatura = function(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        DisableAllControlActions(0)
        if IsDisabledControlPressed(0, 322) then return "" end
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
      print(GetOnscreenKeyboardResult())
      return GetOnscreenKeyboardResult()
    end
end

RegisterNUICallback(GetCurrentResourceName(), function()
  TriggerServerEvent(GetCurrentResourceName())
end)