class String
  COLORS = {
    black: "\e[30m",
    red: "\e[31m",
    green: "\e[32m",
    yellow: "\e[33m",
    blue: "\e[34m",
    magenta: "\e[35m",
    cyan: "\e[36m",
    white: "\e[37m"
  }

  COLORS.keys.each do |color|
    define_method color do
      "#{COLORS[color.to_sym]}#{self}\e[0m"
    end
  end
end

