def fibo (n)
	for i in 1..n do
		if i == 1 then
			ans = 1
		elsif i == 2 then
			ans = 1
			ans_pre = 1
		else
			ans_tmp = ans
			ans += ans_pre
			ans_pre = ans_tmp
		end
	end
	return ans
end

print (fibo(ARGV[0].to_i))
