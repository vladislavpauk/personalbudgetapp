class BudgetDomainsController < ApplicationController
  load_and_authorize_resource except: :create

  rescue_from CanCan::AccessDenied do |e|
    flash[:error] = 'Access Denied'
    redirect_to budget_domains_path
  end

  # GET /domains
  # GET /domains.json
  def index
    # @budget_domains = current_user.budget_domains
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
    @members = User.with_membership(budget_domain_id: @budget_domain.id)
  end

  # GET /domains/new
  def new
    # @budget_domain = BudgetDomain.new
  end

  # GET /domains/1/edit
  def edit
    authorize! :update, @budget_domain
  end

  # POST /domains
  # POST /domains.json
  def create
    authorize! :create, BudgetDomain
    service = BudgetDomainCreator.call(create_params)
    @budget_domain = service.budget_domain
    if service.status == :ok
      redirect_to @budget_domain, notice: 'Budget domain was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /domains/1
  # PATCH/PUT /domains/1.json
  def update
    authorize! :update, @budget_domain
    if @budget_domain.update(budget_domain_params)
      redirect_to @budget_domain, notice: 'Budget domain was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.json
  def destroy
    authorize! :destroy, @budget_domain
    @budget_domain.destroy
    redirect_to budget_domains_path, notice: 'Budget domain was successfully destroyed.'
  end

  private

  def create_params
    { params: budget_domain_params, user_id: current_user.id }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def budget_domain_params
    params.require(:budget_domain).permit(:name, :description)
  end
end
