# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_config(setting)
    SiteSettings.get_setting(setting)
  end

  def grades
    Grade.find(:all, :order => :level)
  end

  def grade_categories
    GradeCategory.find(:all, :order => :category)
  end

  def titles
    Title.find(:all, :order => :level)
  end

  def board_positions
    BoardPosition.find(:all, :order => :id)
  end

  def club_positions
    ClubPosition.find(:all, :order => :id)
  end

  def grade_str(graduation)
    if graduation == nil
      return "-"
    else
      return graduation.grade.description + " (" + graduation.grade_category.category + ")"
    end
  end

  def groups
    Group.find(:all, :order => :identifier)
  end

  def clubs
    Club.find(:all, :order => :name)
  end

  def mailing_lists
    MailingList.find(:all, :order => :description)
  end

  def active_string(active)
    return 'active' if active
    ''
  end

  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end
end
