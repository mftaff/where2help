ActiveAdmin.register Event do
  include Concerns::Views
  include Concerns::ParanoidScopes
  include Concerns::ParanoidFind

  menu priority: 4
  actions :all, except: [:new, :edit, :update]
  includes :shifts

  filter :ngo
  filter :title
  filter :address
  filter :created_at
end