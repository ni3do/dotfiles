local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
  return
end

lint.linters_by_ft = {
  python = { "ruff", "mypy" },
  sh = { "shellcheck" },
  zsh = { "zsh" },
}

local mypy_opts = { "--ignore-missing-imports", "--cache-dir=/dev/null" }
local ruff_opts = { "--ignore=W503,E203" }
for _, arg in ipairs(mypy_opts) do
  table.insert(lint.linters.mypy.args, arg)
end

for _, arg in ipairs(ruff_opts) do
  table.insert(lint.linters.ruff.args, arg)
end
