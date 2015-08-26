$imported = {} if $imported.nil?

$imported["Cheat Engine Delux"] = true
#==============================================================================
# Name - Cheat Engine Delux
# Author - Sarlecc
# Version - 1.1.0
# Difficulty - Moderate to Hard
#==============================================================================
# Introduction:
# This script is designed to allow developers to make cheats for their game.
# All cheats are entered into an in game console.
# Console can also be used to just affect variables or switches.
#
# 
# Ideas for use:
# Door console for opening up a door
# Cheat console
# Console for answering a riddle
# 
#  NOTE THIS DOES NOT GIVE PLAYERS THE ABILITY TO HACK
# 
#==============================================================================
# Instructions
# Place script below Materials and above Main
# 
# Script call: SceneManager.call(Scene_Cheat)
#==============================================================================
# compatibility
# aliased methods:
# Game_Enemy def param_base(param_id)
# Game_Enemy def exp
# Scene_Menu def command_game_end
# overwritten method:
# Game_Actor def param_base(param_id)
#==============================================================================
#==============================================================================
# Credit's
# Sarlecc
# TERMS: http://sarleccmythicalgames.blogspot.com/p/blog-page_12.html
#
#==============================================================================
#------------------------------------------------------------------------------
# Author's notes:
# This script I wrote mostly between the hours of 1 and 4 am. So there may be
# parts in the script that are overly complicated.
#==============================================================================
# You can add new cheats however you will also have to completely
# define what they do.
#==============================================================================
#
# Updates:
# 11/28/2014 - Made it so you can enable the ability to only use a cheat once.
#==============================================================================

module SAR

  module Game_Cheat

    #=========================================================================
    # List of cheats change the strings to any thing you want
    #
    #          List of characters you may use:
    #
    #          Latin
    #
    #         'A','B','C','D','E',  'a','b','c','d','e',
    #         'F','G','H','I','J',  'f','g','h','i','j',
    #         'K','L','M','N','O',  'k','l','m','n','o',
    #         'P','Q','R','S','T',  'p','q','r','s','t',
    #         'U','V','W','X','Y',  'u','v','w','x','y',
    #         'Z','[',']','^','_',  'z','{','}','|','~',
    #         '0','1','2','3','4',  '!','#','$','%','&',
    #         '5','6','7','8','9',  '(',')','*','+','-',
    #         '/','=','@','<','>',  ':',';',' ',
    #         'Á','É','Í','Ó','Ú',  'á','é','í','ó','ú',
    #         'À','È','Ì','Ò','Ù',  'à','è','ì','ò','ù',
    #         'Â','Ê','Î','Ô','Û',  'â','ê','î','ô','û',
    #         'Ä','Ë','Ï','Ö','Ü',  'ä','ë','ï','ö','ü',
    #         '','','*','L','j',  '','','+','M','k',
    #         'Ã','Å','Æ','Ç','Ð',  'ã','å','æ','ç','ð',
    #         'Ñ','Õ','Ø','`','t',  'ñ','õ','ø','a','u',
    #         'Ý','v','x','}','Þ',  'ý','ÿ','w','~','þ',
    #         '2','R','3','S','ß',  '«','»',' '
    #          
    #        Note Japense characters are supported if you are using them
    #=========================================================================

  MONEY_CHEAT = "Money"
  
  LEVEL_CHEAT = "1337level"

  #=============================================================================
  # Players may only have one of the following three cheats on at a time.
  #=============================================================================

  XP_CHEAT = "SUPERXP"

  BOSS_MONSTER = "WHOdaBOSS"

  EASY_MODE = "IT*S to HARD"

  #=============================================================================
  # Examples of the followings usage inside the cheat console
  # "ACTIVATE" 
  # "ACTIVATE i" where i is the SWITCH_ID
  # "VARIABLE"
  # "VARIABLE i" where i is the VARIABLE_ID
  #
  # Note you can change the first part of these strings to what ever you want
  # However you need the space and the %d at the end of your word
  #
  # "Works %d"       "doesn't work%d"       "doesn't work%"    "doesn't work"
  #============================================================================

  SWITCH = "ACTIVATE %d"

  SWITCH2 = "DEACTIVATE %d"

  VARIABLE = "INCREASE %d"
  
  VARIABLE2 = "DECREASE %d"

  #=============================================================================
  # This cheat is assigned to a $game_variable id
  # In an event you can use the following examples in the script command
  # 1: $game_variables[5] = "custom"
  #
  # Or you can set it to a random number using the normal game_variable command
  #=============================================================================

  CUSTOM_CHEAT = 5

  #============================================================================
  # assigned to a $game_switches id
  # use switch or variable
  # true for switch false for variable
  #============================================================================

  CUSTOM_CHEAT_OPTIONS = 1

  #============================================================================
  # assigned to a $game_variables id
  # change the value to change the switch or variable you want to use for custom 
  # cheat
  #============================================================================

  CUSTOM_CHEAT_ID = 6

  #============================================================================
  # assigned to a $game_switches id
  # in events turn this switch on or off
  # on if you want to increase the custom cheat variable
  # off if you want to decrease the custom cheat variable
  #============================================================================

  CUSTOM_CHEAT_UP_DOWN = 10

  #============================================================================
  # Increase the max amount of char's you can have for your cheats
  # Note if this is set to 0 then the max char's you can have is 10
  # 22 is the max this can go without characters getting lost off the window
  #============================================================================

  MAX_CHAR_INCREASE = 6

  #============================================================================
  # Use switches and variable cheats only?
  #============================================================================

  SWI_VAR_ONLY = false

  #============================================================================
  # Switches that can be changed through the cheats SWITCH and SWITCH2
  # Note affects all listed
  #============================================================================

  SWITCHES = [1, 2, 5]

  #============================================================================
  # For a single switch
  # this is assigned to $game_variables change the value of it to change which
  # switch gets changed - (In events)
  # example: $game_variables[5] = 1
  #
  # example cheat: ACTIVATE 1 
  #============================================================================

  SWITCH_ID = 7

  #============================================================================
  # Variables that can be changed through the cheats VARIABLE and VARIABLE2
  # Note affects all listed
  #============================================================================

  VARIABLES = [2, 5, 8, 6]

  #============================================================================
  # For a single variable
  # this is assigned to $game_variables change the value of it to change which
  # variable gets changed - (In events)
  # example: $game_variables[8] = 9 will allow you to change the value of the 
  # ninth variable.
  #
  # example cheat: INCREASE 9
  #============================================================================

  VARIABLE_ID = 8

  #============================================================================
  # Money to be gained with money cheat
  #============================================================================

  MONEY = 1337

  #============================================================================
  # Level to be gained with level cheat and with level type set to 2
  #============================================================================

  LEVEL = 5

  #============================================================================
  # Display level up message *note that Level cheat type 1 does
  # not currently show skills that the actors learned
  #============================================================================

  LEVELDIS = true

  #============================================================================
  # Level cheat type 1 is for adding onto current level
  # 2 is for going to a level directly
  #============================================================================

  LEVEL_CHEAT_TYPE = 2 # 1 or 2

  #============================================================================
  # Increase stats of monsters by X times
  #============================================================================

  BOSS_FACTOR = 3

  #============================================================================
  # Increase exp from monsters by X times
  #============================================================================

  XP_FACTOR = 3

  #============================================================================
  # Increase actor stats by X times
  #============================================================================

  EASY_FACTOR = 3

  #============================================================================
  # Increase variables in VARIABLES array by X
  #============================================================================

  VARIABLE_INCREASE_AMOUNT = 3

  #============================================================================
  # Decrease variables in VARIABLES array by X
  #============================================================================

  VARIABLE_DECREASE_AMOUNT = 2

  #============================================================================
  # Use cheats only once?
  # *note* that this does not apply to BOSS_MONSTER, XP_CHEAT or EASY_MODE
  # since these only apply if they were the last cheat used.
  #============================================================================

  CHEAT_ONCE = false

  #============================================================================
  # .:DO NOT CHANGE:. This is what the cheat gets saved too. .:DO NOT CHANGE:.
  #============================================================================

  CHEATS = {
      1 => {:cheat => '', :size => 0, :cheat_once => []}
      } # don't delete this

end
end

#===============================================================================
# EDIT PAST THIS LINE AT YOUR OWN RISK
#===============================================================================

class Game_Enemy < Game_Battler

  #============================================================================
  # Boss monster cheat
  #============================================================================

  alias sar_param_base_cheat param_base

  def param_base(param_id)
    sar_param_base_cheat(param_id)
    if SAR::Game_Cheat::CHEATS[1][:cheat] == SAR::Game_Cheat::BOSS_MONSTER && SAR::Game_Cheat::SWI_VAR_ONLY == false
    enemy.params[param_id] * SAR::Game_Cheat::BOSS_FACTOR
  else 
    enemy.params[param_id]
  end
end

  #============================================================================
  # XP cheat
  #============================================================================

  alias sar_exp_cheat exp
  
  def exp
    sar_exp_cheat
    if SAR::Game_Cheat::CHEATS[1][:cheat] == SAR::Game_Cheat::XP_CHEAT && SAR::Game_Cheat::SWI_VAR_ONLY == false
    enemy.exp * SAR::Game_Cheat::XP_FACTOR
  else 
    enemy.exp
    end
  end
end

class Game_Actor < Game_Battler

  #============================================================================
  # Easy mode cheat
  #============================================================================

  def param_base(param_id)
    if SAR::Game_Cheat::CHEATS[1][:cheat] == SAR::Game_Cheat::EASY_MODE && SAR::Game_Cheat::SWI_VAR_ONLY == false
      self.class.params[param_id, @level] * SAR::Game_Cheat::EASY_FACTOR
    else 
      self.class.params[param_id, @level]
    end
  end

  #===========================================================================
  # Level type 1
  #===========================================================================

  def level_up2
    @level += SAR::Game_Cheat::LEVEL
    self.class.learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level == @level
    end
    if SAR::Game_Cheat::LEVELDIS
    $game_message.new_page
    $game_message.add(sprintf(Vocab::LevelUp, @name, Vocab::level, @level))
  end
  end

  #============================================================================
  # Level type 2
  #============================================================================

  def change_level2(level, show)
    level = [[level, max_level].min, 1].max
    change_exp(exp_for_level(level), show)
  end
end

#==============================================================================
# ** Window_CheatEdit
#------------------------------------------------------------------------------
#  This window is used to edit the cheat on the cheat input screen.
# (reused the name edit window for this and recoded a few lines for the
# cheat engine)
#==============================================================================

class Window_CheatEdit < Window_Base

  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------

  attr_reader   :name                     # name
  attr_reader   :index                    # cursor position
  attr_reader   :max_char                 # maximum number of characters

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------

  def initialize(cheat, max_char)
    x = (Graphics.width - 360) / 2
    y = (Graphics.height - (fitting_height(4) + fitting_height(9) + 8)) / 2
    super(x, y, 360, fitting_height(4))
    @max_char = max_char
    @max_char += SAR::Game_Cheat::MAX_CHAR_INCREASE
    @default_name = @name = SAR::Game_Cheat::CHEATS[1][:cheat]
    @index = SAR::Game_Cheat::CHEATS[1][:size]
    deactivate
    refresh
  end

  #--------------------------------------------------------------------------
  # * Revert to Default Name
  #--------------------------------------------------------------------------
  
  def restore_default
    @name = @default_name
    @index = @name.size
    refresh
    return !@name.empty?
  end

  #--------------------------------------------------------------------------
  # * Add Text Character
  #     ch : character to add
  #--------------------------------------------------------------------------

  def add(ch)
    return false if @index >= @max_char
    @name += ch
    @index += 1
    refresh
    return true
  end

  #--------------------------------------------------------------------------
  # * Go Back One Character
  #--------------------------------------------------------------------------

  def back
    return false if @index == 0
    @index -= 1
    @name = @name[0, @index]
    refresh
    return true
  end

  #--------------------------------------------------------------------------
  # * Get Width of Face Graphic
  #--------------------------------------------------------------------------

  def face_width
    return 96
  end

  #--------------------------------------------------------------------------
  # * Get Character Width
  #--------------------------------------------------------------------------

  def char_width
    text_size($game_system.japanese? ? "B0" : "A").width 
  end

  #--------------------------------------------------------------------------
  # * Get Coordinates of Left Side for Drawing Name
  #--------------------------------------------------------------------------

  def left
    name_center = (contents_width) / 2
    name_width = (@max_char + 1) * char_width
    return [name_center - name_width / 2, contents_width - name_width].min
  end

  #--------------------------------------------------------------------------
  # * Get Rectangle for Displaying Item
  #--------------------------------------------------------------------------

  def item_rect(index)
    Rect.new(left + index * char_width, 36, char_width, line_height)
  end

  #--------------------------------------------------------------------------
  # * Get Underline Rectangle
  #--------------------------------------------------------------------------

  def underline_rect(index)
    rect = item_rect(index)
    rect.x += 1
    rect.y += rect.height - 4
    rect.width -= 2
    rect.height = 2
    rect
  end

  #--------------------------------------------------------------------------
  # * Get Underline Color
  #--------------------------------------------------------------------------

  def underline_color
    color = normal_color
    color.alpha = 48
    color
  end

  #--------------------------------------------------------------------------
  # * Draw Underline
  #--------------------------------------------------------------------------

  def draw_underline(index)
    contents.fill_rect(underline_rect(index), underline_color)
  end

  #--------------------------------------------------------------------------
  # * Draw Text
  #--------------------------------------------------------------------------

  def draw_char(index)
    rect = item_rect(index)
    rect.x -= 1
    rect.width += 4
    change_color(normal_color)
    draw_text(rect, @name[index] || "")
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------

  def refresh
    contents.clear
    @max_char.times {|i| draw_underline(i) }
    @name.size.times {|i| draw_char(i) }
    cursor_rect.set(item_rect(@index))
  end
end

#==============================================================================
# ** Scene_Cheat
#------------------------------------------------------------------------------
#  This class performs cheat input screen processing.
#==============================================================================

class Scene_Cheat < Scene_MenuBase

  attr_reader :switch_id

  #--------------------------------------------------------------------------
  # * Prepare
  #--------------------------------------------------------------------------

  def prepare(cheat, max_char)
    @cheat = cheat
    @max_char = max_char
  end

  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------

  def start
    super
    @cheat = SAR::Game_Cheat::CHEATS[1][:cheat]
    @edit_window = Window_CheatEdit.new(@cheat, 10)
    @input_window = Window_NameInput.new(@edit_window)
    @input_window.set_handler(:ok, method(:on_input_ok))
  end

  #--------------------------------------------------------------------------
  # * Input [OK]
  # This is where most cheats get activated
  #--------------------------------------------------------------------------
  
  def on_input_ok
    SAR::Game_Cheat::CHEATS[1][:cheat] = @edit_window.name
    SAR::Game_Cheat::CHEATS[1][:size] = @edit_window.index
    
    #===========================================================================
    # Money Cheat
    #===========================================================================

    if SAR::Game_Cheat::CHEATS[1][:cheat] == (SAR::Game_Cheat::MONEY_CHEAT) && SAR::Game_Cheat::SWI_VAR_ONLY == false && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::MONEY_CHEAT)
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::CHEATS[1][:cheat]
      end
      print SAR::Game_Cheat::CHEATS[1][:cheat_once]
      $game_party.gain_gold(SAR::Game_Cheat::MONEY)
    end

    #===========================================================================
    # Level cheat
    #===========================================================================

    if SAR::Game_Cheat::CHEATS[1][:cheat] == (SAR::Game_Cheat::LEVEL_CHEAT) && SAR::Game_Cheat::SWI_VAR_ONLY == false &&  !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::LEVEL_CHEAT)
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::LEVEL_CHEAT
      end
      for i in 0...$data_actors.size
          actor = $game_actors[i]
          next if actor.nil?
          if SAR::Game_Cheat::LEVEL_CHEAT_TYPE == 1
          actor.level_up2
        elsif SAR::Game_Cheat::LEVEL_CHEAT_TYPE == 2
          actor.change_level(SAR::Game_Cheat::LEVEL, SAR::Game_Cheat::LEVELDIS)
        end
      end
    end

    #===========================================================================
    # Switch list cheat on
    #===========================================================================

    if SAR::Game_Cheat::CHEATS[1][:cheat] == (SAR::Game_Cheat::SWITCH.gsub(/ %d/, '')) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::SWITCH.gsub(/ %d/, ''))
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::CHEATS[1][:cheat]
      end
      for i in SAR::Game_Cheat::SWITCHES
        $game_switches[i] = true
      end
    end

    #===========================================================================
    # Single switch cheat on
    #===========================================================================

    if SAR::Game_Cheat::CHEATS[1][:cheat] == (sprintf(SAR::Game_Cheat::SWITCH, $game_variables[SAR::Game_Cheat::SWITCH_ID])) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::CHEATS[1][:cheat])
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::CHEATS[1][:cheat]
      end
      j = $game_variables[SAR::Game_Cheat::SWITCH_ID]
      $game_switches[j] = true
    end
    
    #===========================================================================
    # Switch list cheat off
    #===========================================================================

    if SAR::Game_Cheat::CHEATS[1][:cheat] == (SAR::Game_Cheat::SWITCH2.gsub(/ %d/, '')) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::SWITCH2.gsub(/ %d/, ''))
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::SWITCH2.gsub(/ %d/, '')
      end
      for i in SAR::Game_Cheat::SWITCHES
      $game_switches[i] = false
    end
  end

  #=============================================================================
  # Single switch cheat off
  #=============================================================================

   if SAR::Game_Cheat::CHEATS[1][:cheat] == (sprintf(SAR::Game_Cheat::SWITCH2, $game_variables[SAR::Game_Cheat::SWITCH_ID])) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::CHEATS[1][:cheat])
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::CHEATS[1][:cheat]
      end
    j = $game_variables[SAR::Game_Cheat::SWITCH_ID]
    $game_switches[j] = false
  end

    #==========================================================================
    # Variable list cheat increase
    #==========================================================================
    
   if SAR::Game_Cheat::CHEATS[1][:cheat] == (SAR::Game_Cheat::VARIABLE.gsub(/ %d/, '')) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::VARIABLE.gsub(/ %d/, ''))
     if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::VARIABLE.gsub(/ %d/, '')
      end
    for i in SAR::Game_Cheat::VARIABLES
      $game_variables[i] += SAR::Game_Cheat::VARIABLE_INCREASE_AMOUNT
    end
  end

  #=============================================================================
  # Single variable cheat increase
  #=============================================================================

  if SAR::Game_Cheat::CHEATS[1][:cheat] == (sprintf(SAR::Game_Cheat::VARIABLE, $game_variables[SAR::Game_Cheat::VARIABLE_ID])) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::CHEATS[1][:cheat])
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::CHEATS[1][:cheat]
      end
    j = $game_variables[SAR::Game_Cheat::VARIABLE_ID]
    $game_variables[j] += SAR::Game_Cheat::VARIABLE_INCREASE_AMOUNT
  end

    #===========================================================================
    # Variable list cheat decrease
    #===========================================================================

  if SAR::Game_Cheat::CHEATS[1][:cheat] == (SAR::Game_Cheat::VARIABLE2.gsub(/ %d/, '')) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::VARIABLE2.gsub(/ %d/, ''))
     if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::VARIABLE2.gsub(/ %d/, '')
      end
    for i in SAR::Game_Cheat::VARIABLES
      $game_variables[i] -= SAR::Game_Cheat::VARIABLE_DECREASE_AMOUNT
    end
  end

  #=============================================================================
  # Single variable cheat decrease
  #=============================================================================

  if SAR::Game_Cheat::CHEATS[1][:cheat] == (sprintf(SAR::Game_Cheat::VARIABLE2, $game_variables[SAR::Game_Cheat::VARIABLE_ID])) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::CHEATS[1][:cheat])
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::CHEATS[1][:cheat]
      end
    j = $game_variables[SAR::Game_Cheat::VARIABLE_ID]
    $game_variables[j] -= SAR::Game_Cheat::VARIABLE_DECREASE_AMOUNT
  end

  #=============================================================================
  # Custom_Cheat
  #=============================================================================

  if SAR::Game_Cheat::CHEATS[1][:cheat] == ($game_variables[SAR::Game_Cheat::CUSTOM_CHEAT].to_s) && !SAR::Game_Cheat::CHEATS[1][:cheat_once].include?(SAR::Game_Cheat::CHEATS[1][:cheat])
      if SAR::Game_Cheat::CHEAT_ONCE == true
        SAR::Game_Cheat::CHEATS[1][:cheat_once].push SAR::Game_Cheat::CHEATS[1][:cheat]
      end
      
    #---------------------------------------------------------------------------
    # switch on/off
    #---------------------------------------------------------------------------
    
    if $game_switches[SAR::Game_Cheat::CUSTOM_CHEAT_OPTIONS] == true
      i = $game_variables[SAR::Game_Cheat::CUSTOM_CHEAT_ID]
      $game_switches[i] = true
    else
      i = $game_variables[SAR::Game_Cheat::CUSTOM_CHEAT_ID]
      if $game_switches[SAR::Game_Cheat::CUSTOM_CHEAT_UP_DOWN] == true
      $game_variables[i] += 1
    else
      $game_variables[i] -= 1
    end
  end
end
#===============================================================================
# Return scene
#===============================================================================
    return_scene
  end
end

#===============================================================================
# Scene Menu
#===============================================================================

class Scene_Menu < Scene_MenuBase
  #============================================================================
  # return cheat to starting state
  #============================================================================

  alias sar_command_game_end command_game_end

  def command_game_end
    sar_command_game_end
    SAR::Game_Cheat::CHEATS[1][:cheat] = ''
    SAR::Game_Cheat::CHEATS[1][:size] = 0
    SAR::Game_Cheat::CHEATS[1][:cheat_once].clear
  end
end
