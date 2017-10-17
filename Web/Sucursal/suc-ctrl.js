var app = angular.module("computer", ["ngRoute"])

.config(["$routeProvider", function($routeProvider){
	$routeProvider.
		when("/update",{
			templateUrl: "update.html",
			controller: "ClientCtrl"
		}).
		when("/create",{
			templateUrl: "create.html",
			controller: "ClientCtrl"
		}).
		when("/delete",{
			templateUrl: "delete.html",
			controller: "ClientCtrl"
		});
	}])

.controller("ClientCtrl",["$scope", "$http", function($scope, $http){
	$http.get('http://date.jsontest.com/').
        then(function(response) {
            $scope.greet = response.data;
            $scope.type = "Estado"
        });
        $scope.nuevos = function(){
        	$scope.type = "Nuevos"
        };
        $scope.preparados = function(){
        	$scope.type = "Preparados"
        };
        $scope.facturados = function(){
        	$scope.type = "Facturados"
        };
        $scope.retirados = function(){
        	$scope.type = "Retirados"
        };


}])

.controller("MainCtrl",["$scope", function($scope){
	var titles = [
	{title: "Recetas", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Pedidos", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	];
	$scope.titles = titles
}]);

