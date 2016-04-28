Rails.application.routes.draw do

  resources :entities do
    post :import_csv, on: :collection
    delete :delete_class, on: :collection
    get :export_excel, on: :collection
    get :export_csv, on: :collection
    get :export_arff, on: :collection
  end

  resources :questions do
    post :best_question, on: :collection
    get :first_question, on: :collection
  end

  resources :answers
  
  root 'entities#index'
end
