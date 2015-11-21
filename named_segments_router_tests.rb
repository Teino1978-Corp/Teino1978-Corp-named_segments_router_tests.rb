ROUTES = {
  "GET /" => ["RootController", :show],
  "GET /home" => ["HomeController", :index],
  "GET /posts/:slug/comments/:id/edit" => ["CommentsController", :edit],
  "POST /posts/:slug/comments" => ["CommentsController", :create],
  "PUT /posts/:slug" => ["PostsController", :update]
}

router = Router.new ROUTES

Test.describe "Router#route?" do
  Test.it "matches static routes" do
    Test.expect router.route?("GET /"), "Should match the static route \"GET /\""
    Test.expect router.route?("GET /home"), "Should match the static route \"GET /home\""
  end
  
  Test.it "matches named segment routes" do
    Test.expect router.route?("GET /posts/test-post/comments/12/edit"), "Should match the name route \"GET /posts/test-post/comments/12/edit\""
    Test.expect router.route?("POST /posts/test-post/comments"), "Should match the named route \"GET /posts/test-post/comments\""
    Test.expect router.route?("PUT /posts/test-post"), "Should match the named route \"GET /posts/test-post\""  
  end
  
  Test.it "does not match non existent routes" do
    Test.expect !router.route?("GET /nope"), "Should not match the non existent route \"GET /nope\""
  end
end

Test.describe "Router#dispatch" do
  Test.it "returns the controller and action for the matched route" do
    Test.assert_equals router.dispatch("GET /home"), ["HomeController", :index]
    Test.assert_equals router.dispatch("GET /posts/test-post/comments/12/edit"), ["CommentsController", :edit]
    Test.assert_equals router.dispatch("POST /posts/test-post/comments"), ["CommentsController", :create]
    Test.assert_equals router.dispatch("PUT /posts/test-post"), ["PostsController", :update]
  end
end

Test.describe "Router#segments" do
  Test.it "returns the named segments as a hash" do
    router.route?("GET /posts/test-post/comments/12/edit")
    Test.assert_equals router.segments, slug: "test-post", id: "12"
    
    router.route?("POST /posts/test-post/comments")
    Test.assert_equals router.segments, slug: "test-post"
  end
end