-- ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐                                                                                                     
-- │ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
-- │    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
-- │   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
-- │  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
-- │ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ © Copyright 2024                                                                                   │ 
-- └────────────────────────────────────────────────────────────────────────────────────────────────────┘

GM = GM or {}
GM.Options = GM.Options or {}

GM.Options.corpseEnabled = true
GM.Options.corpseMeanness = 1
GM.Options.devicesEnabled = true
GM.Options.devicesMeanness = 0
GM.Options.nakedEnabled = true
GM.Options.nakedMeanness = 2
GM.Options.nightNoisesEnabled = true
GM.Options.nightNoisesMeanness = 0
GM.Options.poltergeistsEnabled = true
GM.Options.poltergeistsMeanness = 7
GM.Options.puppetMasterEnable = true
GM.Options.puppetMasterMeanness = 7
GM.Options.scarecrowEnabled = true
GM.Options.scarecrowMeanness = 5
GM.Options.sleepWalkerEnabled = true
GM.Options.sleepWalkerMeanness = 4
GM.Options.lightsEnabled = true
GM.Options.lightsMeanness = 9

GM.Options.insanityFactor = 5

if ModOptions and ModOptions.getInstance then
  local meannessValues = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }

  local function onModOptionsApply(optionValues)
    GM.Options.corpseEnabled = optionValues.settings.options.corpseEnabled
    GM.Options.corpseMeanness = meannessValues[optionValues.settings.options.corpseMeanness]
    
    GM.Options.devicesEnabled = optionValues.settings.options.devicesEnabled
    GM.Options.devicesMeanness = meannessValues[optionValues.settings.options.devicesMeanness]
    
    GM.Options.nakedEnabled = optionValues.settings.options.nakedEnabled
    GM.Options.nakedMeanness = meannessValues[optionValues.settings.options.nakedMeanness]
    
    GM.Options.nightNoisesEnabled = optionValues.settings.options.nightNoisesEnabled
    GM.Options.nightNoisesMeanness = meannessValues[optionValues.settings.options.nightNoisesMeanness]
    
    GM.Options.poltergeistsEnabled = optionValues.settings.options.poltergeistsEnabled
    GM.Options.poltergeistsMeanness = meannessValues[optionValues.settings.options.poltergeistsMeanness]
    
    GM.Options.puppetMasterEnabled = optionValues.settings.options.puppetMasterEnabled
    GM.Options.puppetMasterMeanness = meannessValues[optionValues.settings.options.puppetMasterMeanness]
        
    GM.Options.scarecrowEnabled = optionValues.settings.options.scarecrowEnabled
    GM.Options.scarecrowMeanness = meannessValues[optionValues.settings.options.scarecrowMeanness]
    
    GM.Options.sleepWalkerEnabled = optionValues.settings.options.sleepWalkerEnabled
    GM.Options.sleepWalkerMeanness = meannessValues[optionValues.settings.options.sleepWalkerMeanness]    
    
    GM.Options.lightsEnabled = optionValues.settings.options.lightsEnabled
    GM.Options.lightsMeanness = meannessValues[optionValues.settings.options.lightsMeanness]    
    
    GM.Options.insanityFactor = meannessValues[optionValues.settings.options.insanityFactor]    
  end

  local SETTINGS = {
    options_data = {
      corpsEnabled = {
        name = "UI_GM_Corpse_Enable",
        tooltip = "UI_GM_Corpse_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      corpsMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_Corpse_Meanness",
        tooltip = "UI_GM_Meanness_Tooltip",
        default = 2,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      
      devicesEnabled = {
        name = "UI_GM_Devices_Enable",
        tooltip = "UI_GM_Devices_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      devicesMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_Devices_Meanness",
        tooltip = "UI_GM_Meanness_Tooltip",
        default = 1,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
            
      nakedEnabled = {
        name = "UI_GM_Naked_Enable",
        tooltip = "UI_GM_Naked_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      nakedMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_Naked_Meanness",
        tooltip = "UI_GM_Meanness_Tooltip",
        default = 3,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      
      nightNoisesEnabled = {
        name = "UI_GM_NNoises_Enable",
        tooltip = "UI_GM_NNoises_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      nightNoisesMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_NNoises_Meanness",
        tooltip = "UI_GM_NNoises_Meanness_Tooltip",
        default = 1,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      
      poltergeistsEnabled = {
        name = "UI_GM_Poltergeists_Enable",
        tooltip = "UI_GM_Poltergeists_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      poltergeistsMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_Poltergeists_Meanness",
        tooltip = "UI_GM_Meanness_Tooltip",
        default = 8,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      
      puppetMasterEnabled = {
        name = "UI_GM_PuppetMaster_Enable",
        tooltip = "UI_GM_PuppetMaster_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      puppetMasterMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_PuppetMaster_Meanness",
        tooltip = "UI_GM_Meanness_Tooltip",
        default = 8,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      
      scarecrowEnabled = {
        name = "UI_GM_Scarecrow_Enable",
        tooltip = "UI_GM_Scarecrow_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      scarecrowMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_Scarecrow_Meanness",
        tooltip = "UI_GM_Meanness_Tooltip",
        default = 6,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      
      sleepWalkerEnabled = {
        name = "UI_GM_SleepWalker_Enable",
        tooltip = "UI_GM_SleepWalker_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      sleepWalkerMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_SleepWalker_Meanness",
        tooltip = "UI_GM_Meanness_Tooltip",
        default = 5,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },      
      
      lightsEnabled = {
        name = "UI_GM_Lights_Enable",
        tooltip = "UI_GM_Lights_Enable_Tooltip",
        default = true,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
      lightsMeanness = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_Lights_Meanness",
        tooltip = "UI_GM_Lights_Meanness_Tooltip",
        default = 9,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },   
      
      insanityFactor = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        name = "UI_GM_Insanity_Factor",
        tooltip = "UI_GM_Insanity_Factor_Tooltip",
        default = 5,
        OnApplyMainMenu = onModOptionsApply,
        OnApplyInGame = onModOptionsApply,
      },
    },

    mod_id = 'GoodnightMother',
    mod_shortname = 'Goodnight Mother',
    mod_fullname = 'Goodnight Mother',
  }

    local optionsInstance = ModOptions:getInstance(SETTINGS)
    ModOptions:loadFile()

    GM.init()

    Events.OnPreMapLoad.Add(function() onModOptionsApply({ settings = SETTINGS }) end)
end