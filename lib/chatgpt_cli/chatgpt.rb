
require 'net/http'
require 'uri'
require 'json'

module ChatgptCli
  class Chatgpt
    CHATGPT_OPENAI_URL = 'https://api.openai.com/v1/chat/completions'
    CHATGPT_OPENAI_MODEL = 'gpt-3.5-turbo'
    CHATGPT_OPENAI_ROLE = 'user'

    def fetch_dependences
      self.openai_key = ENV.fetch('CHATGPT_OPENAI_KEY', nil)
      self.openai_organization = ENV.fetch('CHATGPT_OPENAI_ORGANIZATION', nil)

      error = "请通过 export CHATGPT_OPENAI_KEY=yourOpenaiKey设置ChatGPT OpenAi秘钥\n" if self.openai_key.nil?
      error = "#{error}请通过export CHATGPT_OPENAI_ORGANIZATION=yourOpenAIOrganization设置ChatGPT OpenAi秘钥所属组织\n" if self.openai_organization.nil?

      [error.nil?, error]
    end

    def completion(content)
      params = { model: CHATGPT_OPENAI_MODEL, messages: [{ role: CHATGPT_OPENAI_ROLE, content: content }] }
      headers = { 'Authorization': "Bearer #{self.openai_key}", 'content-type': 'application/json', 'OpenAI-Organization': self.openai_organization }
      res = Net::HTTP.post(URI(CHATGPT_OPENAI_URL), params.to_json, headers)
      body = JSON.parse res.body
      messages = body.dig('error', 'message') || body&.[]('choices')&.first&.dig('message', 'content')

      [res.code.to_i.eql?(200), messages]
    end

    private

    attr_accessor :openai_key, :openai_organization
  end
end
