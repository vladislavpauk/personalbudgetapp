class Api::V1::BudgetCategoriesController < Api::V1::BaseController
  load_and_authorize_resource :budget_domain
  load_and_authorize_resource :through => :budget_domain
  serialization_scope :current_ability

  def index
    render json: @budget_categories, each_serializer: Api::V1::BudgetCategorySerializer
  end
end
