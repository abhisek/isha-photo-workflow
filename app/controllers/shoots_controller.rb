class ShootsController < ApplicationController
  before_filter :authenticate_user!

  # GET /shoots
  # GET /shoots.json
  def index
    session[:search] ||= {}
    session[:search].merge!((params[:search] || {}).symbolize_keys)
    @search = session[:search]

    # Find all
    @shoots = Shoot.order('created_at DESC')

    # Filter
    @search.keys.each do |key|
      unless @search[key].to_s.empty?
        case key
        when /create_start/
          @shoots = @shoots.after_create(Date.strptime(@search[key].to_s, "%m/%d/%Y"))
        when /create_end/
          @shoots = @shoots.before_create(Date.strptime(@search[key].to_s, "%m/%d/%Y"))
        when /event/
          @shoots = @shoots.event_like(@search[key].to_s)
        when /photographer/
          @shoots = @shoots.photographer_like(@search[key].to_s)
        end
      end
    end

    # Paginate
    @shoots = @shoots.paginate(:page => (params[:page] || 1), :per_page => 20)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shoots }
    end
  end

  # GET /shoots/1
  # GET /shoots/1.json
  def show
    @shoot = Shoot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shoot }
    end
  end

  # GET /shoots/new
  # GET /shoots/new.json
  def new
    @shoot = Shoot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shoot }
    end
  end

  # GET /shoots/1/edit
  def edit
    @shoot = Shoot.find(params[:id])
  end

  # POST /shoots
  # POST /shoots.json
  def create
    #@shoot = Shoot.new(params[:shoot])
    @shoot = current_user.shoots.new(params[:shoot])

    respond_to do |format|
      if @shoot.save
        format.html { redirect_to @shoot, notice: 'Shoot was successfully created.' }
        format.json { render json: @shoot, status: :created, location: @shoot }
      else
        format.html { render action: "new" }
        format.json { render json: @shoot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shoots/1
  # PUT /shoots/1.json
  def update
    @shoot = Shoot.find(params[:id])

    respond_to do |format|
      if @shoot.update_attributes(params[:shoot])
        format.html { redirect_to @shoot, notice: 'Shoot was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @shoot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shoots/1
  # DELETE /shoots/1.json
  def destroy
    @shoot = Shoot.find(params[:id])
    @shoot.destroy

    respond_to do |format|
      format.html { redirect_to shoots_url }
      format.json { head :ok }
    end
  end
end
