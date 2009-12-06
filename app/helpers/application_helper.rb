# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def grade_name(grade)
    if grade == nil:
        return t(:none)
    end

    colors = {
      -8 => t(:junior).titlecase + " " + t(:red).titlecase,
      -7 => t(:junior).titlecase + " " + t(:yellow).titlecase,
      -6 => t(:junior).titlecase + " " + t(:green).titlecase,
      -5 => t(:junior).titlecase + " " + t(:blue).titlecase,
      -4 => t(:junior).titlecase + " " + t(:black).titlecase,
      -3 => t(:junior).titlecase + " " + t(:silver).titlecase + " I",
      -2 => t(:junior).titlecase + " " + t(:silver).titlecase + " II",
      -1 => t(:junior).titlecase + " " + t(:silver).titlecase + " III",
      0 => t(:none).titlecase,
      1 => t(:red).titlecase + " I",
      2 => t(:red).titlecase + " II",
      3 => t(:yellow).titlecase + " I",
      4 => t(:yellow).titlecase + " II",
      5 => t(:green).titlecase + " I",
      6 => t(:green).titlecase + " II",
      7 => t(:blue).titlecase + " I",
      8 => t(:blue).titlecase + " II",
      9 => t(:black).titlecase + " I",
      10 => t(:black).titlecase + " II",
      11 => t(:black).titlecase + " III",
      12 => t(:black).titlecase + " IIII",
    }
    c = colors[grade]
    if c == nil
      return t(:unknown) + " (" + grade.to_s + ")"
    else
      return c
    end
  end

  def groups
    Group.find(:all)
  end

  def clubs
    Club.find(:all)
  end
end
