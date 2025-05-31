
# File2Prompt 🚀📄

**Generate markdown code blocks from project files for AI prompts with smart exclusions**

## English 🇬🇧

### 🧠 What is this?
`file2prompt` scans your project files and generates markdown-formatted code blocks perfect for AI prompt engineering. Easily exclude unnecessary files/directories while preserving critical context!

### ✨ Features
- 🔍 Recursive directory scanning
- 🚫 Exclude files/directories by patterns
- 📁 Process multiple file types
- 💬 Output to stdout/stderr
- ✅ Lightweight & dependency-free

### ⚙️ Installation

```bash
git clone https://github.com/Traineratwot/File2Prompt.git
sudo make install
```

or

```bash
git clone https://github.com/Traineratwot/File2Prompt.git
cd File2Prompt
chmod +x file2prompt
sudo cp file2prompt /usr/local/bin/
```

### 🚀 Usage
```bash
file2prompt [OPTIONS] [FILE_PATTERNS]
```

#### 🔧 Key Options
- `-r` : Recursive search
- `-d PATTERN` : Exclude directories (multi-use)
- `-x PATTERN` : Exclude files (multi-use)

#### 💡 Examples
```bash
# Process shell scripts
file2prompt *.sh

# Python files excluding venv and caches
file2prompt -r -d venv -d .venv -x __pycache__ *.py

# JavaScript files excluding tests and node_modules
file2prompt -x *.test.js -d node_modules *.js
```

### 📋 Output
- ✅ Code blocks → stdout
- ℹ️ Processing info → stderr
- 🚨 Exit codes: 0 (success), 1 (error)

---

## Русский 🇷🇺

### ❓ Что это?
Утилита `file2prompt` анализирует файлы проекта и формирует блоки кода в формате markdown, идеальные для промптов ИИ. Исключайте ненужные файлы/директории, сохраняя важный контекст!

### ⚡ Возможности
- 🔍 Рекурсивный поиск
- 🚫 Исключение файлов/директорий по шаблонам
- 📁 Обработка нескольких типов файлов
- 💬 Вывод в stdout/stderr
- ✅ Легковесная & без зависимостей

### 📦 Установка

```bash
git clone https://github.com/Traineratwot/File2Prompt.git
sudo make install
```

или

```bash
git clone https://github.com/Traineratwot/File2Prompt.git
cd File2Prompt
chmod +x file2prompt
sudo cp file2prompt /usr/local/bin/
```



### 🚀 Использование
```bash
file2prompt [ОПЦИИ] [ШАБЛОНЫ_ФАЙЛОВ]
```

#### ⚙️ Основные опции
- `-r` : Рекурсивный поиск
- `-d ШАБЛОН` : Исключить директории (многократно)
- `-x ШАБЛОН` : Исключить файлы (многократно)

#### 🔍 Примеры
```bash
# Обработка shell-скриптов
file2prompt *.sh

# Python файлы без venv и кешей
file2prompt -r -d venv -d .venv -x __pycache__ *.py

# JavaScript файлы без тестов и node_modules
file2prompt -x *.test.js -d node_modules *.js
```

### 📤 Вывод
- ✅ Блоки кода → stdout
- ℹ️ Информация → stderr
- 🚨 Коды выхода: 0 (успех), 1 (ошибка)

---
Developed with ❤️ by Traineratwot | [GitHub](https://github.com/Traineratwot/File2Prompt)
