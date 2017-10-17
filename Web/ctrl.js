var app = angular.module("computer", ["ngRoute"])

.config(["$routeProvider", function($routeProvider){
	$routeProvider.
		when("/",{
			templateUrl: "login.html",
		}).
		when("/delete",{
			templateUrl: "Admin/index.html",
		}).
		otherwise({
			redirectTo: "/"
		});
	}])

.controller("LogCtrl",["$scope", "$http", "$location", function($scope, $http, $location){
        $scope.login = function(){
        	console.log("Funca")
        	window.location.href = "Sucursal/index.html"
        };
}]);
