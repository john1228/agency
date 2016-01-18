namespace :migration do
  desc '学员'
  task :member => :environment do
    csv_text = File.read("#{Rails.root}/" + 'member.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      puts row[0]
    end
  end

  task :member => :environment do
    csv_text = File.read("#{Rails.root}/" + 'member2.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      PhysicalCard.create(entity_number: row[0], virtual_number: row[1])
    end
  end
end