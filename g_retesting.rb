GResult.all.each do |result|
  gans = result.result.task.g_answer
  json = result.answer
  puts json
  if json != nil
    puts result.mark
    mark, mistakes, log = gans.check_answer(json)
    result.mark = mark
    result.log.mistakes = mistakes
    result.log.data = log
    result.save
    result.log.save
    puts result.mark
  end
end
