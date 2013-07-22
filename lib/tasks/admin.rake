namespace :app_tasks do
desc "task description"
task :add_initial_admin => :environment do
@a = User.find_by_email("gourav@aristontek.com") 
@a.is_admin = "true"
@a.save!  
    
end

desc "Course Contents"
task :add_course_content => :environment do
@a = Content.create(:name => "RoR-Course", :content => "<div id= "listContainer">
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
        </div> ") 
@a.save!  
    
end

end
