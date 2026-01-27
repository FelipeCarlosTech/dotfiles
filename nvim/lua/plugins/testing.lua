-- Testing configuration for QA Automation
-- Supports: Java (JUnit/TestNG), Playwright (TypeScript/JavaScript)

return {
  -- Neotest core with Java and Playwright adapters
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Java adapter (JUnit, TestNG)
      "rcasia/neotest-java",
      -- Playwright adapter
      "thenbe/neotest-playwright",
    },
    opts = {
      adapters = {
        -- Java test adapter configuration
        ["neotest-java"] = {
          ignore_wrapper = false, -- use mvnw/gradlew if available
        },
        -- Playwright test adapter configuration
        ["neotest-playwright"] = {
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        },
      },
    },
  },

  -- neotest-java requires explicit setup
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
  },

  -- neotest-playwright
  {
    "thenbe/neotest-playwright",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    dependencies = {
      "nvim-neotest/neotest",
    },
  },
}
