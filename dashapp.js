var app = angular.module('wexdashboard', ['DataService']);

app.controller('MainController', function($scope,$rootScope, billingService) {

$scope.cell = {
        evaluator: "TX"
    };
    $scope.evaluators = [{
        name: "IN"
    }, {
        name: "TX"
    }];
    $scope.getEvaluators = function () {

        return $scope.evaluators;
    };


    $scope.selectMapCounty = "";
    $scope.selectedstateCode = "";
    $scope.topFirmAnomaliesData = [];
   function init() {
    $scope.populatestatedata = billingService.getServiceData($scope.selectMapState);
  //  console.log("$scope.populatestatedata = " + JSON.stringify($scope.populatestatedata));
   $scope.topFirmAnomaliesData =  billingService.getTableData($scope.selectMapState);
  };
  
  $scope.addCustomer = function (item) {
  $scope.selectedstateCode = item;
 console.log("*********");
      $scope.populatestatedata = billingService.getServiceData($scope.selectedstateCode);
         $scope.topFirmAnomaliesData =  billingService.getTableData($scope.selectedstateCode);
    
 }

	//$scope.populatestatedata = [{"key":"TX","value":220200},{"key":"NM","value":110200},{"key":"IN","value":3434322}];
 $scope.$watch("selectMapCounty",function (oldValue,newValue) {
       if(oldValue != newValue){
       	//$scope.selectMapCounty = newValue ;
        $scope.populatestatedata = billingService.getServiceData($scope.selectMapCounty);
        $scope.topFirmAnomaliesData =  billingService.getTableData($scope.selectMapCounty);
       }
       console.log("selectedMApcounty = " + $scope.selectMapCounty);
    }, true);

	// method to update the data when state is selected. Pull everthing for that state and render county map.
   $scope.$watch('$rootScope.selectedstateCode',function (oldValue,newValue) {
   $scope.selectedstateCode = $rootScope.selectedstateCode;
   console.log("watched value = " + $scope.selectedstateCode);
        console.log("oldValue value = " + oldValue);
        console.log("newValue value = " + newValue);
         if(oldValue != newValue){
         $scope.populatestatedata = billingService.getServiceData($scope.selectedstateCode);
         $scope.topFirmAnomaliesData =  billingService.getTableData($scope.selectedstateCode);
         }
//        if($scope.selectMapState == "tx"){
 //       $scope.populatestatedata = [{"key":"Carson","value":12020},{"key":"Potter","value":323421},{"key":"Gray","value":444444}];
 //        }
    }, true);
   // method to update the data when counties are selected.
   init();
});


app.directive('hcMap', function($window,billingService) {
return {
    restrict: 'C',
    replace: true,
    scope: {
        dataselect: '=',
        changeme: '='
    },
    template: '<div id="container" style="margin: 0 auto">not working</div>',
    link: function(scope, element, attrs) {
        var data = Highcharts.geojson(Highcharts.maps['countries/us/us-all']),
            // Some responsiveness
            small = $('#container').width() < 400;
        // Set drilldown pointers
        dataselect = scope.dataselect;
      //  console.log("dataselect = " + JSON.stringify(dataselect));
        $.each(data, function(i) {
            // retrieve the state data from wex and color the states.
            this.drilldown = this.properties['hc-key'];
            postalcode = this.properties['postal-code'];
            mycolor = "";
            myvalue = "";
            $.each(dataselect, function(i) {
                if (postalcode == dataselect[i].key) {
                    myvalue = dataselect[i].value;
                    mycolor = "#c31820";
                }
            });
            this.value = myvalue;
            this.color = mycolor;
        });

        Highcharts.mapChart('container', {
            chart: {
                events: {
                    drilldown: function(e) {
                        if (!e.seriesOptions) {
                            var chart = this,
                                mapKey = 'countries/us/' + e.point.drilldown + '-all',
                                selectedState = e.point.drilldown,
                                // Handle error, the timeout is cleared on success
                                fail = setTimeout(function() {
                                    if (!Highcharts.maps[mapKey]) {
                                        chart.showLoading('<i class="icon-frown"></i> Failed loading ' + e.point.name);

                                        fail = setTimeout(function() {
                                            chart.hideLoading();
                                        }, 1000);
                                    }
                                }, 3000);

                            // Show the spinner

                            chart.showLoading('<i class="icon-spinner icon-spin icon-3x"></i>'); // Font Awesome spinner

                            // Load the drilldown map
                            // console.log("mapKey = " + mapKey);
                            $.getScript('https://code.highcharts.com/mapdata/' + mapKey + '.js', function() {
                                data = Highcharts.geojson(Highcharts.maps[mapKey]);
                                console.log("selectedState = " + selectedState);
                                var selectedPoints = [];
                                // Set a data values for the heatmap spending
                                dataselect = scope.dataselect;
                                //       console.log("dataselect in county = " +JSON.stringify(data));
                                $.each(data, function(i) {
                                    // retrieve the county data from wex and color the counties.
                                    countyname = this.name;
                                    mycolor = "";
                                    myvalue = "";
                                    $.each(dataselect, function(i) {
                                        //   console.log("dataselect = " + JSON.stringify(dataselect) + " postalcode =" + postalcode);
                                        if (countyname == dataselect[i].key) {
                                            myvalue = dataselect[i].value;
                                            mycolor = "green";
                                        }
                                    });
                                    this.value = myvalue;
                                    this.color = mycolor;
                                });

                                // Hide loading and add series
                                chart.hideLoading();
                                clearTimeout(fail);
                                chart.addSeriesAsDrilldown(e.point, {
                                    allowPointSelect: true,
                                    point: {
                                        events: {
                                            select: function() {
                                                var chart = this.series.chart;
                                                var selectedPoints = chart.getSelectedPoints();
                                                selectedPoints.push(this);
                                                var selectedPointsStr = [];
                                                // For county select
                                                scope.$apply(function() {
                                                    $.each(selectedPoints, function(i, value) {
                                                        selectedPointsStr.push(value.name);
                                                    });
                                                    scope.$parent.selectMapCounty = selectedPointsStr;
                                                })
                                            },

                                            unselect: function() {
                                                //var text = this.value,
                                                var chart = this.series.chart;
                                                // if (!chart.unselectedLabel) {
                                                //    chart.unselectedLabel = chart.renderer.label(text, 0, 300)
                                                //       .add();
                                                //} else {
                                                //   chart.unselectedLabel.attr({
                                                //      text: text
                                                // });
                                                // }
                                                var selectedPoints = chart.getSelectedPoints();
                                                //  selectedPoints.push(this);
                                                var selectedPointsStr = [];
                                                // For county select
                                                scope.$apply(function() {
                                                    $.each(selectedPoints, function(i, value) {
                                                        selectedPointsStr.push(value.name);
                                                    });
                                                    scope.$parent.selectMapCounty = selectedPointsStr;
                                                })
                                            }
                                        }
                                    },
                                    name: e.point.name,
                                    borderColor: '#ffffff',
                                    data: data,
                                    credits: {
                                        enabled: false
                                    },
                                    dataLabels: {
                                        enabled: false,
                                        format: '{point.name}'
                                    }
                                });
                            });
                        }
                        scope.$apply(function() {
                            var split = mapKey.split("-");
                            if (split.length === 3) {
                                extracted = split[1];
                            }
                          //  console.log("extracted = " + extracted);
                            //scope.$parent.selectedstateCode = extracted;
                        //    billingService.setStateData(extracted);
                          //  console.log("scope.$parent.selectedstateCode" + scope.$parent.selectedstateCode);
                            scope.$parent.addCustomer(extracted);
                        });
                    },
                    drillup: function() {
                        scope.$apply(function() {
                            scope.$parent.selectedstateCode = "";
                        });
                    }
                }
            },

            title: {
                text: ''
            },
            subtitle: false,
            legend: {
                enabled: false
            },
            credits: {
                enabled: false
            },
            colorAxis: {
                min: 0,
                minColor: '#cbcbcb',
                maxColor: '#cbcbcb'
            },

            mapNavigation: {
                enabled: true,
            },

            plotOptions: {
                map: {
                    states: {
                        hover: {
                            color: '#029fdb'
                        },
                        select: {
                            color: '#c31820',
                            borderColor: '#ffffff',
                            dashStyle: 'solid'
                        }
                    }
                }
            },

            series: [{
                data: data,
                name: 'USA',
                borderColor: '#ffffff',
                dataLabels: {
                    enabled: false,
                    format: '{point.properties.postal-code}'
                }
            }],

            drilldown: {
                activeDataLabelStyle: {
                    color: '#ffffff',
                    textDecoration: 'none',
                    textOutline: '0px #000000'
                },
                drillUpButton: {
                    relativeTo: 'spacingBox',
                    position: {
                        x: 0,
                        y: 60
                    }
                }
            }
        })
        scope.$watch("changeme", function (newValue) {
              // chart.series[0].setData(newValue, true);
              if(newValue == 'TX') {
                console.log("i am updating");
               var chart = $('#container').highcharts();
               var data = chart.series[0].data;
               var dataselect = [{"key":"TX","value":220200},{"key":"FL","value":110200},{"key":"PA","value":3434322}];
               $.each(data, function(i) {
                // retrieve the state data from wex and color the states.
                this.drilldown = this.properties['hc-key'];
                postalcode = this.properties['postal-code'];
                mycolor = "";
                myvalue = "";
                $.each(dataselect, function(i) {
                    if (postalcode == dataselect[i].key) {
                        myvalue = dataselect[i].value;
                        mycolor = "#c31820";
                    }
                });
                this.value = myvalue;
                this.color = mycolor;
            });

            chart.series[0].setData(data);
            //    chart.series[0].update({
            //     borderColor: '#f31820' 
            
            // });
           } else {
            console.log("i am in else");
            var chart = $('#container').highcharts();
            var data = chart.series[0].data;
            console.log(data);
               var dataselect = [{"key":"Dallam","value":220200},{"key":"Sherman","value":110200},{"key":"Hansford","value":3434322}];
               $.each(data, function(i) {
                                    // retrieve the county data from wex and color the counties.
                                    countyname = this.name;
                                    mycolor = "";
                                    myvalue = "";
                                    $.each(dataselect, function(i) {
                                         console.log("dataselect = " + JSON.stringify(dataselect) + " countyname =" + countyname);
                                        if (countyname == dataselect[i].key) {
                                            myvalue = dataselect[i].value;
                                            mycolor = "green";
                                        }
                                    });
                                    this.value = myvalue;
                                    this.color = mycolor;
                                });
                chart.series[0].setData(data);
           }
          }, true);
    }
  }
  });


var DataService = angular.module('DataService', [])
    .service('billingService', function ($http,$q,$rootScope) {
    return({
          getServiceData: getServiceData,
          getTableData:getTableData,
          setStateData:setStateData
      });

   function  getServiceData(item) {
    console.log("item = " + item);
    var populatestatedata = [];
    if(item == "tx") {
			populatestatedata = [{"key":"Carson","value":12020},{"key":"Potter","value":323421},{"key":"Gray","value":444444}];
     } else if(item == "us-tx"){
    } else {
    populatestatedata = [{"key":"TX","value":220200},{"key":"NM","value":110200},{"key":"IN","value":3434322}];
    }
    return populatestatedata;
//    return(request.then( handleSuccess, handleError ) );
  }

 function  getTableData(item) {
    var tabdata = [];

    if(item == "tx") {
			tabdata = [{"name":"LLP","value": "4998040.0"},{"name":"PC","value": "2735750.0"},{"name":"Atlas, Rodriguez LLP","value": "2023560.0"},{"name":"Ortiz &amp; Batis, PC","value": "1633450.0"},{"name":"Lindow Stephens Treat, LLP","value": "1539570.0"},{"name":"Quinn Emanuel Urquhart &amp; Sullivan, LLP","value": "1247550.0"}];
     } else if(item == "Potter"){
     tabdata = [{"name":"LLPdfasfd","value": "4998040.0"},{"name":"PasfafC","value": "2735750.0"},{"name":"Atlas,sfasf Rodriguez LLP","value": "2023560.0"},{"name":"Ortiz asfaf&amp; Batis, PC","value": "1633450.0"},{"name":"Lindow Stephens Treat, LLP","value": "1539570.0"},{"name":"Quinn Emanuel Urquhart &amp; Sullivanasf, LLP","value": "1247550.0"}];
    } else {
 tabdata = [{"name":"Sedgwick LLP","value": "4998040.0"},{"name":"Winstead PC","value": "2735750.0"},{"name":"Atlas, Hall &amp; Rodriguez LLP","value": "2023560.0"},{"name":"Ortiz &amp; Batis, PC","value": "1633450.0"},{"name":"Lindow Stephens Treat, LLP","value": "1539570.0"},{"name":"Quinn Emanuel Urquhart &amp; Sullivan, LLP","value": "1247550.0"}]
    }
     return tabdata
}
 function  setStateData(item) {
   $rootScope.selectedstateCode = item;
    return $rootScope.selectedstateCode;
//    return(request.then( handleSuccess, handleError ) );
  }

	function handleError( response ) {
        if (
            ! angular.isObject( response.data ) ||
            ! response.data.message
            ) {
            return( $q.reject( "An unknown error occurred." ) );
        }
        return( $q.reject( response.data.message ) );
    }
    function handleSuccess( response ) {
      return( response.data);
    }
 });
