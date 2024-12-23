require 'tokyonight'.setup ({
  style = 'night',
  transparent = true,
  terminal_colors = true,
  styles = {
    functions = {}
  },
  on_colors = function(colors)
    colors.comments = '#6272a4',
  end,
  on_highlights = function(highlights, colors) end,
})
