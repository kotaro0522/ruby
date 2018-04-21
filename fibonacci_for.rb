def fibo (n)
  return 0 if n < 1

  previous_number = 0
  current_number = 1
  next_number = 1

  for i in 1..n do
    current_number = next_number
    next_number = current_number + previous_number
    previous_number = current_number
  end
  return current_number
end

print (fibo(ARGV[0].to_i))
