#!/usr/bin/env ruby
#email : w.zongyu@gmail.com

require 'openssl'
require 'optparse'

class PollarExp
  def initialize(n, b=2)
    @N = n.to_i #number to be factorized
    @B = b.to_i #bound #step1
    @K = findk #step2
    @A = finda #step3
  end

  def exploit
    until !comgcd.nil? do
      @B += 1
      @K = findk
      @A = finda
    end
    p, q = comgcd, @N/comgcd
    p, q = q, p  if p < q
    return p, q
  end

private
  #step 2
  def findk 
    k = 1
    (2..@B).each do |q|
      k *= (q ** (Math.log(@B, q).floor))
    end
    return k
  end

  #step 3
  def finda 
    a = 2
    return a
  end

  #step 4
  def comgcd
    g = ((@A).to_bn.mod_exp(@K, @N).to_i-1).gcd(@N)
    return (g>1 && g<@N) ? g : nil
  end
end

class ARGVParser
  def initialize
    @@options = {b: 2}
    @banner = "Usage pollar.rb [options]"
    OptionParser.new do |opts|
      opts.banner = @banner

      opts.on("-n N", "Value to factor") do |v|
        options[:n] = v
      end

      opts.on("-b B", "Base value (optional)") do |v|
        options[:b]
      end

    end.parse!
    exit if sanitycheck == false
  end

  def sanitycheck
    if @@options[:n].nil?
      puts "#{@banner} #-h for help"
      return false
    end
  end

  def options
    @@options
  end
end

opts = ARGVParser.new.options
p, q =PollarExp.new(opts[:n].to_i, opts[:b].to_i).exploit
puts "p = #{p}"
puts "q = #{q}"
