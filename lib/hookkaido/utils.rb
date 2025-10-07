# frozen_string_literal: true
def make_user_agent
  requa = "Faraday/v" + Faraday::VERSION
  habua = "Hookkaido/v" + Hookkaido::VERSION
  ua = "#{requa} #{habua}"
  ua += " (mailto:%s)" % Hookkaido.mailto if Hookkaido.mailto
  ua
end

class Hash
  def tosymbols
    map { |(k, v)| [k.to_sym, v] }.to_h
  end
end
