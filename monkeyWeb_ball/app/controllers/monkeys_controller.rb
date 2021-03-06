class MonkeysController < ApplicationController
  before_action :set_monkey, only: [:show, :edit, :update, :destroy]

  # GET /monkeys
  # GET /monkeys.json
  def index
    @monkeys = Monkey.joins(:start_date).order("start_dates.start_date DESC").joins(:cohort).order("cohorts.name").order("monkeys.last_name")

  end

  # GET /monkeys/1
  # GET /monkeys/1.json
  def show
  end

  # GET /monkeys/new
  def new
    @monkey = Monkey.new
  end

  # GET /monkeys/1/edit
  def edit
  end

  # POST /monkeys
  # POST /monkeys.json
  def create
    @monkey = Monkey.new(monkey_params)

    respond_to do |format|
      if @monkey.save
        format.html { redirect_to @monkey, notice: 'Monkey was successfully created.' }
        format.json { render :show, status: :created, location: @monkey }
      else
        format.html { render :new }
        format.json { render json: @monkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monkeys/1
  # PATCH/PUT /monkeys/1.json
  def update
    respond_to do |format|
      if @monkey.update(monkey_params)
        format.html { redirect_to @monkey, notice: 'Monkey was successfully updated.' }
        format.json { render :show, status: :ok, location: @monkey }
      else
        format.html { render :edit }
        format.json { render json: @monkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monkeys/1
  # DELETE /monkeys/1.json
  def destroy
    @monkey.destroy
    respond_to do |format|
      format.html { redirect_to monkeys_url, notice: 'Monkey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def plot
    puts 'doin a plots'
    pathParts = Dir.pwd.split('/')
    pathParts.pop()
    path = pathParts.join('/') + '/analysis.py'
    metric,feature = params[:metric], params[:feature]
    theaction = params[:theaction]
    filename = "#{metric}-by-#{feature}.png"
    outpath = Dir.pwd + '/app/assets/images/' + filename
    `python #{path} -a #{theaction} -f #{feature} -m #{metric} -d '#{Monkey.all.to_json}' -o #{outpath}`
    puts 'did a plot'
    puts outpath
    respond_to do |format|
      format.json { render json: Hash["filename"=>filename] }
    end
  end

  def datas
    #code
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monkey
      @monkey = Monkey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monkey_params
      params.fetch(:monkey, {}).permit(:first_name, :last_name, :expectations, :learning_accommodations, :cohort_id, :school_id, :start_date_id, :live_problem_solving, :efforts_to_date, :current_skills, :years_employment, :weekly_hours_work, :graduated, :outgoing_skills, :job_placement_6_months, :expectation_fulfillment, :week_dropped)
    end
end
