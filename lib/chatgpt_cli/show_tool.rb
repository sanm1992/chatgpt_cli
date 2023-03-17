module ChatgptCli
  class ShowTool
    attr_reader :toolchain
    
    def initialize(toolchain)
      @toolchain = toolchain
    end
    
    def show(content)
      send("show_by_#{toolchain}", content)
    end

    def check_toolchain_installed
      return [true] if toolchain == 'default'

      system("#{toolchain} --version > /dev/null 2>&1")
      return [true] if $?.success?

      [false, "#{toolchain} 未安装\n请执行 brew install #{toolchain} 来安装 #{toolchain}\n"]
    end

    private

    def show_by_default(content)
      content&.each_char do |c|
        print c
        $stdout.flush
        sleep 0.05
      end
    end

    def show_by_vim(content)
      system("vim #{new_tempfile(content)}")
    end
    
    def show_by_vscode(content)
      vscode = IO.popen('code -', 'w')
      vscode.puts content
      vscode.close_write
    end
    
    def show_by_mdcat(content)
      system("mdcat #{new_tempfile(content)}")
    end
  end
end