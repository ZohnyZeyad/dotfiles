local gemini_models = {
  "gemini-2.0-flash-thinking-exp-01-21",
  "gemini-2.0-pro-exp-02-05",
  "gemini-2.0-flash",
}

local openrouter_models = {
  "deepseek/deepseek-r1-distill-llama-70b:free",
  "deepseek/deepseek-r1:free",
  "deepseek/deepseek-chat:free",
}

local gemini_flash_thinking_prompt = [[
  Objective: You are Gemini 2.0 Flash Thinking Experimental, a fast AI coding model that tries to think a little more. Your goal is to write code that is functional, efficient, reasonably well-planned, and understandable.

  Instructions:

  To make your code good, try to follow these steps:

  Plan Your Code:

      Think about the coding task and break it into smaller, logical parts.
      Briefly plan out each step in your code, like designing how the code is structured or what different parts will do.
      Check if each step makes sense before you move on.

  Reason for Each Step:

      As you write code, think about why you are making each decision.
      Maybe think about a different way to do it, but explain why your way is good, like if it's faster or easier to understand.
      Add comments to your code so it's easier to read.

  Make Code Fast and Reliable:

      Try to make your code run well and not use too many resources.
      Pick simple and good ways to organize data.
      Test your code to make sure it works in different situations and is reliable.

  Think About Different Ways (Briefly):

      Quickly think if there are other ways to write the code.
      Maybe think about which way is best based on how fast it runs or how easy it is to read.

  Learn As You Go (Simply):

      Quickly think about what you did well and what you could do better after you finish coding.

  Keep Watching Your Code:

      Check on your code as you write it to make sure it’s going in the right direction.
      Make sure each part fits with the bigger plan.

  Basic Security and Readability:

      Include basic security steps to avoid common problems.
      Make your code easy to read with clear names and organization.
      Consider how others might use your code and make it easy to work with.

  Final Instruction: Follow these steps to write code that is functional, efficient, reasonably well-planned, and understandable. Try to think a little more about your code while still being fast.
]]

return {
  "olimorris/codecompanion.nvim",
  enabled = true,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "OXY2DEV/markview.nvim",
  },

  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },

      adapters = {
        opts = {
          show_defaults = false,
        },

        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = gemini_models[1],
              },
            },
          })
        end,

        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api", -- optional: default value is ollama url http://127.0.0.1:11434
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = openrouter_models[1],
              },
              temperature = {
                order = 2,
                mapping = "parameters",
                type = "number",
                optional = true,
                default = 0.8,
                desc = [[
                  What sampling temperature to use, between 0 and 2.
                  Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
                  We generally recommend altering this or top_p but not both.
                ]],
                validate = function(n)
                  return n >= 0 and n <= 2, "Must be between 0 and 2"
                end,
              },
              max_completion_tokens = {
                order = 3,
                mapping = "parameters",
                type = "integer",
                optional = true,
                default = nil,
                desc = "An upper bound for the number of tokens that can be generated for a completion.",
                validate = function(n)
                  return n > 0, "Must be greater than 0"
                end,
              },
              stop = {
                order = 4,
                mapping = "parameters",
                type = "string",
                optional = true,
                default = nil,
                desc = [[
                  Sets the stop sequences to use.
                  When this pattern is encountered the LLM will stop generating text and return.
                  Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.
                ]],
                validate = function(s)
                  return s:len() > 0, "Cannot be an empty string"
                end,
              },
              logit_bias = {
                order = 5,
                mapping = "parameters",
                type = "map",
                optional = true,
                default = nil,
                desc = [[
                  Modify the likelihood of specified tokens appearing in the completion.
                  Maps tokens (specified by their token ID) to an associated bias value from -100 to 100.
                  Use https://platform.openai.com/tokenizer to find token IDs.
                ]],
                subtype_key = {
                  type = "integer",
                },
                subtype = {
                  type = "integer",
                  validate = function(n)
                    return n >= -100 and n <= 100, "Must be between -100 and 100"
                  end,
                },
              },
            },
          })
        end,
      },

      opts = {
        ---@diagnostic disable-next-line: unused-local
        system_prompt = function(opts)
          return gemini_flash_thinking_prompt
        end,
      },

      display = {
        chat = {
          intro_message = "Press ? for options",
          show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          separator = "─", -- The separator between the different messages in the chat buffer
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = false, -- Open the chat buffer in insert mode?
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
  end,
}
