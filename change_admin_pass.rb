User.find_by(role: "admin").each do |user|
  user.pass = Digest::MD5.hexdigest("FlutterShy")
  user.save
end|
