get '/user/:id' do

	@title = "User"
	@user = User.get(params[:id])
	
	erb :'users/show'	
end
