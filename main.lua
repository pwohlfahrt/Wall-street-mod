SMODS.Atlas {
  key = "trader_joker_sprite",
  path = "trader_joker.png",
  px = 36,
  py = 47,
}

SMODS.Joker {
  key = "Trader",
  loc_txt = {
    name = "Trader",
    text = {
      "Sometimes market is bullish,",
      "sometimes bearish."
    }
  },

  atlas = "trader_joker_sprite",
  pos = {
    x = 0,
    y = 0
  },

  rarity = 2,
  cost = 5,

  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual then
      return {
        dollars = math.random(-40, 40)
      }
    end
  end
}

SMODS.Atlas {
  key = "s&p_sprite",
  path = "jokersmp.png",
  px = 36,
  py = 47,
}

SMODS.Joker {
  key = "S&P",
  loc_txt = {
    name = "S&P",
    text = {
      "Returns 10% of your net worth",
      "at the end of each round."
    }
  },

  atlas = "s&p_sprite",
  pos = {
    x = 0,
    y = 0
  },
  rarity = 1,
  cost = 3,

  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual then
      local net_worth = 0
      for _, card in ipairs(G.jokers.cards) do
        net_worth = net_worth + card.sell_cost
        print("card", card.key, card.sell_cost)
      end
      print("net worth", net_worth)
      for _, card in ipairs(G.consumeables.cards) do
        net_worth = net_worth + card.sell_cost
        print("card", card.key, card.sell_cost)
      end
      net_worth = net_worth + G.GAME.dollars
      print("net worth", net_worth)
      return {
        dollars = math.floor(net_worth * 0.1)
      }
    end
  end
}

SMODS.Atlas {
  key = "invest_in_ai_sprite",
  path = "ai_joker.png",
  px = 36,
  py = 47,
}

SMODS.Joker {
  key = "Invest_in_AI",
  loc_txt = {
    name = "Invest in AI",
    text = {
      "At beginning of each round,",
      "you must pay $10 to your AI overlords."
    },
  },

  atlas = "invest_in_ai_sprite",
  pos = {
    x = 0,
    y = 0
  },

  rarity = 3,
  cost = 0,
  calculate = function(self, card, context)
    if context.setting_blind and not context.repetition and not context.individual then
      return {
        dollars = -10
      }
    end
  end
}

SMODS.Atlas {
  key = "stock_sprite",
  path = "stock.png",
  px = 35,
  py = 47,
}

SMODS.Enhancement {
  key = "stock",
  loc_txt = {
    name = "Stock",
    text = {
      "Gives bonus chips to your card based on your wallet."
    }
  },

  atlas = "stock_sprite",
  pos = {
    x = 0,
    y = 0
  },
  
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.main_scoring then
      return {
        chips = math.floor(G.GAME.dollars / 10)
      }
    end
  end
}

SMODS.Atlas {
  key = "investor_tarot_sprite",
  path = "investor_tarot.png",
  px = 100,
  py = 150,
}

SMODS.Consumable {
  key = "Investor_Tarot",
  set = "Tarot",

  loc_txt = {
    name = "Investor Tarot",
    text = {
      "Gives bonus chips to your card based on your wallet."
    }
  },

  atlas = "investor_tarot_sprite",
  pos = {
    x = 0,
    y = 0
  },

  rarity = 1,
  cost = 3,
  can_use = function(self, card)
    return #G.hand.highlighted == 1
  end,

  use = function(self, card, area, copier)
    local target = G.hand.highlighted[1]

    target:set_ability(G.P_CENTERS.m_nwm_stock)
  end
}