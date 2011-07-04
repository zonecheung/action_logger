SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :my_dashboard, I18n.t('layouts.application.my_dashboard'), dashboard_path do |dashboard|
      
      dashboard.item  :users, I18n.t('users.all_users'), users_path do |user|
        user.item :user, @user.try(:full_name), url_for(@user), :highlights_on => /users\/[0-9]+/ do |user|
          if @user.present? && !@user.new_record?
            user.item :edit, I18n.t('edit'), edit_user_registration_path(@user), :highlights_on => /users\/edit.[0-9]+/
            user.item :edit_avatar, I18n.t('users.edit_user_avatar'), edit_avatar_user_path(@user), :highlights_on => /users\/[0-9]+\/edit_avatar/
          end
        end
      end

      dashboard.item :courses, I18n.t('courses.all_classes'), classes_path do |course|
        if @course.present? && !@course.new_record?
          course.item :edit_course, I18n.t('edit'), edit_class_path(@course), :highlights_on => /classes\/[0-9]+\/edit/
          course.item :course, truncate(@course.try(:title), :length => 20), class_path(@course), :highlights_on => /classes\/[0-9]+/
          
          course.item :discussions, I18n.t('courses.all_discussions'), class_discussions_path(@course), :highlights_on => /classes\/[0-9]+\/discussions/ do |discussion|
            discussion.item :new, I18n.t('courses.start_discussion'), new_class_discussion_path(@course), :highlights_on => /classes\/[0-9]+\/discussions\/new/
            if @discussion.present? && !@discussion.new_record?
              discussion.item :discussion, truncate(@discussion.try(:title), :length => 20), class_discussion_path(@course, @discussion), :highlights_on => /classes\/[0-9]+\/discussions\/[0-9]+/
            end
          end
          
          course.item :assignments, I18n.t('assignments.all_assignments'), class_assignments_path(@course), :highlights_on => /classes\/[0-9]+\/assignments/ do |assignment|
          end
          
        elsif @course.present? && @course.new_record?
            course.item :new, I18n.t('courses.create_a_new_class'), new_class_path, :highlights_on => /classes\/new/
        end
      end

    end
  end
end
