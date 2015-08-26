#============================================================================
# Sarlecc's Auto/System save files with YEA save extension
# Ease of use - Easy
# Date created - 11/12/2014
# Version 1.0.1
#============================================================================
#============================================================================
# Credits:
# Sarlecc for Auto save and System files
#
# Yanfly if you are using his save script 
# http://yanflychannel.wordpress.com/terms-of-use/
#
# 
# 
#----------------------------------------------------------------------------
#
# Requirements - none though fully supports Yanfly's save system
#----------------------------------------------------------------------------
#
# Directions - Place this script under Materials (and under Yanfly's save system
# if you are using) and above Main.
#
# Script calls:
# i is the index number you want it to use
# DataManager.save_settings(i)
# DataManager.auto_save(i)
# DataManager.load_settings(i) By default load_settings gets called when you
# start a new game. But only if USE_SYSTEM_FILE is set to true.
#
# Custom stuff below.
#==============================================================================
#
# Known issues:
# None
# 
#==============================================================================
#
# *Update* version 1.0.1
# - You can now use a key from the map to call auto save
#   and have an optional message displayed.
# - Fixed the Yanfly file list index number when using this script.
#   Note it assumes that the system file will be using index 0 or the last index.
#   I decided to do it this way because just getting it to work with different
#   auto save indexs was rather complex.
# As always you can customize just about every option for these new features.
#============================================================================== 

module SAR
  module YEASAVEPLUS
    #========================================================================
    # Index for auto save - Now is being used for key pressed auto saving
    #========================================================================
    AUTO_INDEX = 1
    #========================================================================
    # The following is only if you are using Yanfly's save system script
    # and will not affect any other save system. *Note I placed the system
    # options below this comment because it should only be used with the
    # Yanfly's save system though some of it will change the file you want as
    # system file* 
    #------------------------------------------------------------------------
    #========================================================================
    # Index for system file
    #========================================================================
    SYSTEM_INDEX = 0
    #========================================================================
    # Use system file? true or false
    # Use auto save? true or false
    # These are only for shutting out save/load/delete access for system file
    # or save access for auto save from the menu. Also used to return the file
    # name to default if not in use.
    #
    # *NOTE* Be careful with the system file as it doesn't save every thing just
    # some variables as defined below. I reccomend that if you are going to use
    # it use Yanfly's save system script and set USE_SYSTEM_FILE to true.
    #========================================================================
    USE_SYSTEM_FILE = false
    USE_AUTO_FILE = true
    #========================================================================
    # Names of the system and auto save files
    #========================================================================
    SYSTEM = "System"
    AUTO_SAVE = "Auto Save"
    #========================================================================
    # variables displayed in the system save header
    #========================================================================
    SYSTEM_DISPLAYED_VARIABLES = [86, 87, 88, 90]
    SYSTEM_DISPLAYED_VARIABLES2 = [89]
    #========================================================================
    # variables to be saved in the system file
    #========================================================================
    SYSTEM_SAVED_VARIABLES = [86, 87, 88, 90, 89]
    #========================================================================
    # switches to be saved in the system file
    #========================================================================
    SYSTEM_SAVED_SWITCHES = [90, 91, 92]
    #========================================================================
    #  Following is if you want to use a key to call auto save to
    #  AUTO_INDEX*
    #  Also allows you to display a message after you press said button
    #
    #  *AUTO_INDEX is the save slot that is being saved too
    #========================================================================
    USE_KEY_AUTOSAVE = true
    #========================================================================
    # key to press
    # :X = A key, :Y = S key, :Z = D key by default these keys are not used
    # however other scripts may use them.
    #========================================================================
    KEY = :X
    #========================================================================
    # use message when key above is pressed: true or false
    #========================================================================
    USE_KEY_MESSAGE = true
    #========================================================================
    # Message to be displayed
    #========================================================================
    DISPLAYED_KEY_MESSAGE = "Auto Save successful"
  end
end

#==============================================================================
# EDIT PAST THIS POINT AT YOUR OWN RISK
#==============================================================================
module DataManager
  
  def self.setup_new_game
    create_game_objects
    if SAR::YEASAVEPLUS::USE_SYSTEM_FILE
    DataManager.load_settings(SAR::YEASAVEPLUS::SYSTEM_INDEX)
    end
    $game_party.setup_starting_members
    $game_map.setup($data_system.start_map_id)
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    $game_player.refresh
    Graphics.frame_count = 0
  end

def self.save_settings(index)
    begin
      save_system_without_rescue(index)
    rescue
      delete_save_file(index)
      false
    end
  end
  
  def self.auto_save(index)
    begin
      save_game_without_rescue(index)
    rescue
      delete_save_file(index)
      false
    end
  end
  
  def self.save_system_without_rescue(index)
    File.open(make_filename(index), "wb") do |file|
      $game_system.on_before_save
      Marshal.dump(make_save_header, file)
      Marshal.dump($game_system, file)
      for var_id in SAR::YEASAVEPLUS::SYSTEM_SAVED_VARIABLES
          Marshal.dump($game_variables[var_id], file)
        end
      for swi_id in SAR::YEASAVEPLUS::SYSTEM_SAVED_SWITCHES
        Marshal.dump($game_switches[swi_id], file)
      end
    end
    return true
  end
  
  def self.load_settings(index)
    load_settings_without_rescue(index) rescue false
  end

def self.load_settings_without_rescue(index)
    File.open(make_filename(index), "rb") do |file|
      Marshal.load(file)
      $game_system        = (Marshal.load(file))
      for var_id in SAR::YEASAVEPLUS::SYSTEM_SAVED_VARIABLES
          $game_variables[var_id] = (Marshal.load(file))
        end
      for swi_id in SAR::YEASAVEPLUS::SYSTEM_SAVED_SWITCHES
          $game_switches[swi_id] = (Marshal.load(file))
        end
      reload_map_if_updated
      @last_savefile_index = index
    end
    return true
  end
  
end

class Scene_Map < Scene_Base
  
  def update_scene
    check_gameover
    update_transfer_player unless scene_changing?
    update_encounter unless scene_changing?
    update_call_menu unless scene_changing?
    update_call_debug unless scene_changing?
    if SAR::YEASAVEPLUS::USE_KEY_AUTOSAVE
    update_auto_save unless scene_changing?
    end
  end
  
  
    def update_auto_save
      if Input.trigger?(SAR::YEASAVEPLUS::KEY)
        DataManager.auto_save(SAR::YEASAVEPLUS::AUTO_INDEX)
        if SAR::YEASAVEPLUS::USE_KEY_MESSAGE
          $game_message.add(sprintf(SAR::YEASAVEPLUS::DISPLAYED_KEY_MESSAGE))
        end
      end
    end
    
  end

if $imported["YEA-SaveEngine"]
  
  class Window_FileList < Window_Selectable
    
    def initialize(dx, dy)
    super(dx, dy, 128, Graphics.height - dy)
    refresh
    activate
    select(SceneManager.scene.first_savefile_index + 1)
  end
    
    def draw_item(index)
    header = DataManager.load_header(index)
    if index == SAR::YEASAVEPLUS::SYSTEM_INDEX && SAR::YEASAVEPLUS::USE_SYSTEM_FILE
      enabled = false
    else
    enabled = !header.nil?
    end
    rect = item_rect(index)
    rect.width -= 4
    draw_icon(save_icon?(header), rect.x, rect.y, enabled)
    change_color(normal_color, enabled)
    if index == SAR::YEASAVEPLUS::SYSTEM_INDEX && SAR::YEASAVEPLUS::USE_SYSTEM_FILE
      text = sprintf(SAR::YEASAVEPLUS::SYSTEM, "")
    elsif index == SAR::YEASAVEPLUS::AUTO_INDEX && SAR::YEASAVEPLUS::USE_AUTO_FILE
      text = sprintf(SAR::YEASAVEPLUS::AUTO_SAVE, (index).group)
    elsif SAR::YEASAVEPLUS::USE_AUTO_FILE && SAR::YEASAVEPLUS::AUTO_INDEX >0 && index >= 0 + SAR::YEASAVEPLUS::AUTO_INDEX
      text = sprintf(YEA::SAVE::SLOT_NAME, (((index).group).to_i - 1).to_s)
    else
    text = sprintf(YEA::SAVE::SLOT_NAME, (index).group)
    end
    draw_text(rect.x+24, rect.y, rect.width-24, line_height, text)
  end
end

class Window_FileStatus < Window_Base
  
  def draw_system_slot(dx, dy, dw)
    reset_font_settings
    change_color(system_color)
    text = sprintf(SAR::YEASAVEPLUS::SYSTEM, "")
    draw_text(dx, dy, dw, line_height, text)
    cx = text_size(text).width
    change_color(normal_color)
    draw_text(dx+cx, dy, dw-cx, line_height, "")
  end
  
  def draw_auto_slot(dx, dy, dw)
    reset_font_settings
    change_color(system_color)
    text = sprintf(SAR::YEASAVEPLUS::AUTO_SAVE, "")
    draw_text(dx, dy, dw, line_height, text)
    cx = text_size(text).width
    change_color(normal_color)
    draw_text(dx+cx, dy, dw-cx, line_height, "")
  end
  
  
  def draw_system_column(dx, dy, dw)
    data = SAR::YEASAVEPLUS::SYSTEM_DISPLAYED_VARIABLES
    draw_column_data(data, dx, dy, dw)
  end
  
  def draw_system_column2(dx, dy, dw)
    data = SAR::YEASAVEPLUS::SYSTEM_DISPLAYED_VARIABLES2
    draw_column_data(data, dx, dy, dw)
  end

  def draw_save_contents
    if @current_index == SAR::YEASAVEPLUS::SYSTEM_INDEX && SAR::YEASAVEPLUS::USE_SYSTEM_FILE
      draw_system_slot(4, 0, contents.width/2-8)
      draw_system_column(16, line_height*1.5, contents.width/2-48)
      draw_system_column2(contents.width/2+16, line_height*1.5, contents.width/2-48)
    elsif @current_index == SAR::YEASAVEPLUS::AUTO_INDEX && SAR::YEASAVEPLUS::USE_AUTO_FILE
      draw_auto_slot(4, 0, contents.width/2-8)
      draw_save_playtime(contents.width/2+4, 0, contents.width/2-8)
      draw_save_total_saves(4, line_height, contents.width/2-8)
      draw_save_gold(contents.width/2+4, line_height, contents.width/2-8)
      draw_save_location(4, line_height*2, contents.width-8)
      draw_save_characters(0, line_height*5 + line_height/3)
      draw_save_column1(16, line_height*7, contents.width/2-48)
      draw_save_column2(contents.width/2+16, line_height*7, contents.width/2-48)
    else
      draw_save_slot(4, 0, contents.width/2-8)
      draw_save_playtime(contents.width/2+4, 0, contents.width/2-8)
      draw_save_total_saves(4, line_height, contents.width/2-8)
      draw_save_gold(contents.width/2+4, line_height, contents.width/2-8)
      draw_save_location(4, line_height*2, contents.width-8)
      draw_save_characters(0, line_height*5 + line_height/3)
      draw_save_column1(16, line_height*7, contents.width/2-48)
      draw_save_column2(contents.width/2+16, line_height*7, contents.width/2-48)
    end
  end
end

class Window_FileAction < Window_HorzCommand
  
  def load_enabled?
    return false if @header.nil?
    return false if @current_index == SAR::YEASAVEPLUS::SYSTEM_INDEX && SAR::YEASAVEPLUS::USE_SYSTEM_FILE
    return true
  end
  
  def save_enabled?
    return false if @header.nil? && SceneManager.scene_is?(Scene_Load)
    return false if SceneManager.scene_is?(Scene_Load)
    return false if $game_system.save_disabled
    return false if @current_index == SAR::YEASAVEPLUS::SYSTEM_INDEX && SAR::YEASAVEPLUS::USE_SYSTEM_FILE
    return false if @current_index == SAR::YEASAVEPLUS::AUTO_INDEX && SAR::YEASAVEPLUS::USE_AUTO_FILE
    return true
  end
  
  def delete_enabled?
    return false if @header.nil?
    return false if @current_index == SAR::YEASAVEPLUS::SYSTEM_INDEX && SAR::YEASAVEPLUS::USE_SYSTEM_FILE
    return true
  end
end

end
