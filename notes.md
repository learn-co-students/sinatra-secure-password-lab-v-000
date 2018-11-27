Hopefully these notes will be helpful to me when I hit the project and I don't know what the hell I'm doing. Okay so new things in this lesson to remember:
1. run bundle exec before the code "rake db:create_migrations" or whatever else if you have a version issue. That seemed to work.
2. has_secure_password is a cool metaprogram that comes with gem bcrypt. It allows you to use the method "authenticate" which helps you push through the line of logic:
user = User.find_by(username: params[:username]) <-- find a user just by username, not by username AND password params
if user && user.authenticate(params[:password]) <-- if they exist and they authenicate their password as it originally was in params, then good to go!
3. session[:user_id] = user.id don't forget about asking about this. actually run pry now see what the session hash reveals. Okay interesting a lot of random junk (I guess that's what's persisting the data to "the server" aka me...) but the last key/value pair is user_id = 1. Awesome so user.id is the id of this user, and it's setting it equal the user_id of the session....okay maybe still ask at some point hahah
4. We're not using logged_in? or current_user here....so maybe look at the solutions guide at some point to see how to build out the accounts folder and go further with that...putting that on my TODO list tomorrow before I start watching that video because it should be quick.

That's it I think! Cool stuff with authentication and not as scary as I thought.
