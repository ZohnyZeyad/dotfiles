return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  build = "make",

  opts = {
    hints = { enabled = false },

    file_selector = {
      provider = "telescope", -- "native" | "fzf" | "telescope" | string
      -- Options override for custom providers
      provider_opts = {},
    },

    provider = "gemini", -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    -- provider = "openrouter",

    vendors = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        -- model = "google/gemini-2.0-flash-thinking-exp:free",
        -- model = "google/gemini-2.0-pro-exp-02-05:free",
        -- model = "deepseek/deepseek-r1-distill-llama-70b:free",
        -- model = "deepseek/deepseek-r1:free",
        model = "deepseek/deepseek-chat:free",
        timeout = 30000,
        temperature = 0,
        max_tokens = 8192,
        disable_tools = true,
        -- parse_curl_args = function(opts, code_opts)
        --   local messages = require("avante.providers.openai").parse_messages(code_opts)
        --   return {
        --     url = opts.endpoint .. "/chat/completions",
        --     headers = {
        --       ["Content-Type"] = "application/json",
        --       ["Authorization"] = "Bearer " .. os.getenv(opts.api_key_name),
        --     },
        --     insecure = true,
        --     body = {
        --       model = opts.model,
        --       messages = messages,
        --       temperature = 0,
        --       max_tokens = 8192,
        --       stream = true, -- this will be set by default.
        --     },
        --   }
        -- end,
        -- The below function is used if the vendors has specific SSE spec that is not claude or openai.
        -- parse_response = function(data_stream, event_state, opts)
        --   require("avante.providers.openai").parse_response(data_stream, event_state, opts)
        -- end,
      },
    },

    openai = {
      endpoint = "https://openrouter.ai/api/v1",
      model = "o1-mini",
      timeout = 30000,
      temperature = 0,
      max_tokens = 8192,
    },

    gemini = {
      -- @see https://ai.google.dev/gemini-api/docs/models/gemini
      model = "gemini-2.0-flash-thinking-exp-01-21",
      -- model = "gemini-2.0-pro-exp-02-05",
      -- model = "gemini-2.0-flash",
      -- model = "gemini-1.5-pro",
      -- model = "gemini-1.5-flash",
      timeout = 30000,
      temperature = 0,
      max_tokens = 8192,
    },

    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,         -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true, -- Whether to enable token counting. Default to true.
    },
  },

  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "OXY2DEV/markview.nvim",       -- or MeanderingProgrammer/render-markdown.nvim

    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      enabled = false,
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}
