var app = angular.module('wexdashboard', ['datamaps','DataService','ui.router','ui.bootstrap','ui.tree','wexdashboard.directives','wexdashboard.services']);
  app.config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('all');
  $stateProvider
  .state('allstate', {
    url: '/all',
    templateUrl:'/AppBuilder/dashapp/src/views/dashboard/dashboardview.html',
    controller: 'MainController'
  })
});

app.controller('MainController', ['$scope','$state','billingService',function($scope,$state,billingService){

function getStateMapCoordinates(stateM) {
var centerS = "";
var scaleS = "";
console.log("state selected = " + stateM);
// center is always longitude, latitude. // NH is not working right now. Need to put a fix. 
var statemapcoordinates = {
 "AL": {"center": [-80.9000,32.3200],"scale": 3000},
 "AK": {"center": [-145.0000,65.0000],"scale": 500},
 "AZ": {"center": [-104.042503,32.000263],"scale": 1800},
 "AR": {"center": [-86.473842,33.501861],"scale": 3000},
 "CA": {"center": [-112.233256,36.006186],"scale": 1500},
 "CO": {"center": [-99.919731,38.003906],"scale": 2200},
 "CT": {"center": [-67.053528,41.039048],"scale": 5500},
 "DE": {"center": [-70.414089,38.804456],"scale": 6000},
 "DC": {"center": [-77.035264,38.993869],"scale": 6000},
 "FL": {"center": [-76.497137,26.997536],"scale": 2500},
 "GA": {"center": [-78.109191,32.00118],"scale": 3000},
 "HI": {"center": [-150.634835,18.948267],"scale": 2500},
 "ID": {"center": [-108.04751,44.000239],"scale": 2000},
 "IL": {"center": [-82.639984,39.510065],"scale": 2400},
 "IN": {"center": [-79.990061,38.759724],"scale": 3100},
 "IA": {"center": [-88.368417,41.501391],"scale": 3000},
 "KS": {"center": [-92.90605,37.001626],"scale": 2500},
 "KY": {"center": [-79.903347,36.769315],"scale": 2800},
 "LA": {"center": [-86.608485,30.018527],"scale": 3000},
 "ME": {"center": [-63.703921,44.057759],"scale": 2500},
 "MD": {"center": [-71.994645,37.95325],"scale": 4000},
 "MA": {"center": [-66.917521,41.887974],"scale": 5000},
 "MI": {"center": [-80.454238,43.732339],"scale": 2200},
 "MN": {"center": [-88.014696,45.705401],"scale": 2200},
 "MS": {"center": [-83.471115,31.995703],"scale": 3000},
 "MO": {"center": [-86.833957,37.609566],"scale": 2500},
 "MT": {"center": [-103.047534,45.000239],"scale": 1400},
 "NE": {"center": [-94.324578,40.002989],"scale": 2200},
 "NV": {"center": [-109.027882,38.000709],"scale": 1800},
 "NH": {"center": [-65.50183,43.303304],"scale": 4000},
 "NJ": {"center": [-69.236547,39.75083],"scale": 5000},
 "NM": {"center": [-99.421329,33.000263],"scale": 2000},
 "NY": {"center": [-70.343806,42.013027],"scale": 2500},
 "NC": {"center": [-73.978661,33.562108],"scale": 2300},
 "ND": {"center": [-95.228743,47.000239],"scale": 2500},
 "OH": {"center": [-77.518598,39.978802],"scale": 3500},
 "OK": {"center": [-93.507706,34.000263],"scale": 2500},
 "OR": {"center": [-114.211348,43.174138],"scale": 2000},
 "PA": {"center": [-72.10278,40.252649],"scale": 3000},
 "RI": {"center": [-66.196845,41.30757],"scale": 7000},
 "SC": {"center": [-74.764143,32.066903],"scale": 3000},
 "SD": {"center": [-95.047534,42.944106],"scale": 2500},
 "TN": {"center": [-81.054868,33.496384],"scale": 2500},
 "TX": {"center": [-94, 31],"scale": 1400},
 "UT": {"center": [-105.164359,38.995232],"scale": 2500},
 "VT": {"center": [-65.503554,42.503027],"scale": 3000},
 "VA": {"center": [-74.349729,36.464886],"scale": 3000},
 "WA": {"center": [-114.033359,46.000239],"scale": 2000},
 "WV": {"center": [-74.518598,37.636951],"scale": 3000},
 "WI": {"center": [-84.415429,43.568478],"scale": 2500},
 "WY": {"center": [-101.500842,42.002073],"scale": 2200}
};

   angular.forEach(statemapcoordinates, function(value, key) {
       if(key==stateM) {
         centerS = value.center;
         scaleS = value.scale;
       }
    });
    return {
      'projectcenter': centerS,
      'projectscale': scaleS
    };
};
$scope.selectedmapState = "All";
$scope.selectedstateCode = "";
$scope.spendingHours = "";
$scope.billedHours = "";
$scope.spendingHours = "";
$scope.violationHours = "";
$scope.topTrackedMatters = "";
$scope.topStateExpenditureData = "";
$scope.topFirmAnomaliesData = "";
$scope.dataSpendingByBudgetLoaded = false;
$scope.dataHoursBilledLoaded = false;
$scope.dataViolationsLoaded = false;
$scope.dataTrackedMattersLoaded = false;
$scope.dataTopExpendituresLoaded = false;
$scope.dataTopAnamoliesLoaded = false;
$scope.filterDefaultDate = getDefaultPreviousYearDateRange() ; //"01/01/2016-12/31/2016";
$scope.billingHoursDefaultDate = getDefaultPreviousYearDateRange(); //"01/01/2016-12/31/2016";
//$scope.violationHoursDefaultDate = getDefaultDateRange(); //"01/01/2016-12/31/2016";
var dateFormat = 'MM/DD/YYYY';
var spendingHoursCurrencyFormat = d3.format("$,.3s");
$scope.sortDateKey = "";
$scope.selectValueDisplay = "Year";
var dList = getDateList();
$scope.list  = dList;
$scope.categories = [];
$scope.billcategories = [];
$scope.spendingcategories = [];
$scope.violationcategories = [];

$scope.setPeriod = function(selectedDate)
{
    if(selectedDate != "") {
      $scope.filterDefaultDate = selectedDate;
      $scope.sortDateKey = "";
      $scope.billingHoursDefaultDate = getSelectedFilterDate(selectedDate,$scope.sortDateKey);
      loadSpendingBudgetData($scope.selectedstateCode,$scope.filterDefaultDate);
      loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
      loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
      loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
      loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
      loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
      $scope.show_DropDown = false;
      for(i=0;i<=$scope.list.length;i++) {
        if($scope.list[i].id == selectedDate) {
          $scope.selectValueDisplay = $scope.list[i].title;
        }
      }
    }
}

function getDefaultPreviousYearDateRange() {
  var defaultDateRange = "", previousYear;
  previousYear = moment().format("YYYY")-1;
  defaultDateRange = "01/01/" +(previousYear) + "-" + "12/31/"+(previousYear);
  return defaultDateRange;
}

function getSelectedFilterDate(selectedDateRange,sortDateKey) {
  var dataForFilter = [];
  var tmpDate = selectedDateRange.split('-'),
  fromDate = "",toDate="",duration="",newFilteredRange="",finalDateRange="",tmpfromdate="";
  fromDate = moment(tmpDate[0], dateFormat);
  toDate =  moment(tmpDate[1], dateFormat);
  duration = toDate.diff(fromDate, 'days')
  if(duration <=31) {
    tmpfromdate = moment(fromDate).subtract('month',1).format(dateFormat)
    if(sortDateKey == "") {
      newFilteredRange = tmpfromdate + "-" + moment(toDate, dateFormat).format(dateFormat);
    } else {
      dataForFilter.push(tmpfromdate);
      dataForFilter.push(moment(tmpfromdate).endOf('month').format(dateFormat));
      dataForFilter.push(moment(fromDate, dateFormat).format(dateFormat));
      dataForFilter.push(moment(toDate, dateFormat).format(dateFormat));
    }
  }
  else if(duration > 31  && duration <=90) {
    tmpfromdate = moment(fromDate).subtract('month',3).format(dateFormat)
    if(sortDateKey == "") {
      newFilteredRange = tmpfromdate + "-" + moment(toDate, dateFormat).format(dateFormat);
    } else {
      dataForFilter.push(tmpfromdate);
      dataForFilter.push(moment(tmpfromdate).endOf('quarter').format(dateFormat));
      dataForFilter.push(moment(fromDate, dateFormat).format(dateFormat));
      dataForFilter.push(moment(toDate, dateFormat).format(dateFormat));
    }
  } else {
      tmpfromdate = moment(fromDate).subtract('year',1).format(dateFormat)
      if(sortDateKey == "") {
      newFilteredRange = tmpfromdate + "-" + moment(toDate, dateFormat).format(dateFormat); //selectedDateRange;
    } else {
      dataForFilter.push(tmpfromdate);
      dataForFilter.push(moment(tmpfromdate).endOf('year').format(dateFormat));
      dataForFilter.push(moment(fromDate, dateFormat).format(dateFormat));
      dataForFilter.push(moment(toDate, dateFormat).format(dateFormat));
    }
  }
  //console.log("getSelectedFilterDate = " + newFilteredRange);
  //console.log("dataForFilter = " + dataForFilter);
  if(sortDateKey == "") {
    return newFilteredRange;
  }
  else {
    return dataForFilter;
  }

}

function getDateLabels(startDate,endDate) {
  var fromDate = "",toDate="",diff="",labelChart = [];
  fromDate = moment(startDate, dateFormat);
  toDate =  moment(endDate, dateFormat);
  diff = toDate.diff(fromDate, 'days')
  if(diff >=364){
    labelChart.push(moment(toDate).format("[FY] YYYY"));
  }
  if(diff <=31) {
    labelChart.push(moment(toDate).format("MMM YYYY"));
  }
  else if(diff > 31) {
  labelChart.push(moment(toDate).format("[Q]Q YYYY"));
  }
  return labelChart;
}

// get the view by date calculation
function getDateList()
{
var dList = [];
currentYear = moment().format("YYYY")-1;
for( i = 0 ; i <2; i++)
{
	var item = new Object();
	item.id = "01/01/" +(currentYear - i) + "-" + moment("01/01/"+(currentYear - i)).endOf("year").format(dateFormat);
	item.title = (currentYear - i);
	item.items = [];
	for(j = 1 ; j < 12; j+=3)
	{
		qDateStr = "0"+j +"/01/"+(currentYear - i);
		if(moment().fquarter(1).start > moment(qDateStr).fquarter(1).start)
		{
			var qItem = new Object();
			qItem.id = moment(moment(qDateStr).fquarter(1).start).format(dateFormat) +"-"+ moment(moment(qDateStr).fquarter(1).end).format(dateFormat);
			qItem.title = moment(qDateStr).fquarter(1).toString();
			qItem.items = [];
			for(k = j ; k < j+3; k++)
			{
				var mItem = new Object();
				startDateStr = "";
				if(k < 10)
				{
					startDateStr = "0"+k +"/01/"+(currentYear - i);
					}
					else
					{
									startDateStr = k +"/01/" + (currentYear - i);
					}
					mItem.id = moment(startDateStr).format(dateFormat) +"-"+ moment(startDateStr).endOf("month").format(dateFormat);
					mItem.title = moment(startDateStr).format("MMM");
					qItem.items.push(mItem)
			}
			item.items.push(qItem)
		}
	}
	dList.push(item);
	}
	return dList;
}

$scope.resetToAllStates = function(allstatekey) {
 // console.log("inside resetToAllStates = " + allstatekey);
  $scope.selectedstateCode = "";
  $scope.sortDateKey = "";
  loadMap(allstatekey,$scope.selectedstateCode);
  loadSpendingBudgetData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
  loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
  loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
  loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
  loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
  loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
}

function init() {
     $scope.sortDateKey = "";
     $scope.billingHoursDefaultDate = getSelectedFilterDate($scope.billingHoursDefaultDate,$scope.sortDateKey);
  //   console.log("init " + $scope.billingHoursDefaultDate);
     loadMap($scope.selectedmapState,$scope.selectedstateCode);
     loadSpendingBudgetData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
     loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
     loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
     loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
     loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
     loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
  };

function loadSpendingBudgetData(selectedStateS,filterdate){

    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = "";
    var selectedkpiS = "netamount";
    var subcategoryS = "firmname";
    var datefilterS = filterdate;
    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
                var spendingByBudget = d3.nest()
               .rollup(function(v) { return d3.sum(v, function(d) { return d.value; }); })
               .entries(mydata);
             //   $scope.spendingcategories = ['FY-2015','FY-2016'];
                //$scope.spendingHours = [{"key":"FY 2015","data":[4121586,2321234],"color":"#c31820"},{"key":"FY 2016","data":[7641018,8473621],"color":"#cbcbcb"}];
            //    $scope.spendingHours = [{"key":"","y":4121586,"color":"#c31820"},{"key":"","y":7641018,"color":"#cbcbcb"}];
                //$scope.spendingHours = [4121586,2321234,7641018,8473621];
               $scope.spendingHours = spendingHoursCurrencyFormat(spendingByBudget);
              // console.log("$scope.spendingHours" + JSON.stringify($scope.spendingHours));
               $scope.dataSpendingByBudgetLoaded = true;
             });
      };


  function loadBillingHoursData(selectedStateS,filterdate){
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = "";
    var selectedkpiS = "hours";
    var subcategoryS = "itemdate";
    var datefilterS = filterdate;

    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
                $scope.billedHours =  getFormattedJson(mydata,$scope.filterDefaultDate);
                $scope.billcategories = setCategoriesLabel($scope.billedHours);
                $scope.dataHoursBilledLoaded = true;
            }
          );
      };

  function getFormattedJson(myServerData,sortDate) {
    fData = [];
    dSorter = getSelectedFilterDate(sortDate,"true");
    totalA = 0;
    totalB = 0;
    var condA = dSorter[0];
    var condB = dSorter[1];
    var condC = dSorter[2];
    var condD = dSorter[3];
    var labelC = [];
    var labelD = [];
    // Get the date and sort the correct json array.
    for (var key in myServerData) {
           if (myServerData.hasOwnProperty(key)) {
              if(moment(myServerData[key].name).isBetween(condC,condD)) {
              totalA = totalA + parseInt(myServerData[key].value);
          }else if(moment(myServerData[key].name).isBetween(condA,condB)) {
              totalB = totalB + parseInt(myServerData[key].value);
           }
          }
        }

        labelC = getDateLabels(condA,condB);
        labelD = getDateLabels(condC,condD);
        fData.push({key:labelC[0],y: totalB, color:"#c31820"},
                 {key:labelD[0],y: totalA, color:"#cbcbcb"});
     // console.log("dSorter array = " + JSON.stringify(fData));
      return fData;
  }

  function setCategoriesLabel(myFData) {
    var tmpArr = [];
    for (var key in myFData) {
       if (myFData.hasOwnProperty(key)) {
         tmpArr.push(myFData[key].key);
      }
    }
    return tmpArr;
  }

  function loadVoilationData(selectedStateS,filterdate){
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = "";
    var selectedkpiS = "AnomalyDollars";
    var subcategoryS = "itemdate";
    var datefilterS = filterdate;

    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
                $scope.violationHours =  getFormattedJson(mydata,$scope.filterDefaultDate);
                $scope.violationcategories = setCategoriesLabel($scope.violationHours);
                $scope.dataViolationsLoaded = true;
            }
          );
      };

 function formatDataForMatterChart(trackedMattersData) {
   var myArr = [];
   var tmpStr = "";
   $scope.categories = [];
   for (var key in trackedMattersData) {
          if (trackedMattersData.hasOwnProperty(key)) {
             var tmpStrKeyValue = '"' + trackedMattersData[key].key + '"';
             var tmpStrCatValue = trackedMattersData[key].key;
             tmpStr = '{name:' + tmpStrKeyValue + ',y:' + trackedMattersData[key].values + '}';
             myArr.push(tmpStr);
             $scope.categories.push(tmpStrCatValue);
          }
       }
   return myArr;
 }
  function loadTrackedMattersData(selectedStateS,filterdate){
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = "";
    var selectedkpiS = "netamount";
    var subcategoryS = "mattername";
    var datefilterS =  filterdate;
    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
            var trackedMatters = d3.nest()
              .key(function(d){ return d.name; })
              .rollup(function(leaves){
                return leaves.map(function(d){
                  return d.y;
                }).sort(d3.descending).slice(0, 3);
            })
            .entries(mydata);
               $scope.topTrackedMatters = formatDataForMatterChart(trackedMatters.slice(0,3));
               $scope.dataTrackedMattersLoaded = true;
            });
      };

  function loadTopFirmExpenditureData(selectedStateS,filterdate){
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = "";
    var selectedkpiS = "netamount";
    var subcategoryS = "firmname";
    var datefilterS = filterdate;
    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
              var topFirmByExpenditures = d3.nest()
              .key(function(d) { return d.name})
              .rollup(function(v) { return d3.sum(v, function(d) { return d.value; }); })
              .entries(mydata);
              var top5Firms = topFirmByExpenditures.slice(0,5);
              $scope.topStateExpenditureData = top5Firms;
              $scope.dataTopExpendituresLoaded = true;
            }
          );
      };

  function loadTopFirmAnamoliesData(selectedStateS,filterdate){
    var datefilterS = filterdate;
     billingService.getAnomaliesData(selectedStateS,datefilterS)
          .then(
            function( mydata ) {
              var topFirmByAnamolies = d3.nest()
               .key(function(d) { return d.name})
               .rollup(function(v) { return d3.sum(v, function(d) { return d.value; }); })
               .entries(mydata);
               var top5Anomalies = topFirmByAnamolies.slice(0,5);
                $scope.topFirmAnomaliesData = top5Anomalies;
                $scope.dataTopAnamoliesLoaded = true;
            }
          );
      };

  function loadMap(selectedmapState,selectedstateCode) {
    if(selectedmapState != "All") {
      var fileUrl = "/AppBuilder/dashapp/src/lib/maps/USA/" + selectedstateCode + ".topo.json";
      var stateObjectName = selectedmapState + '.geo';
      console.log("stateObjectName " + stateObjectName);
      var scaledCenter = getStateMapCoordinates(selectedstateCode);
      $scope.mapObject = {
      geographyConfig: {
            dataUrl: fileUrl
          },
          scope: stateObjectName,
          options: {
            width: 600,
            height: 350,
            legendHeight: 60 // optionally set the padding for the legend
          },
          projection: '',
          setProjection: function(element) {
            var projection = d3.geo.mercator()
               .center(scaledCenter.projectcenter)
               .rotate([4.4, 0])
               .scale(scaledCenter.projectscale)
              // GA -77.60896022270053,32.361291820877184 , scale 2000
              .translate([element.offsetWidth / 2, element.offsetHeight / 2]);
            var path = d3.geo.path().projection(projection);
            return {path: path, projection: projection};
            },
           fills: {
            defaultFill: '#c31820',
            lt50: 'rgba(0,244,244,0.9)',
            gt50: '#c31820'
          },
          // data: {
          //   '071': {fillKey: 'lt50' },
          //   '001': {fillKey: 'gt50' }
          // },
        };
    } else {

    $scope.mapObject = {
        scope: 'usa',
        options: {
          width: 600,
          legendHeight: 60 // optionally set the padding for the legend
        },
        geographyConfig: {
          highlighBorderColor: '#306596',
          highlighBorderWidth: 2
        },
        fills: {
          'HIGH': '#CC4731',
          'MEDIUM': '#c31820',
          'LOW': '#306596',
          'defaultFill': '#DDDDDD'
        },
        data: {
          "IN": {
            "fillKey": "MEDIUM",
          },
          "TX": {
            "fillKey": "MEDIUM",
          }
        },
      };
    }
  }
     $scope.updateActiveState = function(geography) {
      $scope.stateName = geography.properties.name;
      $scope.stateCode = geography.id;
//      console.log("statename = "+$scope.stateName);
      loadMap($scope.stateName,$scope.stateCode);
      loadSpendingBudgetData($scope.stateCode,$scope.filterDefaultDate);
      loadBillingHoursData($scope.stateCode,$scope.billingHoursDefaultDate);
      loadVoilationData($scope.stateCode,$scope.billingHoursDefaultDate);
      loadTrackedMattersData($scope.stateCode,$scope.filterDefaultDate);
      loadTopFirmExpenditureData($scope.stateCode,$scope.filterDefaultDate);
      loadTopFirmAnamoliesData($scope.stateCode,$scope.filterDefaultDate);
      $scope.selectedstateCode = $scope.stateCode;
      $scope.$apply();
    };

    init();
}]);

app.directive('hcBarChart', function($window){
    return {
        restrict: 'EAC',
        replace: true,
        template: '<div id="barcontainer" style="margin: 0 auto;width:120px;height:250px">not working</div>',
        scope: {
            data: '=data',
            cat: '='
        },
        link: function (scope, element) {
           var chart = new Highcharts.chart({
                chart: {
                    type: 'column',
                    renderTo: element[0],
                    marginBottom: 1,
                    marginLeft: 0,
                    marginRight: 0,
                    marginTop: 50
                },
                title: {
                  text: ''
                },
                legend: {
                    enabled: false
                },
                credits: {
                    enabled: false
                },
                xAxis: {
                    categories: scope.cat,
                    title: {
                        text: null
                    },
                    lineWidth: 0,
                    tickWidth: 0,
                    labels: {
                            x : -5,
                            y : -235,
                            align: 'center',
                            formatter: function () {
                    		    var text = this.value
                    		    return '<div title="' + text + '">' + text + '</div></div>';
                    },
                    style: {
                    	    width: '120px',
                          fontWeight: "normal",
                          "font-family": "Roboto",
                          "font-size": "12px",
                          color: "#8e8e8e"
                    },
                    useHTML: true
                  }
                },
                yAxis: {
                    visible:false},
                plotOptions: {
                    column: {
                      dataLabels: {
                          enabled: true,
                          inside: true,
                          align: 'center',
                          verticalAlign:'top',
                          x: 0,
                          shadow: false,
                          color: '#ffffff',
                          style: {
                            "fontWeight": "normal",
                            "font-family": "Roboto",
                            "font-size": "16px"

                        },
                        formatter: function () {
                          var currencyFormat = d3.format(".3s");
                          return currencyFormat(this.y);
                        }
                      },
                      pointWidth: 60,
                      pointPadding: 0,
                      groupPadding: 0.3,
                      borderWidth: 1,
                      }
                },
                series: [{
                    data: scope.data
                }]
            });
            scope.$watch("data", function (newValue) {
               chart.series[0].setData(newValue, true);
               chart.xAxis[0].setCategories(scope.cat, true, true);
          }, true);
        }
    };
});

app.directive('hcHbChart', function($window){
    return {
        restrict: 'EAC',
        replace: true,
        template: '<div id="mattercontainer" style="margin: 0 auto;height:250px">not working</div>',
        scope: {
            data: '=',
            cat: '='
        },
        link: function (scope, element) {
           var chart = new Highcharts.chart({
                chart: {
                    type: 'bar',
                    renderTo: 'mattercontainer'
                },
                title: {
                  text: ''
                },
                legend: {
                    enabled: false
                },
                credits: {
                    enabled: false
                },
                xAxis: {
                    categories: scope.cat,
                    title: {
                        text: null
                    },
                    lineWidth: 0,
                    tickWidth: 0,
                    labels: {
                            x : 0,
                            y : -35,
                            align: 'left',
                    		    formatter: function () {
                    		    var text = this.value
                    		    return '<div class="js-ellipse" style="width:250px; overflow:hidden" title="' + text + '">' + text + '</div>';
                    },
                    style: {
                    	    width: '150px'
                    },
                    useHTML: true
                    }

                },
                yAxis: {
                    visible:false},
                plotOptions: {
                    bar: {
                        dataLabels: {
                            enabled: true,
                            x: -80,
                            shadow: false,
                            color: '#ffffff',
                            style: {
                              "fontWeight": "bold",
                              "font-family": "Roboto",
                              "font-size": '13px',
                              "font-weight": 'normal',
                              "font-style": 'normal',
                              "font-stretch": 'normal',
                              "letter-spacing": 'normal',
                              "color": '#ffffff',
                              "word-wrap": 'break-word'
                          },
                          formatter: function () {
                            return '$' + Highcharts.numberFormat(Math.round(this.y));
                        }
                        }
                    }
                },
                series: [{
                    data: scope.data,
                    color: '#c31820'
                }]
            });
            scope.$watch("data", function (newValue) {
                if(newValue != undefined) {
                  var json = eval("([" +newValue+ "])");
                  chart.series[0].setData(json, true);
              }
          }, true);
        }
    };
});

var DataService = angular.module('DataService', [])
    .service('billingService', function ($http,$q) {
    return({
          getServiceData: getServiceData,
          getAnomaliesData: getAnomaliesData
      });

    function  getServiceData(category,categoryvalue,filters,selectedkpi,subcategory,datefilter) {
    var request = $http({
            method: "post",
            url: "/AppBuilder/endpoint/dashboardendpoint",
            params: {
                    category: category,
                    categoryvalue: "'" + categoryvalue + "'",
                    filters: filters,
                    selectedkpi: selectedkpi,
                    subcategory: subcategory,
                    datefilter: datefilter
                  }
        });
    return(request.then( handleSuccess, handleError ) );
  }

  function  getAnomaliesData(stateS,datefilterS) {
  var request = $http({
            method: "post",
            url: "/AppBuilder/endpoint/getAnomaly",
            params: {
                    state: stateS,
                    datefilter: datefilterS
                }
        });
    return(request.then( handleSuccess, handleError ) );
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
