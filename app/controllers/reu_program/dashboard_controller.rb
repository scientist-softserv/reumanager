module ReuProgram
  class DashboardController < AdminController
    def index


      @applicants = Applicant.all
      
      @sum = Applicant.count
      @count_started = Applicant.where(state: "Started").count
      @count_completed = Applicant.where(state: "Completed").count
      @count_accepted = Applicant.where(state: "Accepted").count
      @count_rejected = Applicant.where(state: "Rejected").count
      @count_withdrawn = Applicant.where(state: "Withdrawn").count

      @settings = Setting.all
      @settings_start = Setting.where(name: "Application Start").first
      @settings_deadline = Setting.where(name: "Application Deadline").first
      @settings_not_date = Setting.where(name: "Notification Date").first
      @settings_prog_start = Setting.where(name: "Program Start Date").first
      @settings_prog_end = Setting.where(name: "Program End Date").first
      @settings_university = Setting.where(name: "University").first
      @settings_dept = Setting.where(name: "Department").first
      # @values = Setting.first(6)

    end
  end
end
