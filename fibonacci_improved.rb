def fibo (n, answer_list)
  return answer_list[n] if answer_list[n] != nil
  answer_list[n] = fibo(n-1, answer_list) + fibo(n-2, answer_list)
  return answer_list[n]
end

number = ARGV[0].to_i
if number < 1 then
  puts 'Please input positive integer again.'
  exit
end
  
answer_list = Array.new(number)
answer_list[1] = 1
answer_list[2] = 1

print fibo(number, answer_list)
