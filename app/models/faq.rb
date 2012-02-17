class Faq < ActiveRecord::Base
  unloadable

# returning to default naming coz less is more
#  set_locking_column :version

  belongs_to :category, :class_name => 'FaqCategory', :foreign_key => 'category_id'
  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates_presence_of :question, :project, :difficulty
  validates_length_of :question, :maximum => 255

  acts_as_attachable

  acts_as_searchable :columns => ["#{table_name}.question", "#{table_name}.answer"], :include => [:project]


  acts_as_journalized :event_title => Proc.new {|o| "#{l(:label_title_faq)} #{o.journaled_id}: #{o.question}"}, :event_type => 'faq'

  register_on_journal_formatter(:named_association, 'project_id', 'category_id', 'author_id', 'updater_id', 'related_message_id', 'related_issue_id')
  register_on_journal_formatter(:decimal, 'difficulty', 'viewed_count')
  register_on_journal_formatter(:datetime, 'due_date', 'created_on', 'updated_on')
  register_on_journal_formatter(:plaintext, 'question', 'answer')
  
  def assigned_to
    assigned_to_id ? User.find(:first, :conditions => "users.id = #{assigned_to_id}") : nil
  end
  
  def author
    author_id ? User.find(:first, :conditions => "users.id = #{author_id}") : nil
  end
  
  def FaqJournal::user
    updater_id ? User.find(:first, :conditions => "users.id = #{updater_id}") : nil
  end
  
  def updater
    updater_id ? User.find(:first, :conditions => "users.id = #{updater_id}") : nil
  end
  
  def issue
    related_issue_id ? Issue.find(:first, :conditions => "issues.project_id = #{project_id} and issues.id = #{related_issue_id}") : nil
  end

  def message
    related_message_id ? Message.find(:first, :conditions => ["messages.id = #{related_message_id}", "Message.Board.project_id = #{project_id}"]) : nil
  end

  
  def project
    Project.find(:first, :conditions => "projects.id = #{project_id}")
  end
  
  def <=>(faq)
    if Setting.default_language.to_s == 'zh'
      @ic ||= Iconv.new('GBK', 'UTF-8')
      @ic.iconv(question) <=> @ic.iconv(faq.question)
    else
      question <=> faq.question
    end
  end
  
  def to_s
    "##{id}: #{question}"
  end

  # Copies a faq in current project or to a new project
  def copy(new_project)
    faq = self.clone
    if (faq.project_id != new_project.id)
      faq.project_id = new_project.id
      faq.category = nil
    end
    faq.save
  end

end
