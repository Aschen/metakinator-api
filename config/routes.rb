Rails.application.routes.draw do

  resources :entities do
    get :export_excel, on: :collection
    get :export_csv, on: :collection
    get :export_arff, on: :collection
  end

  resources :questions do
    post :best_question, on: :collection
    get :first_question, on: :collection
  end

  resources :answers

  resources :sports do
    get :export_excel, on: :collection
    get :export_csv, on: :collection
    get :export_arff, on: :collection
  end
end
