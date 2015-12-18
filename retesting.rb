GResult.all.each do |result|
  gans = result.result.task.g_answer
  json = result.answer
  if json != nil
    mark, mistakes, log = gans.check_answer(json)
    result.mark = mark
    result.log.mistakes = mistakes
    result.log.data = log
    result.save
    result.log.save
  end
end

SResult.all.each do |result|
  sans = result.result.task.s_answer
  text = result.answer
  if text != nil
    mark, mistakes, log = sans.check_answer(text)
    result.mark = mark
    result.log.mistakes = mistakes
    result.log.data = log
    result.save
    result.log.save
  end
end
