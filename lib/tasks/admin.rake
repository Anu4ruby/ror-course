namespace :app_tasks do
desc "task description"
task :add_initial_admin => :environment do
# @a = User.find_by_email("gourav@aristontek.com")
@a = User.find_by_email("arunsendil@gmail.com")
@a.is_admin = "true"
@a.save!  
  # User.update(email_id: 'email@id.com', name: 'name')  
end
end
