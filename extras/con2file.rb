require 'rubygems'
require 'mysql'
require 'active_support/all'
puts "輸入你要轉換成UTF-8的UTF-16格式檔案"
filename = gets.chomp
linec =0
	con = Mysql.new("localhost", "root", "", "demo_development")
query = "insert into schools (id, name, address) values (?, ?, ?)"
begin
#  open('newfile.txt', 'w') do |wf| #開啟要寫入的檔案
	results = con.prepare(query)
	file = open(filename, "r:utf-16:utf-8")
	file.each do |line|
	#	wf.puts "#{line}"
		line = line.split("\t")
		if line[0].to_i >=0001 && line[1].present? == true
		linec = linec +1
		#wf.puts line[1]
		results.execute("#{linec}","#{line[1]}","#{line[3]}")
	end
	end
	file.close
#ensure
	#con.close if con
end
	
