#==============================================================================
# Built-in Class Extension's by Sarlecc
# V1.9.5
#
# String methods
# "".remove_every(n, d) n = number, d = divsion (optional)
# "".add_every(chars, n, d) chars = characters
# "".rand_chars
# "".mix_up
#
# Array methods
# [].mean
# [].median
# [].range
# [].search(num, num2) num2 is optional
#
# The following two methods return the id with the lowest or highest value in the given range
# both num1 and num2 are optional if omitted or values are to high then it will use 0 and the size of the array
# [].lowest(num1, num2)
# [].highest(num1, num2) 
#
# Math method
# Math.prime?(num)
# Math.prime2?(num)
# Math.prime2? is on average 2.5 times faster than Math.prime? if the number is prime; 
# otherwise it is around 16-353 times slower
# its recommended that you use Math.prime? for checking thousands of numbers at a time as Math.prime2? 
# will give an error (I assume that it has to do with the multithreading and attempting to do the next 
# number while still doing the previous number).
# use Math.prime2? for checking larger primes
# Math.prime? time for number 18987964267331664557:
# 4521.762485 seconds
# Math.prime2? time for number 18987964267331664557:
# 1922.888493 seconds
# Math.prime? time for 106573388391:
# 0.000027-0.000028 seconds
# Math.prime2? time for 106573388391:
# 0.000452-0.009907 seconds
#==============================================================================

module SAR
 module Char_Set
 
  CHAR_SET = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
    's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B',
    'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
    'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
    'W', 'X', 'Y', 'Z', ',', '<', '>', '.', '/', '?',
    '\'', '\"', ';', ':', '[', ']', '{', '}', '\\', '|',
    '~', '\`', '!', '@', '#', '$', '%', '^', '&', '*', '(',
    ')', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', ' '
    ]
 end
end

module Math
  #Thanks to bgillisp for a thought on making it much faster
  def self.prime?(arg)
    f = arg.to_i
    if f < 263882790666230
      i = 2
    while i <= Math.sqrt(f).ceil
       if f % (i) === 0 && f != (i)
         return false
       end
       if i.even?
       i += 1
       else
         i += 2
       end
      end
      if i > Math.sqrt(f).ceil && f != 0 && f != 1
        return true
      end
     else
     puts "Error: Number must be below 263882790666230 to help prevent long processing times"
     end
   end
   
   def self.prime2?(arg)
     if arg > 1 && !arg.even?
       n1 = 2
       n2 = Math.sqrt(arg).ceil
       p = true
       threads = []
       threads << t1 = Thread.new do
           while n1 <= n2 && p != false
           if arg % n1 === 0
             p = false
             break
           end
           if n1.even?
             n1 += 1
           else
             n1 += 2
           end
          end
          t1.kill
         end
        threads << t2 = Thread.new do
           while n2 > n1 && p != false
           if arg % n2 === 0
             p = false
             break
           end
           if n2.even?
             n2 -= 1
           else
             n2 -= 2
           end
           end
           t2.kill
         end
         threads.each {|thr| thr.join}
       if p == true
         return true
       else
         return false
       end
     elsif arg == 2
       return true
     else
       return false
     end
   end
   
end


class String
  def remove_every(z, dvi = 0)
    zs = z
    if dvi && dvi > 1
      dvis = dvi
    else
      dvis = 2
    end
    s = ""
    self.each_char {|i|
    if zs % dvis === 0
    s << i
    end
    zs += 1
   }
   return s
  end
 
  def add_every(chars, z, dvi = 0)
    zs = z
    if dvi && dvi > 1
      dvis = dvi
    else
      dvis = 2
    end
    s = ""
    self.each_char {|i|
    if zs % dvis === 0
    s << chars
    end
    s << i
    zs += 1
   }
   return s
  end
 
  def rand_chars
    s = ""
    self.each_char {|c|
     s << SAR::Char_Set::CHAR_SET.sample }
     return s
  end

  def mix_up
    s = ""
    a = []
    self.each_char {|c|
      a.push c}
    self.each_char {|c|
       s << d = a.sample
       a.delete_at(a.index(d))
    }
    return s
  end
 
end

class Array
  def mean
    m = 0
    self.each {|i|
    m += i}
    m /= self.size
    return m
  end
 
  def median
    m = 0
    i = 0
    u = self.sort
    if self.size % 2 === 0
     m = u[self.size / 2].round
     i = u[self.size / 2 + 1].round
     m = (m + i) / 2
   else
     m = u[self.size / 2].round
   end
   return m
 end
 
 def range
   u = self.sort
   m = 0
   m = u[self.size - 1] - u[0]
   return m
 end

 def search(find, find2 = "")
   a = []
   self.each {|i|
     if find == i || find2 == i
       a.push i
     end
    }
    a.push a.size
    return a
 end

def lowest(arg1 = 0, arg2 = self.size)  
   a = []
   if arg1 > self.size
     arg1 = 0
   end
   if arg2 > self.size
     arg2 = self.size
   end
   self[arg1..arg2].each {|i|
    a << i 
   }
    a.sort!
    (arg1..arg2).each {|i|
      if self[i] == a.first
        return i
      end
    }
   end
   
   
   def highest(arg1 = 0, arg2 = self.size)
     a = []
   if arg1 > self.size
     arg1 = 0
   end
   if arg2 > self.size
     arg2 = self.size
   end
   self[arg1..arg2].each {|i|
    a << i 
   }
    a.sort!
    (arg1..arg2).each {|i|
      if self[i] == a.last
        return i
      end
    }
   end
  
 
end
