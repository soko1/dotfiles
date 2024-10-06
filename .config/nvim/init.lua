-- Устанавливаем lazy.nvim, если еще не установлен
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- последняя стабильная версия
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Настройка lazy.nvim
require("lazy").setup({
  -- Устанавливаем telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {}
    end,
  },

  -- Устанавливаем obsidian.nvim
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp", -- добавляем nvim-cmp как зависимость
    },
    opts = {
      dir = "~/git/myspace", -- путь к твоему vault
      completion = {
        nvim_cmp = true, -- включить автодополнение через nvim-cmp
      },
    attachments = {
            img_folder = "files/", -- изменить директорию для сохранения изображений
        },
    },
  },

  -- Другие плагины
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" }, -- источник автодополнения для буфера
  { "hrsh7th/cmp-path" },   -- источник автодополнения для путей
  { "tpope/vim-fugitive" }, -- для работы с Git
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }, -- улучшение синтаксического разбора
})

-- Основные настройки Neovim
vim.opt.number = true          -- Нумерация строк
vim.opt.relativenumber = true  -- Относительная нумерация
vim.opt.expandtab = true       -- Преобразование табов в пробелы
vim.opt.shiftwidth = 2         -- Ширина табуляции в пробелах
vim.opt.tabstop = 2            -- Количество пробелов на место табуляции
vim.opt.conceallevel = 1       -- Установка conceallevel для плагина Obsidian

-- Настройка nvim-cmp
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- подтверждение выбора
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), -- предыдущая подсказка
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), -- следующая подсказка
  },
  sources = {
    { name = 'buffer' }, -- источник автодополнения для буфера
    { name = 'path' },   -- источник автодополнения для путей
  },
})

-- Маппинги для obsidian.nvim

-- Открытие заметки в приложении Obsidian
vim.api.nvim_set_keymap("n", "<leader>oo", ":ObsidianOpen<CR>", { noremap = true, silent = true })

-- Быстрая навигация между заметками
vim.api.nvim_set_keymap("n", "<leader>oq", ":ObsidianQuickSwitch<CR>", { noremap = true, silent = true })

-- Следование за ссылкой под курсором
vim.api.nvim_set_keymap("n", "<leader>ol", ":ObsidianFollowLink<CR>", { noremap = true, silent = true })

-- Создание новой заметки
vim.api.nvim_set_keymap("n", "<leader>on", ":ObsidianNew<CR>", { noremap = true, silent = true })

-- Просмотр обратных ссылок на текущую заметку
vim.api.nvim_set_keymap("n", "<leader>ob", ":ObsidianBacklinks<CR>", { noremap = true, silent = true })

-- Вставка изображения из буфера обмена
vim.api.nvim_set_keymap("n", "<leader>oi", ":ObsidianPasteImg<CR>", { noremap = true, silent = true })

-- Использование шаблона для создания новой заметки
vim.api.nvim_set_keymap("n", "<leader>ot", ":ObsidianNewFromTemplate<CR>", { noremap = true, silent = true })

-- Список тегов в заметке
vim.api.nvim_set_keymap("n", "<leader>otag", ":ObsidianTags<CR>", { noremap = true, silent = true })

-- Переключение на предыдущий буфер с Alt + Left
vim.api.nvim_set_keymap("n", "<A-Left>", ":bprevious<CR>", { noremap = true, silent = true })

-- Переключение на следующий буфер с Alt + Right
vim.api.nvim_set_keymap("n", "<A-Right>", ":bnext<CR>", { noremap = true, silent = true })

-- Маппинг для просмотра буферов
vim.api.nvim_set_keymap("n", "<leader>bb", ":Telescope buffers<CR>", { noremap = true, silent = true })

-- Маппинг для отображения списка последних открытых файлов с помощью Telescope
vim.api.nvim_set_keymap("n", "<leader>rf", ":Telescope oldfiles<CR>", { noremap = true, silent = true })

-- Поиск или создание заметки
vim.api.nvim_set_keymap("n", "<leader>os", ":ObsidianSearch<CR>", { noremap = true, silent = true })
