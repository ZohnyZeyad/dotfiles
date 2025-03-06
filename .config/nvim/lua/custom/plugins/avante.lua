local openrouter_models = {
  "deepseek/deepseek-r1-distill-llama-70b:free",
  "deepseek/deepseek-r1:free",
  "deepseek/deepseek-chat:free",
  "google/gemini-2.0-pro-exp-02-05:free",
  "google/gemini-2.0-flash-thinking-exp:free",
}

local gemini_models = { ---@see https://ai.google.dev/gemini-api/docs/models/gemini
  "gemini-2.0-flash-thinking-exp-01-21",
  "gemini-2.0-pro-exp-02-05",
  "gemini-2.0-flash",
  "gemini-1.5-pro",
  "gemini-1.5-flash",
}

---@diagnostic disable-next-line: unused-function, unused-local
local function parse_curl_args(opts, code_opts)
  local messages = require("avante.providers.openai").parse_messages(code_opts)
  return {
    url = opts.endpoint .. "/chat/completions",
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
      stream = true,
    },
  }
end

---@diagnostic disable-next-line: unused-function, unused-local
local function parse_response(data_stream, event_state, opts)
  ---@diagnostic disable-next-line: missing-parameter
  require("avante.providers.openai").parse_response(data_stream, event_state, opts)
end

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

    cursor_applying_provider = 'gemini',
    -- cursor_applying_provider = 'openrouter',

    rag_service = {
      enabled = false, -- Enables the rag service, requires OPENAI_API_KEY to be set
    },

    vendors = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = openrouter_models[1],
        timeout = 30000,
        temperature = 0.2,
        max_tokens = 8192,
        disable_tools = true,
        -- parse_curl_args = parse_curl_args
        -- parse_response = parse_response -- Used if the vendors has specific SSE spec that is not claude or openai.
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
      model = gemini_models[2],
      timeout = 30000,
      temperature = 0.2,
      max_tokens = 8192,
    },

    dual_boost = {
      enabled = false,
      first_provider = "gemini",
      second_provider = "openrouter",
      prompt = [[
        Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective.
        Do not provide any explanation, just give the response directly.
        Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]
      ]],
      timeout = 60000, -- Timeout in milliseconds
    },

    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,                -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true,        -- Whether to enable token counting. Default to true.
      enable_cursor_planning_mode = false, -- enable cursor planning mode!
    },
  },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- The dependencies below are optional,
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
