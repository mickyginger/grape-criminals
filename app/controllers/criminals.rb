module API
  class CriminalsController < Grape::API

    resource :criminals do
      get do
        Criminal.all.as_json include: :associates
      end

      post do
        validate_token
        params[:user] = @current_user
        status 201
        Criminal.create! permitted_params
      end

      get ':id' do
        Criminal.find(params[:id]).as_json({
          include: [:associates, { user: { except: :password_digest } }]
        })
      end

      put ':id' do
        validate_token
        Criminal.update params[:id], permitted_params
      end

      delete ':id' do
        validate_token
        Criminal.destroy params[:id]
        status 204
        ''
      end
    end
  end
end
