var app = angular.module("computer", ["ngRoute"])

.config(["$routeProvider", function($routeProvider){
	$routeProvider.
		when("/",{
			templateUrl: "login.html",
		}).
		otherwise({
			redirectTo: "/"
		});
	}])

.controller("LogCtrl",["$scope", "$http",function($scope, $http, $location, MyService){
        $scope.login = function(){
       
        	var data = {user: user = parseInt($scope.user, 10),
				pass: $scope.pass};
			console.log($scope.user);
			if($scope.leader==true){
				$http.post("http://localhost:55100/api/client?codigo=C00", data).
        		then(function(response) {
            		$scope.greet = response.data;
            		console.log(response)
            		        	if($scope.greet.codigo == 200){
        		if($scope.greet.tipo == "Cliente"){
        			var res = JSON.stringify($scope.data);
					for(i in res){
						var res = res.replace(/:/,"=");
						var res = res.replace("\"","");
						var res = res.replace("{","");
						var res = res.replace("}","");
						var res = res.replace(",","&");
					}
					window.location.href = "Client/index.html?"+res;
        		}
        		else{
        			if($scope.greet.rol == "Administrador"){
        				var res = JSON.stringify($scope.data);
						for(i in res){
							var res = res.replace(/:/,"=");
							var res = res.replace("\"","");
							var res = res.replace("{","");
							var res = res.replace("}","");
							var res = res.replace(",","&");
						}
						window.location.href = "Admin/index.html?"+res;
	        			}
	        		if($scope.greet.rol == "Dependiente"){
	        			var res = JSON.stringify($scope.data);
						for(i in res){
							var res = res.replace(/:/,"=");
							var res = res.replace("\"","");
							var res = res.replace("{","");
							var res = res.replace("}","");
							var res = res.replace(",","&");
						}
						window.location.href = "Sucursal/index.html?"+res;
	        		}


        		}
        	}
        		});
			}else{
				$http.post("http://localhost:55100/api/empleado?codigo=E04", data).
        		then(function(response) {
            		$scope.greet = response.data;
            		if($scope.greet.codigo == 200){
        		if($scope.greet.tipo == "Cliente"){
        			var res = JSON.stringify($scope.data);
					for(i in res){
						var res = res.replace(/:/,"=");
						var res = res.replace("\"","");
						var res = res.replace("{","");
						var res = res.replace("}","");
						var res = res.replace(",","&");
					}
					window.location.href = "Client/index.html?"+res;
        		}
        		else{
        			if($scope.greet.Roll == "Administrador"){
        				var res = JSON.stringify($scope.data);
						for(i in res){
							var res = res.replace(/:/,"=");
							var res = res.replace("\"","");
							var res = res.replace("{","");
							var res = res.replace("}","");
							var res = res.replace(",","&");
						}
						window.location.href = "Admin/index.html?"+res;
	        			}
	        		if($scope.greet.Roll == "Dependiente"){
	        			var res = JSON.stringify($scope.data);
						for(i in res){
							var res = res.replace(/:/,"=");
							var res = res.replace("\"","");
							var res = res.replace("{","");
							var res = res.replace("}","");
							var res = res.replace(",","&");
						}
						window.location.href = "Sucursal/index.html?"+res;
	        		}


        		}
        	}
        		});
			}
        	

        	
        	
        };
}]);
