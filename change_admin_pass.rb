User.where(role: "admin").each do |user|
	puts user.login
  user.pass = Digest::MD5.hexdigest("AIlabRybina914")
  user.save
end
