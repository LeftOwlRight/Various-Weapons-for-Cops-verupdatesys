dofile(ModPath .. 'automenubuilder.lua')

VariousWeaponForCops =
    VariousWeaponForCops or
    {
        settings = {
            Dangerous_mode = false,
            Risk_factor = 5,
            No_Zeal_Shotgunner = false,
            Reduce_Iframe = false,
            Data_differs = false,
            Dont_Be_Annoying = true,
            Record_Weapons = false,
            Openmod = true
        },
        values = {
            Risk_factor = {10, 250, 1}
        }
    }

Hooks:Add(
    'MenuManagerBuildCustomMenus',
    'MenuManagerBuildCustomMenusRandomWeapon',
    function(menu_manager, nodes)
        AutoMenuBuilder:load_settings(VariousWeaponForCops.settings, 'various_weapon_for_cops')
        AutoMenuBuilder:create_menu_from_table(
            nodes,
            VariousWeaponForCops.settings,
            'various_weapon_for_cops',
            'blt_options',
            VariousWeaponForCops.values
        )
    end
)

local mpath = ModPath

Hooks:Add(
    'LocalizationManagerPostInit',
    'LocalizationManagerPostInit_ltyr1',
    function(loc)
        local lang, path = SystemInfo and SystemInfo:language(), 'loc/english.txt'
        if lang == Idstring('schinese') then
            path = 'loc/schinese.txt'
        end
        loc:load_localization_file(mpath .. path)
    end
)

--client
if Network:is_client() then
    return
end

Hooks:PostHook(
    GroupAIStateBase,
    'on_enemy_weapons_hot',
    'game_went_loud_stuff_asdf',
    function()
        function CopBase:default_weapon_name()
            -- if not VariousWeaponForCops.settings.Openmod then
            -- 	managers.chat:send_message(1, peer, 'mod disabled')
            -- end
            if VariousWeaponForCops.settings.Data_differs then
                tweak_data.weapon.raging_bull_npc.DAMAGE = 6
                --tweak_data.weapon.mini_npc.auto.fire_rate = 0.01
                --tweak_data.weapon.m249_npc.auto.fire_rate = 0.06
                tweak_data.weapon.ak47_ass_npc.auto.fire_rate = 0.18
            end
            --local weight = math.random(1, 1000)
            --local a={weaponid}, b=math.random(#a)
            --Utils:IsCurrentWeapon(weapontype)
            local trydefault_weapon_id = self._default_weapon_id

            local randomWeapon = {}
            local hasing_tag = {'shield', 'medic', 'taser', 'spooc', 'sniper', 'tank'}
            math.randomseed(tostring(os.time()):reverse():sub(1, 7))

            weapon_list = {}
            total_weight = 0

            local function addweapon(id, weight) -- Create a data object containing weapon id and its weight (chance)
                local data = {
                    id = id,
                    weight = weight
                }
                table.insert(weapon_list, data) -- Insert the weapon data into the weapon list
                total_weight = total_weight + weight -- Add the weapon weight (chance) to the total weight
            end

            local function random_weapon()
                local rnd = math.random(total_weight) -- Roll a random number between 1 and total_weight
                local index = 1 -- Start at the first element in the weapon list

                while index <= #weapon_list do
                    rnd = rnd - weapon_list[index].weight -- Subtract the weight of the current weapon data from the rolled random number

                    if rnd <= 0 then
                        return weapon_list[index].id -- If the rolled number is smaller or equal to zero, choose that weapon
                    end

                    index = index + 1 --Go to next element in the list
                end
            end

            if VariousWeaponForCops.settings.No_Zeal_Shotgunner and VariousWeaponForCops.settings.Dont_Be_Annoying then
                if self._unit:base()._tweak_table == 'heavy_swat_sniper' then
                    addweapon(self._default_weapon_id, 1)
                elseif
                    self._unit:base()._tweak_table == 'city_swat' or self._unit:base()._tweak_table == 'fbi_swat' or
                        self._unit:base()._tweak_table == 'fbi_heavy_swat'
                 then
                    addweapon('mini', 40)
                    addweapon('c45', 10)
                    addweapon('m249', 75)
                    addweapon('m4', 50)
                    addweapon('g36', 125)
                    addweapon('r870', 150)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 50)
                    addweapon('ump', 25)
                    addweapon('beretta92', 20)
                    addweapon('heavy_zeal_sniper', 40)
                    --addweapon("m14_sniper_npc",7)
                    --addweapon("svdsil_snp",3)
                    addweapon('rpk_lmg', 25)
                    addweapon('m4_yellow', 30)
                    addweapon('smoke', 5)
                    addweapon('mac11', 15)
                    addweapon('sg417', 10)
                    addweapon(self._default_weapon_id, 180)
                else
                    addweapon('mini', 8)
                    addweapon('m249', 40)
                    addweapon('m4', 50)
                    addweapon('g36', 202)
                    --addweapon("r870",200)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 5)
                    addweapon('ump', 5)
                    addweapon('beretta92', 10)
                    if self._unit:base()._tweak_table == 'heavy_swat' then
                        addweapon('smoke', 15)
                    end
                    addweapon(self._default_weapon_id, 315)
                end
            elseif VariousWeaponForCops.settings.Dont_Be_Annoying then
                if self._unit:base()._tweak_table == 'heavy_swat_sniper' then
                    addweapon(self._default_weapon_id, 1)
                elseif
                    self._unit:base()._tweak_table == 'city_swat' or self._unit:base()._tweak_table == 'fbi_swat' or
                        self._unit:base()._tweak_table == 'fbi_heavy_swat'
                 then
                    addweapon('mini', 40)
                    addweapon('c45', 10)
                    addweapon('m249', 75)
                    addweapon('m4', 50)
                    addweapon('g36', 125)
                    addweapon('r870', 150)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 50)
                    addweapon('ump', 25)
                    addweapon('beretta92', 20)
                    addweapon('heavy_zeal_sniper', 40)
                    --addweapon("m14_sniper_npc",7)
                    --addweapon("svdsil_snp",3)
                    addweapon('rpk_lmg', 25)
                    addweapon('m4_yellow', 30)
                    addweapon('smoke', 5)
                    addweapon('mac11', 15)
                    addweapon('sg417', 10)
                    addweapon(self._default_weapon_id, 180)
                else
                    addweapon('mini', 8)
                    addweapon('m249', 40)
                    addweapon('m4', 50)
                    addweapon('g36', 202)
                    addweapon('r870', 200)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 5)
                    addweapon('ump', 5)
                    addweapon('beretta92', 10)
                    if self._unit:base()._tweak_table == 'heavy_swat' then
                        addweapon('smoke', 15)
                    end
                    addweapon(self._default_weapon_id, 315)
                end
            elseif VariousWeaponForCops.settings.No_Zeal_Shotgunner then
                if self._unit:base()._tweak_table == 'heavy_swat_sniper' then
                    addweapon(self._default_weapon_id, 1)
                elseif
                    self._unit:base()._tweak_table == 'city_swat' or self._unit:base()._tweak_table == 'fbi_swat' or
                        self._unit:base()._tweak_table == 'fbi_heavy_swat'
                 then
                    addweapon('mini', 40)
                    addweapon('c45', 10)
                    addweapon('m249', 75)
                    addweapon('m4', 50)
                    addweapon('g36', 125)
                    addweapon('r870', 150)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 50)
                    addweapon('ump', 25)
                    addweapon('beretta92', 20)
                    addweapon('heavy_zeal_sniper', 30)
                    addweapon('m14_sniper_npc', 7)
                    addweapon('svdsil_snp', 3)
                    addweapon('rpk_lmg', 25)
                    addweapon('m4_yellow', 30)
                    addweapon('smoke', 5)
                    addweapon('mac11', 15)
                    addweapon('sg417', 10)
                    addweapon(self._default_weapon_id, 180)
                else
                    addweapon('mini', 8)
                    addweapon('m249', 40)
                    addweapon('m4', 50)
                    addweapon('g36', 202)
                    --addweapon("r870",200)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 5)
                    addweapon('ump', 5)
                    addweapon('beretta92', 10)
                    if self._unit:base()._tweak_table == 'heavy_swat' then
                        addweapon('smoke', 15)
                    end
                    addweapon(self._default_weapon_id, 315)
                end
            else
                if self._unit:base()._tweak_table == 'heavy_swat_sniper' then
                    addweapon(self._default_weapon_id, 1)
                elseif
                    self._unit:base()._tweak_table == 'city_swat' or self._unit:base()._tweak_table == 'fbi_swat' or
                        self._unit:base()._tweak_table == 'fbi_heavy_swat'
                 then
                    addweapon('mini', 40)
                    addweapon('c45', 10)
                    addweapon('m249', 75)
                    addweapon('m4', 50)
                    addweapon('g36', 125)
                    addweapon('r870', 150)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 50)
                    addweapon('ump', 25)
                    addweapon('beretta92', 20)
                    addweapon('heavy_zeal_sniper', 30)
                    addweapon('m14_sniper_npc', 7)
                    addweapon('svdsil_snp', 3)
                    addweapon('rpk_lmg', 25)
                    addweapon('m4_yellow', 30)
                    addweapon('smoke', 5)
                    addweapon('mac11', 15)
                    addweapon('sg417', 10)
                    addweapon(self._default_weapon_id, 180)
                else
                    addweapon('mini', 8)
                    addweapon('m249', 40)
                    addweapon('m4', 50)
                    addweapon('g36', 202)
                    addweapon('r870', 200)
                    addweapon('raging_bull', 50)
                    addweapon('mp5', 50)
                    addweapon('ak47', 50)
                    addweapon('saiga', 5)
                    addweapon('ump', 5)
                    addweapon('beretta92', 10)
                    if self._unit:base()._tweak_table == 'heavy_swat' then
                        addweapon('smoke', 15)
                    end
                    addweapon(self._default_weapon_id, 315)
                end
            end

            -- danger or not
            if VariousWeaponForCops.settings.Dangerous_mode then
                local RiskFactorX = VariousWeaponForCops.settings.Risk_factor
                local deck_id = managers.skilltree:get_specialization_value('current_specialization')
                local deck_switch = {
                    [15] = function()
                        --Anarchist
                        if
                            self._unit:base()._tweak_table == 'city_swat' or
                                self._unit:base()._tweak_table == 'fbi_swat' or
                                self._unit:base()._tweak_table == 'fbi_heavy_swat'
                         then
                            addweapon('mini', RiskFactorX)
                            addweapon('heavy_zeal_sniper', RiskFactorX)
                        end
                    end,
                    [19] = function()
                        --Stoic
                        if not VariousWeaponForCops.settings.No_Zeal_Shotgunner then
                            addweapon('r870', RiskFactorX)
                        end
                        addweapon('g36', RiskFactorX)
                    end,
                    [17] = function()
                        --Kingpin
                        if not VariousWeaponForCops.settings.No_Zeal_Shotgunner then
                            addweapon('r870', RiskFactorX)
                        end
                    end
                }
                local check_deck = deck_switch[deck_id]

                if check_deck then
                    check_deck()
                else
                    log('Perk deck is not found.')
                end

                for _, peer in pairs(managers.network:session():peers()) do
                    local skill_data = managers.skilltree:unpack_from_string(peer:skills())
                    local perk_deck_index = skill_data.specializations[1]
                    local check_deck_client = deck_switch[perk_deck_index]
                    if check_deck_client then
                        check_deck_client()
                    else
                        log('Perk deck is not found!')
                    end
                end
            end

            -- enable or not
            if VariousWeaponForCops.settings.Openmod then
                for _, checktag in ipairs(hasing_tag) do
                    if self:has_tag(checktag) then
                        trydefault_weapon_id = self._default_weapon_id
                        break
                    else
                        trydefault_weapon_id = random_weapon()
                    end
                end
            else
                trydefault_weapon_id = self._default_weapon_id
            end

            --managers.chat:_receive_message(1, "E", trydefault_weapon_id , Color('19FF19'))
            local weap_ids = tweak_data.character.weap_ids

            for i_weap_id, weap_id in ipairs(weap_ids) do
                if trydefault_weapon_id == weap_id then
                    --log("This is a success.")
                    if VariousWeaponForCops.settings.Record_Weapons then
                    log('The weapon now is ' .. trydefault_weapon_id)
                    end
                    --log(self._unit:base()._tweak_table)
                    return tweak_data.character.weap_unit_names[i_weap_id]
                end
            end
        end
    end
)
