# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

csv_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = User.new
  t.username = row['username']
  t.email = row['email']
  t.phone = row['phone']
  t.save
  puts "#{t.username} saved"
end


csv_text = File.read(Rails.root.join('lib', 'seeds', 'events.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Event.new
  t.title = row['title']
  t.starttime = row['starttime']
  t.endtime = row['endtime']
  t.description = row['description']
  t.is_all_day = row['allday']
  t.status = Time.parse(row['endtime']) < Time.now ? 'Completed' : 'Scheduled'
  t.save
  puts "#{t.title} saved"
  
  users_row = row['users#rsvp']
  users = users_row.split(';')
  users.each do |user|
    response = user.split('#')
	user = User.where(response.first).first
	rsvp = response.last
	if user
	 user_events_on_same_day = user.events.where(:starttime => row['starttime'],:endtime['endtime']).all
     unless existing_user_events.blank?
	   existing_user_events.each do |event|
	     event.attendance.rsvp = "NO"
		 event.attendance.save!
	   end
	 end
      attendance = t.attendance.build(:user => user, :rsvp => rsvp)
      attendance.save	 
	end
  end
end
