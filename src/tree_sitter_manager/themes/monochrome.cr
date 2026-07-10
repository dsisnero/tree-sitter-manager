module TreeSitterManager
  module Themes
    def monochrome_monochrome : ResolvedTheme
      t = Theme.new
      t.set_extended("_normal", color: "#eeeeee", bg: "#0e0e0e")
      t.set("attribute", "#8b8b8b")
      t.set_extended("boolean", color: "#eeeeee", bold: true)
      t.set("character", "#eeeeee")
      t.set("character.special", "#d4d4d4")
      t.set_extended("comment", color: "#494949", italic: true)
      t.set("comment.error", "#ffc0b9")
      t.set("comment.note", "#8cf8f7")
      t.set("comment.warning", "#fce094")
      t.set("constant", "#eeeeee")
      t.set("diff.delta", "#8cf8f7")
      t.set("diff.minus", "#ffc0b9")
      t.set("diff.plus", "#b3f6c0")
      t.set("function", "#8b8b8b")
      t.set("ibl.indent.char.1", "#353535")
      t.set("ibl.scope.char.1", "#494949")
      t.set("ibl.whitespace.char.1", "#353535")
      t.set("keyword", "#5e5e5e")
      t.set("label", "#eeeeee")
      t.set_extended("number", color: "#eeeeee", bold: true)
      t.set_extended("number.float", color: "#eeeeee", bold: true)
      t.set("operator", "#eeeeee")
      t.set("property", "#bbbbbb")
      t.set("punctuation", "#eeeeee")
      t.set("string", "#d4d4d4")
      t.set("string.escape", "#d4d4d4")
      t.set("string.regexp", "#d4d4d4")
      t.set("string.special", "#d4d4d4")
      t.set("tag", "#eeeeee")
      t.set("type", "#5e5e5e")
      t.set("variable", "#e0e2ea")
      t.resolve
    end
  end
end
