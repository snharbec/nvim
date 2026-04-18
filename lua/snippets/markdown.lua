local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s(";date", {
    t(os.date("%Y-%m-%d")),
  }),
  s(";bash", {
    t({ "```bash", "" }),
    i(1),
    t({ "", "```" }),
  }),
  s(";sh", {
    t("Stefan Harbeck"),
  }),
}
