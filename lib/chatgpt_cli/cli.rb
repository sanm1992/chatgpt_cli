require 'readline'
require_relative 'string'

module ChatgptCli
  class CLI
    EXIT = 'exit'
    QUIT = 'quit'
    EXEC = '.'
    CLEAR = 'clear'
    NEXT = 'next'

    SUPPORTED_INSTRUCTION = [EXIT, QUIT, EXEC, CLEAR, NEXT]

    def initialize
      @line_index = 0
      @instruction = ''
      @search_content = []
      @collback = nil
    end

    def exec(&block)
      self.collback = block

      welcome

      loop do
        get_instruction

        handler_instruction
      end
    end

    def quit!(message = nil)
      out(message.to_s.red) unless message.nil? || message.empty?

      exit(1)
    end

    private

    attr_accessor :line_index, :instruction, :search_content, :collback

    def welcome
      puts "#{start_tag}=================================="
      puts "#{start_tag}  Welcome to My ChatGpt CLI!"
      puts "#{start_tag}  输入想要搜索的内容，用`.`提交查询"
      puts "#{start_tag}=================================="
      puts "#{start_tag}"
    end

    def start_tag
      "chatgpt:#{self.line_index += 1}> "
    end

    def get_instruction
      input = Readline.readline(start_tag, true)

      input = input.chomp.empty? ? NEXT : input

      SUPPORTED_INSTRUCTION.include?(input.chomp) ? self.instruction = input.chomp : self.search_content << input
    end

    def handler_instruction
      quit! if quit?
      exec! && clear! && stand_by! if exec?
      clear! if clear?
    end

    def quit?
      [EXIT, QUIT].include?(instruction)
    end

    def exec?
      instruction == EXEC
    end

    def exec!
      if search_content.empty?
        out '请输入想要搜索的信息'.red
        return true
      end

      out "正在为你查找 #{search_content.join('')} 的答案"
      begin
        collback&.call(search_content.join(''))
        puts "\n"
      rescue => ex
        out ex.message
      end
      true
    end

    def clear?
      instruction == CLEAR
    end

    def clear!
      self.search_content = []
    end

    def stand_by!
      self.instruction = ''
    end

    def out(str)
      print start_tag

      str.to_s.each_char do |c|
        print c
        $stdout.flush
        sleep 0.05
      end

      puts "\n"
    end
  end
end