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
		$scope.update = function(){
        	var Data ={cedula:2015019679,
		fNacimiento:"03-05-1997",
		contraseña:"12345",
		nombre1:"Alex",
		nombre2:"Campos",
		apellido1:"Valverde",
		apellido2:"Valverde",
		provincia:"Cartago",
		canton:"Cartago",
		distrito:"Oriental",
		indicaciones:"150 metros norte de la iglesia",
		telefono:60083548};
        	$http.put("http://localhost:55100/api/client?codigo=C02", Data).
        	then(function(response) {
            	$scope.greet = response.data;
            	console.log($scope.greet)
        	});
        	
        };
        $scope.create = function(){
        	var Data ={cedula:2015019679,
		fNacimiento:"03-05-1997",
		contraseña:"12345",
		nombre1:"Alex",
		nombre2:"Campos",
		apellido1:"Valverde",
		apellido2:"Valverde",
		provincia:"Cartago",
		canton:"Cartago",
		distrito:"Oriental",
		indicaciones:"150 metros norte de la iglesia",
		telefono:60083548};
        	$http.post("http://localhost:55100/api/client?codigo=C02", Data).
        	then(function(response) {
            	$scope.greet = response.data;
            	console.log($scope.greet)
        	});
        	
        };
}])

.controller("MainCtrl",["$scope", function($scope){
	console.log(window.location.href);
	$scope.data = {};
	window.location.search.replace(/\?/,'').split('&').map(function(o){ $scope.data[o.split('=')[0]]= o.split('=')[1]});
	
	console.log($scope.data);
	var titles = [
	{title: "Recetas", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Pedidos", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	];
	$scope.titles = titles
}]);

