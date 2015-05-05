class LayoutPatternsController < ApplicationController
  before_action :set_layout_pattern, only: [:show, :edit, :update, :destroy]

  # GET /layout_patterns
  # GET /layout_patterns.json
  def index
    @layout_patterns = LayoutPattern.all
  end

  # GET /layout_patterns/1
  # GET /layout_patterns/1.json
  def show
  end

  # GET /layout_patterns/new
  def new
    @layout_pattern = LayoutPattern.new
  end

  # GET /layout_patterns/1/edit
  def edit
  end

  # POST /layout_patterns
  # POST /layout_patterns.json
  def create
    @layout_pattern = LayoutPattern.new(layout_pattern_params)

    respond_to do |format|
      if @layout_pattern.save
        format.html { redirect_to @layout_pattern, notice: 'Layout pattern was successfully created.' }
        format.json { render :show, status: :created, location: @layout_pattern }
      else
        format.html { render :new }
        format.json { render json: @layout_pattern.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /layout_patterns/1
  # PATCH/PUT /layout_patterns/1.json
  def update
    respond_to do |format|
      if @layout_pattern.update(layout_pattern_params)
        format.html { redirect_to @layout_pattern, notice: 'Layout pattern was successfully updated.' }
        format.json { render :show, status: :ok, location: @layout_pattern }
      else
        format.html { render :edit }
        format.json { render json: @layout_pattern.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /layout_patterns/1
  # DELETE /layout_patterns/1.json
  def destroy
    @layout_pattern.destroy
    respond_to do |format|
      format.html { redirect_to layout_patterns_url, notice: 'Layout pattern was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_layout_pattern
      @layout_pattern = LayoutPattern.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def layout_pattern_params
      params.require(:layout_pattern).permit(:name, :note)
    end
end
