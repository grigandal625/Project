#coding=utf-8
class MethodicalMaterialsController < ApplicationController
  layout 'methodical_materials'

  def index
    @page = MethodicalMaterial.find_by name: 'Components'
    unless @page
      @page = MethodicalMaterial.create name: 'Components'
    end
  end

  def update
    @page = MethodicalMaterial.find params[:id]
    @page.update(m_params)
    render nothing: true
  end

  def new
    @page = MethodicalMaterial.create name: 'Новый компонент', title: 'Заголовок', description: 'Описание'
    render 'show'
  end

  def show
    @page = MethodicalMaterial.find params[:id]
  end

  def destroy
    MethodicalMaterial.find(params[:id]).destroy
    respond_to do |format|
      format.js {
        render nothing: true
      }
      format.any {
        redirect_to methodical_materials_path, status: 303
      }
    end
  end

  private
    def m_params
      params.require(:methodical_material).permit(:name, :title, :description, :theoretical_part, :practical_part)
    end
end
