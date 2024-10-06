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
      dir = "~/git/myspace", -- обновленный путь к твоему vault
      ui = {
          enable = true, -- включить UI функции
      },
      completion = {
        nvim_cmp = true, -- включить автодополнение через nvim-cmp
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

-- Функция для поиска связанных заметок
local function search_related_notes()
    local current_file = vim.fn.fnamemodify(vim.fn.expand('%:t'), ':r') -- Получаем имя текущего файла без расширения
    require('telescope.builtin').live_grep({
        cwd = '~/git/myspace', -- обновленный путь к вашему vault
        default_text = current_file -- Заполняем поле ввода именем текущей заметки без расширения
    })
end

-- Помещаем функцию в глобальную область видимости
_G.search_related_notes = search_related_notes

-- Маппинг для поиска связанных заметок
vim.api.nvim_set_keymap("n", "<leader>or", ":lua search_related_notes()<CR>", { noremap = true, silent = true })

-- Маппинг для поиска по всем файлам в каталоге Obsidian через Telescope
vim.api.nvim_set_keymap("n", "<leader>of", ":lua require('telescope.builtin').find_files({ cwd = '~/git/myspace' })<CR>", { noremap = true, silent = true })

-- Функция для создания новой заметки с выбором шаблона
local function create_note_from_template()
    -- Выбор шаблона
    require('telescope.builtin').find_files({
        cwd = '~/git/myspace/templates', -- путь к папке с шаблонами
        attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            -- Определяем действие при выборе шаблона
            map('i', '<CR>', function()
                local selection = require('telescope.actions.state').get_selected_entry()
                actions.close(prompt_bufnr) -- Закрываем окно выбора

                -- Запрашиваем имя новой заметки
                vim.ui.input({ prompt = 'Введите имя для новой заметки: ' }, function(input)
                    if input and input ~= '' then
                        -- Формируем полный путь к новой заметке в папке base
                        local note_name = input .. '.md' -- Добавляем расширение .md
                        local new_note_path = vim.fn.expand('~/git/myspace/base/' .. note_name) -- Обновляем путь к папке base

                        -- Проверяем, существует ли файл
                        if vim.fn.filereadable(new_note_path) == 1 then
                            -- Если файл существует, просто открываем его
                            vim.cmd('edit ' .. new_note_path)
                            print('Открыта существующая заметка: ' .. new_note_path)
                        else
                            -- Получаем полный путь к шаблону
                            local template_path = selection.path or selection.value

                            -- Читаем шаблон и создаем новую заметку
                            local template_content = vim.fn.readfile(template_path)

                            -- Проверяем, существует ли директория
                            local dir_path = vim.fn.fnamemodify(new_note_path, ':h') -- Получаем путь к директории
                            if vim.fn.isdirectory(dir_path) == 0 then
                                vim.fn.mkdir(dir_path, "p") -- Создаем директорию, если она не существует
                            end

                            -- Записываем содержимое шаблона в новую заметку
                            vim.fn.writefile(template_content, new_note_path)

                            -- Открываем новую заметку в буфере
                            vim.cmd('edit ' .. new_note_path)

                            print('Создана новая заметка: ' .. new_note_path)
                        end
                    else
                        print('Имя заметки не может быть пустым.')
                    end
                end)
            end)
            return true
        end,
    })
end

-- Помещаем функцию в глобальную область видимости
_G.create_note_from_template = create_note_from_template

-- Маппинг для создания новой заметки с выбором шаблона
vim.api.nvim_set_keymap("n", "<leader>on", ":lua create_note_from_template()<CR>", { noremap = true, silent = true })

-- Переключение на предыдущий буфер с Alt + Left
vim.api.nvim_set_keymap("n", "<A-Left>", ":bprevious<CR>", { noremap = true, silent = true })

-- Переключение на следующий буфер с Alt + Right
vim.api.nvim_set_keymap("n", "<A-Right>", ":bnext<CR>", { noremap = true, silent = true })


vim.api.nvim_set_keymap("n", "<leader>bb", ":Telescope buffers<CR>", { noremap = true, silent = true })
