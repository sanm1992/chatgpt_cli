# frozen_string_literal: true

require 'json'

require_relative 'chatgpt_cli/version'
require_relative 'chatgpt_cli/cli'
require_relative 'chatgpt_cli/chatgpt'
require_relative 'chatgpt_cli/show_tool'

module ChatgptCli
  class Error < StandardError; end

  class << self
    def exec
      cli = ChatgptCli::CLI.new
      cli.exec do |content|
        show_tool = ChatgptCli::ShowTool.new('default')
        tool_ready, error = show_tool.check_toolchain_installed
        cli.quit!(error) unless tool_ready

        chatgpt_ai = ChatgptCli::Chatgpt.new
        ai_ready, error = chatgpt_ai.fetch_dependences
        cli.quit!(error) unless ai_ready

        success, messages = chatgpt_ai.completion(content)
        success ? show_tool.show(messages) : cli.error(messages)
      end
    end
  end
end
