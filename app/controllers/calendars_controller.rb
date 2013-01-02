# encoding: utf-8
class CalendarsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @calendars = current_user.calendars.order('created_at DESC').all
  end
  
  def show
    
    if params[:what] == 'calendar'
      @source = 'calendars/show.pdf.erb'
      @disposition = "Portrait"
    else
      @source = 'calendars/showposter.pdf.erb'
      @orientation = "Landscape"
    end
    
    @calendar = Calendar.find(params[:id])
    @calname = @calendar.name+'_'+@calendar.id.to_s
    respond_to do |format|
      format.pdf do
          render :page_size => "A4",
                  :pdf => @calname,
                  :disposition => 'attachment',
                  :template => @source,
                  :orientation => @orientation,
                  :save_to_file  => Rails.root.join('public/pdfs', "#{@calname}.pdf"),
                  :margin => {:top   => 2,
                             :bottom  => 2,
                             :left    => 2,
                             :right   => 2},
                  :no_background => false,
                  :lowquality  => false
      end
    end    
  end


  def new
    @calendar = Calendar.new
    @calendar.events.build
  end

  def create
    @calendar = current_user.calendars.new(params[:calendar])
    if @calendar.logo.to_s == "logono.gif"
       @calendar.description = "<b>Pour préserver notre emploi, nous devons satisfaire le client.</b><br> C’est vital pour la survie de l'entreprise. Sans lui, pas de travail. Et sans travail, pas d'emploi. <br>Nous devons être capables d'adapter notre comportement, voire même notre manière de fonctionner.<br>Parce que nous sommes au service du client. Pas l'inverse. <br><b>Mon emploi en dépend !</b>"
    end
    if @calendar.save
      redirect_to calendars_url, :notice => "Calendrier correctement créé."
    else
      render :action => 'new'
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
    @events = @calendar.events
  end

  def update
    @calendar = Calendar.find(params[:id])
    if params[:calendar][:logo].nil?
       params[:calendar][:description] = "<b>Pour préserver notre emploi, nous devons satisfaire le client.</b><br> C’est vital pour la survie de l'entreprise. Sans lui, pas de travail. Et sans travail, pas d'emploi. <br>Nous devons être capables d'adapter notre comportement, voire même notre manière de fonctionner.<br>Parce que nous sommes au service du client. Pas l'inverse. <br><b>Mon emploi en dépend !</b>"
    end
    if @calendar.update_attributes(params[:calendar])
      redirect_to calendars_url, :notice  => "Calendrier correctement mis à jour."
    else
      render :action => 'edit'
    end
  end
end
