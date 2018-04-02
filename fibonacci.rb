def fibo (n) 
	return 0 if n <= 0
	return 1 if n == 1 or n == 2
	return fibo(n-1)+fibo(n-2)
end

print(fibo(ARGV[0].to_i))
