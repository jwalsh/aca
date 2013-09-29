angular.module("project", ["firebase"]).value("fbURL", "https://angularjs-projects.firebaseio.com/").factory("Projects", (angularFireCollection, fbURL) ->
  angularFireCollection fbURL
).config ($routeProvider) ->
  $routeProvider.when("/",
    controller: ListCtrl
    templateUrl: "list.html"
  ).when("/edit/:projectId",
    controller: EditCtrl
    templateUrl: "detail.html"
  ).when("/new",
    controller: CreateCtrl
    templateUrl: "detail.html"
  ).otherwise redirectTo: "/"


ListCtrl = ($scope, Projects) ->
  $scope.projects = Projects

CreateCtrl = ($scope, $location, $timeout, Projects) ->
  $scope.save = ->
    Projects.add $scope.project, ->
      $timeout ->
        $location.path "/"

EditCtrl = ($scope, $location, $routeParams, angularFire, fbURL) ->
  angularFire(fbURL + $routeParams.projectId, $scope, "remote", {}).then ->
    
    $scope.project = angular.copy($scope.remote)
    $scope.project.$id = $routeParams.projectId
    $scope.isClean = ->
      angular.equals $scope.remote, $scope.project

    $scope.destroy = ->
      $scope.remote = null
      $location.path "/"

    $scope.save = ->
      $scope.remote = angular.copy($scope.project)
      $location.path "/"




