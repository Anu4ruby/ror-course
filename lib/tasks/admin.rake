namespace :app_tasks do
desc "task description"
task :add_initial_admins => :environment do
  admins = ['gourav@aristontek.com', 
            'pobuchan2010@gmail.com', 
            'anu4ruby@gmail.com',
            'gnarmediacom@gmail.com']
  admins.each do |email|
    user = User.find_by_email(email)
    user.is_admin = true
    user.save
  end
end

desc "Course Contents"
task :add_course_content => :environment do
    sql = '<div id= "listContainer">
            <ol id= "expList">
                <li>
                    Item A
                    <ol>
                        <li>
                            Item A.1
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                        <li>
                            Item A.2
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                        <li>
                            Item A.3
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                    </ol>
                </li>
                <li>
                    Item B
                    <ol>
                        <li>
                            Item B.1
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                        <li>
                            Item B.2
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                        <li>
                            Item B.3
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                    </ol>
                </li>
                <li>
                    Item C
                    <ol>
                        <li>
                            Item C.1
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                        <li>
                            Item C.2
                            <ol>
                                <li>
                                    <span>Lorem ipsum.</span>
                                </li>
                            </ol>
                        </li>
                    </ol>
                </li>
            </ol>
        </div> '
@a = Content.create(:name => "RoR-Course", :content => ActiveRecord::Base.connection.quote(sql))
@a.save!  
    
end

end
