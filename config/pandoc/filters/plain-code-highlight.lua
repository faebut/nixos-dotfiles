function CodeBlock(block)
  if #block.classes == 0 then
    block.classes:insert("default")
    return block
  end
end
