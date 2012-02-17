# ezFAQ plugin for redMine
# Copyright (C) 2008-2009  Zou Chaoqun
# - modified 2012 for use in Chiliproject
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redmine'

# Patches to the Redmine core. Will not work in development mode
require 'dispatcher'
require 'attachment_patch'
Dispatcher.to_prepare do
  Attachment.send(:include, AttachmentPatch)
end

# Hooks
require_dependency 'faq_layouts_hook'

Redmine::Plugin.register :faq_plugin do
  name 'FAQ 4 chili plugin'
  author 'Simon Stearn'
  description 'This is a FAQ management plugin for Chiliproject 3.0 based on the ezFAQ plugin for redmine'
  version '0.0.1'
  url 'http://github.com/simonstearn/faq_plugin'

  project_module :faq do
    permission :view_faqs, {:faqs => [:index, :show, :diff]}, :public => true
    permission :add_faqs, {:faqs => [:new, :preview]}, :require => :loggedin
    permission :edit_faqs, {:faqs => [:edit, :preview, :copy, :list_invalid_faqs]}, :require => :member
    permission :delete_faqs, {:faqs => [:destroy]}, :require => :member
    permission :manage_faq_categories, {:faq => [:add_faq_category], :faq_categories => [:index, :change_order, :edit, :destroy]}, :require => :member
    permission :faq_setting, {:faqs => [:faq_setting]}, :require => :member
  end

  menu :project_menu, :faq, { :controller => 'faqs', :action => 'index' }, :caption => :label_title_faq

  # Faqs are added to the activity view
  activity_provider :faqs

end
