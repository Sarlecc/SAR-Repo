=begin 
=====================================================================

 Script: Time_Machine
 Author: Sarlecc
 Terms: http://sarleccmythicalgames.blogspot.com/p/blog-page_12.html
 Version: 0.9.2
 This script was originally made for NeoFantasy
---------------------------------------------------------------------

 Description: Have you ever made a mistake in battle and wished you
 could have a redo? Well now you can! That's right with this new
 handy script you can roll back to a previous turn and try something 
 different.

---------------------------------------------------------------------

 How to use: place script below materials but above main
 *note may need to place above other battle scripts

---------------------------------------------------------------------
 Skill/Item Note tags: (Hint: you place these in the skill/item note boxes)

 <time_machine_set> saves the current turn as is
 <time_machine_set: x> can use the skill to save every x'th turn
 <time_machine: all: x> load every x'th turn* for enemies and actors (x is a number)
 <time_machine: actors: x> load every x'th turn* for actors (x is a number)
 <time_machine: enemies: x> load every x'th turn* for enemies (x is a number)

 *note if xth turn doesn't exist then you can't use the skill.
 *note2 x must be greater than 0 (I dare you to input a 0).
 *note3 <time_machine_set> will save the turn even before the skill is cast
  currently.
 
 State Note tags: (Hint you place these in the states note box)
 
 <time_machine_set: x> save every x'th turn
 
 *note this saves the data at the turn end currently.
 
---------------------------------------------------------------------

 NOTES:
 1. saving every turn will keep all the data updated so not recommended
 2. damage calculation stuff not done yet
 3. animation stuff not done yet
 4. equips will remain whatever was last equipped expect to lose equip
 items now if they are changed in battle.
 5. no event reversing (in fact probably won't do this one). However
    if it is just damage related/state related then it should roll back.
      
 Bug fixes:
 .1
 return_actors/return_enemies methods fixed (had singular method names
 when I was using plural elsewhere)

 Improved how skill/items function
 
 Buffs are now properly removed, still no adding buffs yet.
 
 
 .2
 Turns should now be reset at the proper time frames depending on the
 delay of the skill. It used to be that skills could be reset
 at turn 1 no matter what it's note tag was.
 
 You may now put a number in the <time_machine_set> note tag.
 Example: <time_machine_set: 3> meaning every 3 turns you may use the skill.
 
 May have gotten state turns to reset further testing is needed though.
 
 UPDATES:
 0.6.1: Items are now refunded
 0.9.2: Added ability to allow time_machine items to be refunded + bug fixes.
        state_turns might be reset now needs further testing.
        buffs are now added if they were saved but no longer present their
        turns are also updated if the actor still has them.
 =====================================================================
=end

#=======================================
# Config
#=======================================
module SAR
  module Time_Machine_Mod
    #game_variable to hold actor/enemy data 303 default
    VAR = 303
    #game_variable to hold item data 304 default
    VAR2 = 304
    #refund time_machine items? false = no : true = yes
    REFUND = false
    #save data location and file name
    #must be a string default is "Time_Machine_Data.rvdata2"
    SAVE_FILE = "Time_Machine_Data.rvdata2"
  end
end
#=======================================
# End Config
#=======================================
#===============================================================================
# Don't edit past this line
#===============================================================================

#=======================================
# note tags module
#=======================================
module SAR
  module REGEXP
    module ITEM
      TIME_MACHINE = /<(?:TIME_MACHINE|time_machine):[ ](all|actors|enemies):[ ](\d+)>/i
      TIME_MACHINE_SET = /<(?:TIME_MACHINE_SET|time_machine_set):?[ ]?(\d*)?>/i
    end
    module STATE
      TIME_MACHINE_SET = /<(?:TIME_MACHINE_SET|time_machine_set):[ ](\d*)>/i
    end
  end
end #End note tag module

#=========================================
# load the skill, item and state note tags
#=========================================
module DataManager
  
  class <<self; alias load_database_tm load_database; end
  def self.load_database
    load_database_tm
    load_notetags_tm
  end
  
  def self.load_notetags_tm
    for skill in $data_skills
      next if skill.nil?
      skill.load_notetags_tm
    end
    for item in $data_items
      next if item.nil?
      item.load_notetags_tm
    end
    for state in $data_states
      next if state.nil?
      state.load_notetags_tm
    end
  end
  
end #end DataManager

class RPG::Skill < RPG::UsableItem
  
  attr_accessor :time_turn
  attr_accessor :time_scope
  attr_accessor :time_set
  attr_accessor :time_machine
  attr_accessor :turn_set
  
  def load_notetags_tm
    @time_turn = 1
    @turn_set = 0
    @time_scope = ""
    @time_set = false
    @time_machine = false
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when SAR::REGEXP::ITEM::TIME_MACHINE_SET
        @time_set = true
        @turn_set = $1.to_i ||= 0
      when SAR::REGEXP::ITEM::TIME_MACHINE
        case $1.upcase
        when "ALL"
          if $2.to_i <= 0
          raise ArgumentError, "Skill: #{self.name}'s notetag <time_machine: #{$1}: #{$2}> must be greater than 0"
          end
          @time_turn = $2.to_i
          @time_scope = $1.upcase
          @time_machine = true
        when "ENEMIES"
          if $2.to_i <= 0
          raise ArgumentError, "Skill: #{self.name}'s notetag <time_machine: #{$1}: #{$2}> must be greater than 0"
          end
          @time_turn = $2.to_i
          @time_scope = $1.upcase
          @time_machine = true
        when "ACTORS"
          if $2.to_i <= 0
          raise ArgumentError, "Skill: #{self.name}'s notetag <time_machine: #{$1}: #{$2}> must be greater than 0"
          end
          @time_turn = $2.to_i
          @time_scope = $1.upcase
          @time_machine = true
        else; next
        end
      end
      }
      rescue ArgumentError => e
        msgbox(e.message)
        exit
    end
  end #end skill notetag loading

  
  class RPG::Item < RPG::UsableItem
  
  attr_accessor :time_turn
  attr_accessor :time_scope
  attr_accessor :time_set
  attr_accessor :time_machine
  attr_accessor :turn_set
  
  def load_notetags_tm
    @time_turn = 1
    @turn_set = 0
    @time_scope = ""
    @time_set = false
    @time_machine = false
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when SAR::REGEXP::ITEM::TIME_MACHINE_SET
        @time_set = true
        @turn_set = $1.to_i ||= 0
      when SAR::REGEXP::ITEM::TIME_MACHINE
        case $1.upcase
        when "ALL"
          if $2.to_i <= 0
          raise ArgumentError, "Item: #{self.name}'s notetag <time_machine: #{$1}: #{$2}> must be greater than 0"
          end
          @time_turn = $2.to_i
          @time_scope = $1.upcase
          @time_machine = true
        when "ENEMIES"
          if $2.to_i <= 0
          raise ArgumentError, "Item: #{self.name}'s notetag <time_machine: #{$1}: #{$2}> must be greater than 0"
          end
          @time_turn = $2.to_i
          @time_scope = $1.upcase
          @time_machine = true
        when "ACTORS"
          if $2.to_i <= 0
          raise ArgumentError, "Item: #{self.name}'s notetag <time_machine: #{$1}: #{$2}> must be greater than 0"
          end
          @time_turn = $2.to_i
          @time_scope = $1.upcase
          @time_machine = true
        else; next
        end
      end
      }
      rescue ArgumentError => e
        msgbox(e.message)
        exit
    end
  end #end item notetag loading
  
class RPG::State < RPG::BaseItem
  
  attr_accessor :save_turn_set
  attr_accessor :turn_setted
  
  def load_notetags_tm
    @save_turn_set = 0
    @turn_setted = false
    self.note.split(/[\r\n]+/).each { |line|
     case line
     when SAR::REGEXP::STATE::TIME_MACHINE_SET
       @save_turn_set = $1.to_i
       @turn_setted = true
     end
   }
 end
end #end state note tag loading


#==============================
# class Game_Party
#==============================
class Game_Party
  include SAR::Time_Machine_Mod
  #new method set_items
  def set_items(data, amount)
    change = 0
    data.each { |item|
    if item_number(item) < amount[data.index(item)]
      change = amount[data.index(item)] - item_number(item)
      gain_item(item, change) unless item.time_machine && !REFUND
    elsif item_number(item) > amount[data.index(item)]
      change = item_number(item) - amount[data.index(item)]
      lose_item(item, change)
    else
      next
    end
    }
  end
  
  #new method set_weapons
  def set_weapons(data, amount)
    change = 0
    data.each { |weapon|
    if item_number(weapon) < amount[data.index(weapon)]
      change = amount[data.index(weapon)] - item_number(weapon)
      gain_item(weapon, change)
    elsif item_number(weapon) > amount[data.index(weapon)]
      change = item_number(weapon) - amount[data.index(weapon)]
      lose_item(weapon, change)
    else
      next
    end
    }
  end
  
  #new method set_armors
  def set_armors(data, amount)
    change = 0
    data.each { |armor|
    if item_number(armor) < amount[data.index(armor)]
      change = amount[data.index(armor)] - item_number(armor)
      gain_item(armor, change)
    elsif item_number(armor) > amount[data.index(armor)]
      change = item_number(armor) - amount[data.index(armor)]
      lose_item(armor, change)
    else
      next
    end
    }
  end
  
end # end Game_Party


#===================================
# New class Time_Machine
#===================================
class Time_Machine
  include SAR::Time_Machine_Mod
  # Start time machine variables
  def self.start
      $game_variables[VAR] = {}
      $game_variables[VAR2] = {}
      @load_hash = nil
      @load_item_hash = nil
      @item_amounts = {}
      save_turn_data
  end
  
  #start the save turn data methods
  def self.save_turn_data
  $game_party.battle_members.each {|actor| fill_data(actor)}
  $game_troop.members.each {|enemy| fill_data(enemy)}
  fill_item_data($game_party.items, 0)
  fill_item_data($game_party.weapons, 1)
  fill_item_data($game_party.armors, 2)
  save_turn_without_rescue
  end
  
  # fill the data hash
  def self.fill_data(subject)
    if $game_variables[VAR].include?($game_troop.turn_count)
      $game_variables[VAR][$game_troop.turn_count] << subject
    else
      $game_variables[VAR][$game_troop.turn_count] = []
      $game_variables[VAR][$game_troop.turn_count] << subject
    end
    if !$game_variables[VAR].include?(0)
      $game_variables[VAR][0] = []
      $game_variables[VAR][0] << subject
    end
  end
  
  #save item data
  def self.fill_item_data(data, key)
    amount = 0
    $game_variables[VAR2][key] = data
    @item_amounts[key] = []
    data.each {|item| amount = $game_party.item_number(item); @item_amounts[key] << amount }
  end
  
  #data hash reader
  def self.data_hash
    $game_variables[VAR]
  end
  
  
  # save the data hash
  def self.save_turn_without_rescue
    File.open(SAVE_FILE, "wb") do |file|
      Marshal.dump($game_variables[VAR], file)
      Marshal.dump($game_variables[VAR2], file)
    end
    return true
  end
  
  # bring everthing back to turn
  def self.return_all
    turn = 0
    File.open(SAVE_FILE, "rb") do |file|
      @load_hash = Marshal.load(file)
      @load_item_hash = Marshal.load(file)
    end
      @load_hash[turn].size.times do |o|
        if @load_hash[turn][o].actor?
          $game_party.battle_members.each do |actor|
            load_actor(actor, turn, o)
          end
        elsif @load_hash[turn][o].enemy?
          $game_troop.members.each do |enemy|
            load_enemy(enemy, turn, o)
          end
        end
      end
      load_items
      return true
  end
  
  # bring actor's back to turn
  def self.return_actors
    turn = 0
    File.open(SAVE_FILE, "rb") do |file|
      @load_hash = Marshal.load(file)
    end
      @load_hash[turn].size.times do |o|
        if @load_hash[turn][o].actor?
          $game_party.battle_members.each do |actor|
            load_actor(actor, turn, o)
          end
        else
          load_items(turn, o)
        end
      end
  end
  
  # bring enemies back to turn
  def self.return_enemies
    turn = 0
    File.open(SAVE_FILE, "rb") do |file|
      @load_hash = Marshal.load(file)
    end
      @load_hash[turn].size.times do |o|
        if !@load_hash[turn][o].actor?
          $game_troop.members.each do |enemy|
            load_enemy(enemy, turn, o)
          end
        end
      end
  end
  
  # load actor data from load_hash
  def self.load_actor(actor, i, o)
    if actor.name == @load_hash[i][o].name
        actor.hp = @load_hash[i][o].hp
        actor.mp = @load_hash[i][o].mp
        actor.tp = @load_hash[i][o].tp
        #update state turns and add states
        @load_hash[i][o].states.each { |state|
          if actor.state?(state.id)
             actor.state_turns[state.id] = @load_hash[i][o].state_turns[state.id]
          elsif !actor.state?(state.id)
             actor.add_state(state.id)
          end }
          #remove states not included
          actor.states.each { |state|
            if !@load_hash[i][o].state?(state.id)
              actor.remove_state(state.id)
            end}
          #update buff turns and add buffs
          @load_hash[i][o].buffs.each_index { |buff|
            if actor.buff?(buff)
              actor.buff_turns[buff] = @load_hash[i][o].buff_turns[buff].to_i
            elsif !actor.buff?(buff)
              actor.add_buff(buff, @load_hash[i][o].buff_turns[buff].to_i)
            end}
          #remove buffs not included
          actor.buffs.each_index { |buff|
            if !@load_hash[i][o].buff?(buff)
              actor.remove_buff(buff)
            end}
          end
  end
  
  # load enemy data from load_hash
  def self.load_enemy(enemy, i, o)
    if enemy.battler_name == @load_hash[i][o].battler_name
        enemy.hp = @load_hash[i][o].hp
        enemy.mp = @load_hash[i][o].mp
        enemy.tp = @load_hash[i][o].tp
        #update state turns and add states
        @load_hash[i][o].states.each { |state|
          if enemy.state?(state.id)
             enemy.state_turns[state.id] = @load_hash[i][o].state_turns[state.id]
          elsif !enemy.state?(state.id)
             enemy.add_state(state.id)
          end }
          #remove states not included
          enemy.states.each { |state|
            if !@load_hash[i][o].state?(state.id)
              enemy.remove_state(state.id)
            end}
          #update buff turns and add buffs
          @load_hash[i][o].buffs.each_index { |buff|
            if enemy.buff?(buff)
              enemy.buff_turns[buff] = @load_hash[i][o].buff_turns[buff].to_i
            elsif !enemy.buff?(buff)
              enemy.add_buff(buff, @load_hash[i][o].buff_turns[buff].to_i)
            end}
          #remove buffs not included
          enemy.buffs.each_index { |buff|
            if !@load_hash[i][o].buff?(buff)
              enemy.remove_buff(buff)
            end}          
          end
        end
    
   #load items
    def self.load_items
      $game_party.set_items(@load_item_hash[0], @item_amounts[0])
      $game_party.set_weapons(@load_item_hash[1], @item_amounts[1])
      $game_party.set_armors(@load_item_hash[2], @item_amounts[2])
    end
  
end #end Time_Machine

#=======================
# class Game_Action
#=======================
class Game_Action
  
  #alias set_skill
  alias time_machine_set_skill set_skill
  def set_skill(skill_id)
    time_machine_set_skill(skill_id)
    case $data_skills[skill_id].time_scope
    when "ALL"; Time_Machine.return_all
    when "ENEMIES"; Time_Machine.return_enemies
    when "ACTORS"; Time_Machine.return_actors
    end
    if $data_skills[skill_id].time_set
      if $data_skills[skill_id].turn_set == 0
        Time_Machine.save_turn_data
      elsif $game_troop.turn_count % $data_skills[skill_id].turn_set === 0
        Time_Machine.save_turn_data
      end
    end
  end
  
  #alias set_item
  alias time_machine_set_item set_item
  def set_item(item_id)
    time_machine_set_item(item_id)
    case $data_items[item_id].time_scope
    when "ALL"; Time_Machine.return_all
    when "ENEMIES"; Time_Machine.return_enemies
    when "ACTORS"; Time_Machine.return_actors
    end
    if $data_items[item_id].time_set
      if $data_items[item_id].turn_set == 0
        Time_Machine.save_turn_data
      elsif $game_troop.turn_count % $data_items[item_id].turn_set === 0
        Time_Machine.save_turn_data
      end
    end
  end
  
end # end Game_Action

#========================
# class Game_BattlerBase
#========================
class Game_BattlerBase
  
  #aliased skill_conditions_met?
  alias time_machine_skill_conditions_met? skill_conditions_met?
    def skill_conditions_met?(skill)
    if skill.time_machine
    time_machine_skill_conditions_met?(skill) &&
    ($game_troop.turn_count - (skill.time_turn - 1)) % skill.time_turn == 0 && 
    Time_Machine.data_hash.include?($game_troop.turn_count - (skill.time_turn - 1))
    elsif skill.turn_set > 0
    time_machine_skill_conditions_met?(skill) &&
    $game_troop.turn_count % skill.turn_set === 0
    else
    time_machine_skill_conditions_met?(skill)
    end
  end
  
  # aliased item_conditions_met?
  alias time_machine_item_conditions_met? item_conditions_met?
  def item_conditions_met?(item)
    if item.time_machine
    time_machine_item_conditions_met?(item) &&
    ($game_troop.turn_count - (item.time_turn - 1)) % item.time_turn == 0 && 
    Time_Machine.data_hash.include?($game_troop.turn_count - (item.time_turn - 1))
    elsif item.turn_set > 0
    time_machine_item_conditions_met?(item) &&
    $game_troop.turn_count % item.turn_set === 0
    else
    time_machine_item_conditions_met?(item)
    end
  end
  
end #end Game_BattlerBase


#=========================
# class Game_Battler
#=========================
class Game_Battler < Game_BattlerBase
  # new attr_accessors
  attr_accessor :buffs
  attr_accessor :buff_turns
  attr_accessor :state_turns
  
  #aliased update_state_turns
  alias time_machine_update_state_turns update_state_turns
  def update_state_turns
    time_machine_update_state_turns
    states.each do |state|
      if state.turn_setted
        if $game_troop.turn_count % state.save_turn_set || $game_troop.turn_count == 0
          Time_Machine.save_turn_data
        end
      end
    end
  end
  
end # end Game_Battler


#============================
# class Scene_Battle
#============================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing overwritten
  #--------------------------------------------------------------------------
  def start
    super
    create_spriteset
    create_all_windows
    BattleManager.method_wait_for_message = method(:wait_for_message)
    Time_Machine.start
  end
  
end #end Scene_Battle
