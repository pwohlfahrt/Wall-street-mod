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

local function give_joker(key)
  if not G.jokers then
    return
  end

  local card = create_card(
    "S&P",
    G.jokers,
    nil,
    nil,
    nil,
    nil,
    key
  )

  card:add_to_deck()
  G.jokers:emplace(card)
end

local function give_consumable(key)
  local card = create_card(
    "investor_tarot",
    G.consumeables,
    nil,
    nil,
    nil,
    nil,
    key
  )

  card:add_to_deck()
  G.consumeables:emplace(card)
  print("gave consumable", card.key)
end


G.FUNCS.nwm_give_smp = function()
  give_joker("j_nwm_S&P")
end

G.FUNCS.nwm_give_trader = function()
  give_joker("j_nwm_Trader")
end

G.FUNCS.nwm_give_ai = function()
  give_joker("j_nwm_Invest_in_AI")
end

G.FUNCS.nwm_give_stock = function()
  print("giving stock tarot")
  for key, center in pairs(G.P_CENTERS) do
    if key:lower():find("stock") then
        print("FOUND:", key, center)
    end
end
  give_consumable("c_nwm_Investor_Tarot")
end

G.FUNCS.nwm_add_money = function()
  ease_dollars(10)
end


G.FUNCS.nwm_add_chips = function()
  if G.GAME then
    G.GAME.chips = (G.GAME.chips or 0) + 100
  end
end


G.FUNCS.nwm_close_menu = function()
  G.FUNCS.exit_overlay_menu()
end


local function create_dev_menu()
  return {
    n = G.UIT.ROOT,

    config = {
      align = "cm",
      colour = G.C.CLEAR
    },

    nodes = {

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.2
        },

        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = "DEV MENU",
              scale = 0.8,
              colour = G.C.WHITE
            }
          }
        }
      },

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.1
        },

        nodes = {
          UIBox_button({
            label = { "Give Trader Joker" },
            button = "nwm_give_trader"
          })
        }
      },

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.1
        },

        nodes = {
          UIBox_button({
            label = { "Give S&P Joker" },
            button = "nwm_give_smp"
          })
        }
      },

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.1
        },

        nodes = {
          UIBox_button({
            label = { "Give Invest in AI Joker" },
            button = "nwm_give_ai"
          })
        }
      },

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.1
        },

        nodes = {
          UIBox_button({
            label = { "Give Stock Tarot" },
            button = "nwm_give_stock"
          })
        }
      },

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.1
        },

        nodes = {
          UIBox_button({
            label = { "+$10" },
            button = "nwm_add_money"
          })
        }
      },

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.1
        },

        nodes = {
          UIBox_button({
            label = { "+100 Chips" },
            button = "nwm_add_chips"
          })
        }
      },

      {
        n = G.UIT.R,
        config = {
          align = "cm",
          padding = 0.1
        },

        nodes = {
          UIBox_button({
            label = { "Close" },
            button = "nwm_close_menu"
          })
        }
      }
    }
  }
end


G.FUNCS.nwm_open_menu = function()
  G.SETTINGS.paused = true

  G.FUNCS.overlay_menu({
    definition = create_dev_menu()
  })
end


local old_keypressed = love.keypressed

function love.keypressed(key, scancode, isrepeat)
  if key == "f2" then
    G.FUNCS.nwm_open_menu()
    return
  end

  if old_keypressed then
    old_keypressed(key, scancode, isrepeat)
  end
end
