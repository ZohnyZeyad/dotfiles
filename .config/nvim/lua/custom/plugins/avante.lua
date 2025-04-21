local openrouter_models = { ---@see https://openrouter.ai/models
  "deepseek/deepseek-chat-v3-0324:free",
  "agentica-org/deepcoder-14b-preview:free",
  "google/gemini-2.5-pro-exp-03-25:free",
  "deepseek/deepseek-r1-zero:free",
  "deepseek/deepseek-r1-distill-llama-70b:free",
  "google/gemini-2.0-flash-thinking-exp:free",
  "qwen/qwen-2.5-coder-32b-instruct:free",
}

local gemini_models = { ---@see https://ai.google.dev/gemini-api/docs/models/gemini
  "gemini-2.0-flash",
  "gemini-2.5-flash-preview-04-17",
  "gemini-2.5-pro-preview-03-25",
  "gemini-2.5-pro-exp-03-25",
  "gemini-2.0-flash-thinking-exp-01-21",
  "gemini-1.5-pro",
}

local gemini_flash_thinking_prompt = require("custom.codecompanion.prompts.gemini_flash_thinking")
local gemini_pro_prompt = require("custom.codecompanion.prompts.gemini_pro")
local gemini_flash_prompt = require("custom.codecompanion.prompts.gemini_flash")
local deepseek_prompt = require("custom.codecompanion.prompts.deepseek")
local fake_thinking_prompt = require("custom.codecompanion.prompts.fake_thinking")

local prompt_map = {
  [gemini_models[1]] = gemini_flash_thinking_prompt,
  [gemini_models[2]] = gemini_flash_thinking_prompt,
  [gemini_models[3]] = gemini_pro_prompt,
  [gemini_models[4]] = gemini_pro_prompt,
  [gemini_models[5]] = gemini_flash_prompt,
  [openrouter_models[1]] = deepseek_prompt,
  [openrouter_models[3]] = gemini_pro_prompt,
}

local gemini_model = gemini_models[1]

---@diagnostic disable-next-line: unused-function, unused-local
local function get_system_prompt(model_name)
  local prompt_module = prompt_map[model_name]
  if prompt_module then
    return prompt_module
  else
    print("No specific system prompt found for model: " .. model_name .. ". Using generic prompt.")
    return fake_thinking_prompt
  end
end

---@diagnostic disable-next-line: unused-function, unused-local
local function parse_curl_args(opts, code_opts)
  ---@diagnostic disable-next-line: missing-parameter
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

    selector = {
      provider = "telescope", -- "native" | "fzf" | "telescope" | "snacks" | string
      -- Options override for custom providers
      provider_opts = {
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
          }
        },
      },
    },

    provider = "gemini", -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    -- provider = "openrouter",

    web_search_engine = {
      provider = "google", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
    },

    cursor_applying_provider = 'gemini',
    -- cursor_applying_provider = 'openrouter',

    vendors = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = openrouter_models[3],
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
      model = gemini_model,
      timeout = 30000,
      temperature = 0.2,
      max_tokens = 8192,
      disable_tools = true,
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
      jump_result_buffer_on_finish = true,
      support_paste_from_clipboard = false,
      minimize_diff = true,                -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true,        -- Whether to enable token counting. Default to true.
      enable_cursor_planning_mode = false, -- enable cursor planning mode!
    },

    -- system_prompt = get_system_prompt(gemini_model),
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      if hub == nil then
        return get_system_prompt(gemini_model)
      else
        return hub:get_active_servers_prompt()
      end
    end,

    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
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
    -- 'MeanderingProgrammer/render-markdown.nvim',

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
