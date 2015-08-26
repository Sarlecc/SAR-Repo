#======================================================================
# Skill_Usage
# Author Sarlecc
# TERMS http://sarleccmythicalgames.blogspot.com/p/blog-page_12.html
# Version 1.5.2
#======================================================================
#
# Skill Usage script: Have you ever wantted to know precisely how many
# times your beta testers are using a skill? While now you can! As soon
# as a player uses a skill it will be put on the list and update the
# percentages of all skills listed. If a skill has been used before it's
# Times amount will be increased. Note that this won't tell you which of
# your actors uses a skill.
#
# Instructions paste script below Materials and above all other battle
# related scripts and above Main
#
# Script is mostly plug and play change the Variable id below if you are
# using it.
#
# Outputs to the console and to a .txt called Results.txt located in the
# Game folder in the following format:
#
# Skill               Times        Percent
# Attack:             3:           75.0%
# Cleave:             1:           25.0%  
#
# Note delete script when you are ready to release your game
#=======================================================================
module SAR
  module USAGE
    #----------------------------------------
    # VAR is a $game_variable
    # default = 300
    # The variable will be used to store
    # usage data before printing to the
    # console or writing the results file.
    #----------------------------------------
    VAR = 300
    
    #----------------------------------------
    # ROUND percents
    # default = 2
    #
    #  3 = 0.001
    #  2 = 0.01
    #  1 = 0.1
    #  0 = nearest 1
    # -1 = nearest 10th
    # -2 = nearest 100th
    #----------------------------------------
    ROUND = 2
  end
end
 
#=====================================================
# DO NOT CHANGE ANYTHING PAST THIS POINT
#=====================================================
 
class Skill_Usage
include SAR::USAGE
 
def initialize
  @b = 0
  if !$game_variables[VAR].is_a? Array
  $game_variables[VAR] = []
  end
end
 
 
 #fill the data array @t with actor_name, skill and amount of times used
def fill_data(actor_name, data_name)
  if $game_variables[VAR].empty?
    $game_variables[VAR].push([actor_name, [data_name, 1]])
    find_size
    return
  end
    $game_variables[VAR].size.times do |i|
      if $game_variables[VAR][i].include?(actor_name)
        $game_variables[VAR][i].size.times do |o|
          break if o + 1 == $game_variables[VAR][i].size
      if $game_variables[VAR][i][o + 1][0].include?(data_name)
        $game_variables[VAR][i][o + 1][1] += 1
        find_size(i)
        return
      end
    end
        $game_variables[VAR][i].push([data_name, 1])
        find_size(i)
        return
      end
    end
    $game_variables[VAR].push([actor_name, [data_name, 1]])  
  find_size($game_variables[VAR].size - 1)
end
 
#finds the size of the amount of times all skills are 
#used in the data array actor name dependant
def find_size(loc=0)
  $game_variables[VAR][loc].each_index {|i|
  break if i + 1 == $game_variables[VAR][loc].size
  @b += $game_variables[VAR][loc][i + 1][1]}
  collect_data(loc)
end

#collect the more data before posting and saving it
#also controls string formating algorithms 
def collect_data(loc)
    o = 0
  while o + $game_variables[VAR][loc][$game_variables[VAR][loc].size - 1][0].length <= 20
    o += 1
  end
  u = 0
  while u + $game_variables[VAR][loc][$game_variables[VAR][loc].size - 1][1].to_s.length <= 10
    u += 1
  end
  if $game_variables[VAR].size >= 1
       $game_variables[VAR][loc][$game_variables[VAR][loc].size - 1][2] = (((
       $game_variables[VAR][loc][$game_variables[VAR][loc].size - 1][1].to_f / @b) * 100).round(2)).to_s + "%"
       $game_variables[VAR][loc][$game_variables[VAR][loc].size - 1][3] = o
       $game_variables[VAR][loc][$game_variables[VAR][loc].size - 1][4] = u
     
       $game_variables[VAR][loc].size.times do |i|
        break if i + 1 == $game_variables[VAR][loc].size
       $game_variables[VAR][loc][i + 1][1] = $game_variables[VAR][loc][i + 1][1]
       $game_variables[VAR][loc][i + 1][2] = ((($game_variables[VAR][loc][i + 1][1].to_f / @b) * 100).round(ROUND)).to_s + "%"
  end
  end
  @b = 0
  post_data
  save_data
end
 
#post data to console 
def post_data
  $game_variables[VAR].size.times do |o|
    puts  "\nActor: " + $game_variables[VAR][o].first + "\n"
    print "\nSkill#{sprintf("%15s", "")}Times#{sprintf("%8s", "")}Percent\n"
    $game_variables[VAR][o].size.times do |i|
      break if i + 1 == $game_variables[VAR][o].size
      puts $game_variables[VAR][o][i + 1][0].to_s + 
      ":#{sprintf("%#{$game_variables[VAR][o][i + 1][3] - 2}s", "")}" + 
      $game_variables[VAR][o][i + 1][1].to_s + 
      ":#{sprintf("%#{$game_variables[VAR][o][i + 1][4] + 1}s", "")}" + 
      $game_variables[VAR][o][i + 1][2].to_s
    end
  end
end

 #save data to text file 
  def save_data
    open("Results.txt", "w") {|file| 
    $game_variables[VAR].size.times do |o|
    file.write("\nActor: " + $game_variables[VAR][o].first + "\n")
     file.write("Skill#{sprintf("%15s", "")}Times#{sprintf("%8s", "")}Percent\n")
      $game_variables[VAR][o].size.times do |i|
        break if i + 1 == $game_variables[VAR][o].size
      file.write($game_variables[VAR][o][i + 1][0].to_s + 
      ":#{sprintf("%#{$game_variables[VAR][o][i + 1][3] - 2}s", "")}" + 
      $game_variables[VAR][o][i + 1][1].to_s + 
      ":#{sprintf("%#{$game_variables[VAR][o][i + 1][4] + 1}s", "")}" + 
      $game_variables[VAR][o][i + 1][2].to_s + "\n")
    end
  end
       }
  end
end

#Scene Battle class
class Scene_Battle < Scene_Base
  #overwritten start
  def start
    super
    create_spriteset
    create_all_windows
    BattleManager.method_wait_for_message = method(:wait_for_message)
    @susage = Skill_Usage.new
  end
  
  #overwritten process_action
  def process_action
    return if scene_changing?
    if !@subject || !@subject.current_action
      @subject = BattleManager.next_subject
    end
    return turn_end unless @subject
    if @subject.current_action
      @subject.current_action.prepare
      if @subject.actor? && @subject.current_action.item.is_a?(RPG::Skill)
      @susage.fill_data(@subject.name, @subject.current_action.item.name)
      end
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
      @subject.remove_current_action
    end
    process_action_end unless @subject.current_action
  end
end
