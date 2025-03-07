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

local function gemini_adapter(idx)
  return require("codecompanion.adapters").extend("gemini", {
    schema = {
      model = {
        default = gemini_models[idx],
      },
      temperature = { default = 0.2 },
      maxOutputTokens = { default = 8192 },
    },
  })
end

local function openrouter_adapter(idx)
  return require("codecompanion.adapters").extend("openai_compatible", {
    env = {
      url = "https://openrouter.ai/api",
      api_key = "OPENROUTER_API_KEY",
      chat_url = "/v1/chat/completions",
    },
    schema = {
      model = {
        default = openrouter_models[idx],
      },
      temperature = { default = 0.2 },
      maxOutputTokens = { default = 8192 },
    },
  })
end

local gemini_flash_thinking_prompt = require("custom.codecompanion.prompts.gemini_flash_thinking")
local gemini_pro_prompt = require("custom.codecompanion.prompts.gemini_pro")
local gemini_flash_prompt = require("custom.codecompanion.prompts.gemini_flash")
local deepseek_r1_prompt = require("custom.codecompanion.prompts.deepseek_r1")
local fake_thinking_prompt = require("custom.codecompanion.prompts.fake_thinking")

local prompt_map = {
  [gemini_models[1]] = gemini_flash_thinking_prompt,
  [gemini_models[2]] = gemini_pro_prompt,
  [gemini_models[3]] = gemini_flash_prompt,
  [openrouter_models[1]] = deepseek_r1_prompt,
}

local function get_system_prompt(opts)
  -- Check if opts and adapter are provided and not nil
  if not opts or not opts.adapter or not opts.adapter.schema.model.default then
    print("Warning: Invalid opts. Using generic prompt.")
    return fake_thinking_prompt
  end

  -- Lookup prompt module from prompt_map
  local model_name = opts.adapter.schema.model.default
  print(model_name)
  local prompt_module = prompt_map[model_name]
  if prompt_module then
    return prompt_module
  else
    print("No specific system prompt found for model: " .. model_name .. ". Using generic prompt.")
    return fake_thinking_prompt
  end
end

return {
  "olimorris/codecompanion.nvim",
  enabled = true,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- "OXY2DEV/markview.nvim",
    'MeanderingProgrammer/render-markdown.nvim',
  },

  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini_flash_thinking",
          roles = {
            ---The header name for the LLM's messages
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapter)
              return "CodeCompanion (" .. adapter.formatted_name .. ")"
            end,

            ---The header name for your messages
            ---@type string
            user = "User",
          }
        },
        inline = { adapter = "gemini_flash_thinking", },
        agent = { adapter = "gemini_pro", },
      },

      adapters = {
        opts = { show_defaults = false, },

        gemini_flash_thinking = gemini_adapter(1),
        gemini_pro = gemini_adapter(2),
        gemini_flash = gemini_adapter(3),
        openrouter = openrouter_adapter(1),
      },

      opts = {
        system_prompt = function(opts)
          return get_system_prompt(opts)
        end
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

          debug_window = {
            ---@return number|fun(): number
            width = math.floor(vim.o.columns * 0.8),
            ---@return number|fun(): number
            height = math.floor(vim.o.lines * 0.8),
          },

          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
            position = nil,      -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
            border = "single",
            height = 0.8,
            width = 0.35,
            relative = "editor",
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },

        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>cca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "v" }, "<leader>ce", ":CodeCompanion<space>", { noremap = true })

    -- Integrate with fidget.nvim
    require("custom.codecompanion.fidget").setup_fidget()
  end,
}
