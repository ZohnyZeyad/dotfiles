return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  -- enabled = false,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    file_selector = {
      --- @alias FileSelectorProvider "native" | "fzf" | "telescope" | string
      provider = "telescope",
      -- Options override for custom providers
      provider_opts = {},
    },
    ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    provider = "gemini",
    -- provider = "openrouter",
    vendors = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api',
        api_key_name = 'OPENROUTER_API_KEY',
        -- model = "deepseek/deepseek-r1:free",
        model = "deepseek/deepseek-r1-distill-llama-70b:free",
        parse_curl_args = function(opts, code_opts)
          --[[ local messages = {}
          local first_msg = { role = "system", content = code_opts.system_prompt }
          table.insert(messages, first_msg)
          if code_opts.messages then
            table.insert(messages, require("avante.providers.openai").parse_messages(code_opts))
            --[[ local content = ""
                for idx, msg in ipairs(code_opts.) do
                  if content == "" then
                    content = content .. msg.content
                  else
                    content = content .. "\n" .. msg.content
                  end
                end
                local next_msg = { role = "user", content = content }
                table.insert(messages, next_msg) ]]
          local messages = require("avante.providers.openai").parse_messages(code_opts)
          return {
            url = opts.endpoint .. "/v1/chat/completions",
            headers = {
              ["Content-Type"] = "application/json",
              ["Authorization"] = "Bearer " .. os.getenv(opts.api_key_name),
            },
            insecure = true,
            body = {
              model = opts.model,
              messages = messages,
              temperature = 0,
              max_tokens = 8192,
              stream = true, -- this will be set by default.
            },
          }
        end,
        -- The below function is used if the vendors has specific SSE spec that is not claude or openai.
        parse_response = function(data_stream, event_state, opts)
          require("avante.providers.openai").parse_response(data_stream, event_state, opts)
        end,
      },
    },
    openai = {
      endpoint = "https://openrouter.ai/api/v1",
      model = "o1-mini",
      temperature = 0,
      max_tokens = 4096,
    },
    gemini = {
      -- @see https://ai.google.dev/gemini-api/docs/models/gemini
      model = "gemini-2.0-flash-001",
      -- model = "gemini-1.5-flash",
      temperature = 0,
      max_tokens = 4096,
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
    hints = { enabled = false },
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
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
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "Avante" },
      },
      ft = { "Avante" },
    },
  },
}
