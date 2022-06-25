class RiversController < ApplicationController
  def index
    @source_id = River.ready_to_match(session[:source_id]).first&.id || 0
    @river_list = River.match_list(session[:source_id])
  end

  def match
    River.find(params[:id]).update(match_type:'skip') if params[:skip]
    Rivers::MatchRiver.new(params[:id], params[:dest_id]).call if params[:dest_id] && !params[:skip]
    @source = River.ready_to_match(session[:source_id]).first
    @destinations = River.close_to(@source).to_a

    respond_to do |format|
      format.turbo_stream { render partial: 'match' }
    end
  end

  def edit
    @source = River.where(id: params[:id]).first
    @destinations = River.close_to(@source).to_a if @source
  end

  def import
    if params[:rivers]
      @import = Rivers::Import.new(params[:rivers], session[:source_id])
      @import.call
      @source = River.where(id: @import.distant_match_ids.first).first
      @destinations = River.close_to(@source).to_a if @source
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def export
    file = Rivers::Export.new(session[:source_id]).call
    send_file(file.path, filename: 'rivers.csv')
  end

  def list
    @river_list = River.match_list(session[:source_id]).where("river ILIKE ?", "#{params['name']}%")
    render partial: 'river_list', locals: { river_list: @river_list }
  end
end
