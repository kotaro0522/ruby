def fibo (n) 
	if n == 1 then
		return 1
	elsif n == 2 then
		return 1
	end
	return fibo(n-1)+fibo(n-2)
end

print(fibo(ARGV[0].to_i))
