angular.module('myApp.controllers', [])
.controller('HomeController', function($scope, session, SessionService, Share, ArticleService){
	$scope.user = session.user;
	
	ArticleService.getLatestFeed()
	.then(function(data){
		$scope.articles = data;
	})
});