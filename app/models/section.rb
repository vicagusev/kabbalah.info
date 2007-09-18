class Section < ActiveRecord::Base
	has_many :assets
	acts_as_list

	validates_presence_of :permalink
	validates_uniqueness_of :permalink
	
	def self.get_title_by_id (section_id)
		[find(section_id)].map{|x| x.title}
	end
	
	def to_param
		permalink
	end

	def permitted_assets
		read_attribute("permitted_assets" ) ? read_attribute("permitted_assets" ).split(' ') : ""
	end
	
	def self.environments
		Section.find(:all, :order => 'position ASC').select{|section| section.is_environment? && section.active_environment?}
	end
	
	def is_environment?
		!self.layout.blank?
	end
	def active_environment?
debugger
		if has_homepage?
			true
		else
			pages = Asset.find(:all, :conditions => "section_id = #{self.id} and resource_type = 'Page'")
			pages && pages.any?{|page| page.published_page?}
		end
	end
	def has_homepage?
		Asset.find(:all, :conditions => "section_id = #{self.id} and resource_type = 'Homepage'") != []
	end
end
