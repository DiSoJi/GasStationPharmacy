var app = angular.module("computer", ["ngRoute"])

.config(["$routeProvider", function($routeProvider){
	$routeProvider.
		when("/update",{
			templateUrl: "update.html",
			controller: "AdminCtrl"
		}).
		when("/create",{
			templateUrl: "create.html",
			controller: "AdminCtrl"
		}).
		when("/delete",{
			templateUrl: "delete.html",
			controller: "AdminCtrl"
		});
	}])

.controller("AdminCtrl",["$scope", "$http", function($scope, $http){
	

	$http.get('http://date.jsontest.com/').
        then(function(response) {
            $scope.greet = response.data;
        });
        $scope.ejemplo = function(){
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
}])

.controller("MainCtrl",["$scope", function($scope){
	var titles = [
	{title: "Clientes", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Empleados", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Medicamentos", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Roles", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Sucursales", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	];
	$scope.titles = titles
}]);

