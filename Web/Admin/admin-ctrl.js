var app = angular.module("computer", ["ngRoute"])
.config(["$routeProvider",function($routeProvider){
	$routeProvider.
		when("/updateclient",{
			templateUrl: "updateclient.html",
			controller: "AdminCtrl"
		}).
		when("/deleteclient",{
			templateUrl: "deleteclient.html",
			controller: "AdminCtrl"
		}).
		when("/updateemployee",{
			templateUrl: "updateemployee.html",
			controller: "AdminCtrl"
		}).
		when("/createemployee",{
			templateUrl: "createemployee.html",
			controller: "AdminCtrl"
		}).
		when("/deleteemployee",{
			templateUrl: "deleteemployee.html",
			controller: "AdminCtrl"
		}).
		when("/updatemed",{
			templateUrl: "updatemed.html",
			controller: "AdminCtrl"
		}).
		when("/createmed",{
			templateUrl: "createmed.html",
			controller: "AdminCtrl"
		}).
		when("/deletemed",{
			templateUrl: "deletemed.html",
			controller: "AdminCtrl"
		}).
		when("/updatesuc",{
			templateUrl: "updatesuc.html",
			controller: "AdminCtrl"
		}).
		when("/createsuc",{
			templateUrl: "createsuc.html",
			controller: "AdminCtrl"
		}).
		when("/deletesuc",{
			templateUrl: "deletesuc.html",
			controller: "AdminCtrl"
		}).
		when("/updaterol",{
			templateUrl: "updaterol.html",
			controller: "AdminCtrl"
		}).
		when("/createrol",{
			templateUrl: "createrol.html",
			controller: "AdminCtrl"
		}).
		when("/deleterol",{
			templateUrl: "deleterol.html",
			controller: "AdminCtrl"
		});
	}])

.controller("AdminCtrl",["$scope", "$http", function($scope, $http){
	
        $scope.updateClient = function(){
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
	var titles = [
	{title: "Clientes", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Empleados", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Medicamentos", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Roles", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	{title: "Sucursales", option1: "Crear", option2: "Actualizar", option3: "Eliminar"},
	];
	$scope.titles = titles
}]);

