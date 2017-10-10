var app = angular.module('wexdashboard', ['DataService','ui.router','ui.bootstrap','ui.tree','wexdashboard.directives','wexdashboard.services','angularjs-dropdown-multiselect']);
  app.config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('all');
  $stateProvider
  .state('allstate', {
    url: '/all',
    templateUrl:'/AppBuilder/dashapp/src/views/dashboard/dashboardviewvp.html',
    controller: 'MainController'
  })
});

app.filter('filterHtmlChars', function(){
     return function(string) {
         return string.replace(/&amp;/g, '&');
     }
  });

app.controller('MainController', ['$scope','$state','billingService',function($scope,$state,billingService){

$scope.mapDataList = [];
$scope.showCountyView = false;
$scope.resettoallstates  = true;
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
$scope.countyfieldname = "county";
$scope.selectedfilterS = [];
$scope.searchSelectAllSettings = { enableSearch: true, showCheckAll: false, showUncheckAll:false,keyboardControls: true, styleActive: true,scrollable: true,scrollableHeight: '300px'};
$scope.searchSelectCountyModel = [];
$scope.countyChangeEventListeners = {
    onSelectionChanged: onCountySelectionChanged
};



$scope.setPeriod = function(selectedDate)
{
    if(selectedDate != "") {
      $scope.filterDefaultDate = selectedDate;
      console.log("$scope.filterDefaultDate = " + $scope.filterDefaultDate);
      $scope.sortDateKey = "";
      $scope.selectValueDisplay = "";
      $scope.billingHoursDefaultDate = getSelectedFilterDate(selectedDate,$scope.sortDateKey);
      loadSpendingBudgetData($scope.selectedstateCode,$scope.filterDefaultDate);
      loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
      loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
      loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
      loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
      loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
      $scope.show_DropDown = false;
      $scope.selectValueDisplay= getDisplayValueViewByDate($scope.filterDefaultDate);
      }
}


function getDisplayValueViewByDate(sortDate) {
  vData = "";
  dVSorter = getSelectedFilterDate(sortDate,"true");
  var condA = dVSorter[0];
  var condB = dVSorter[1];
  var condC = dVSorter[2];
  var condD = dVSorter[3];
  var labelC = [];
  var labelD = [];

  labelC = getDateLabels(condA,condB);
  labelD = getDateLabels(condC,condD);
  vData = labelD[0];
  return vData;
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
    labelChart.push(moment(toDate).format("YYYY"));
  }
  if(diff <=31) {
    labelChart.push(moment(toDate).format("MMM YYYY"));
  }
  else if(diff > 31) {
  labelChart.push(moment(toDate).format("[Q]Q YYYY"));
  }
  return labelChart;
}

function getDateList()
{
var dList = [];
currentYear = moment().format("YYYY");
for( i = 0 ; i <6; i++)
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
  $scope.selectedstateCode = "";
  $scope.showCountyView = "";
  $scope.sortDateKey = "";
  $scope.selectedfilterS = [];
  $scope.countyList = [];
  $scope.mapDataList = [];
  $scope.displayCounties = "";
  fillStateList();
  loadSpendingBudgetData($scope.selectedstateCode,$scope.filterDefaultDate);
  loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
  loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
  loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
  loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
  loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
  $scope.updateMapView($scope.selectedstateCode);
}

function init() {
     $scope.sortDateKey = "";
     $scope.showCountyView = "";
     $scope.displayCounties = "";
     $scope.countyList = [];
     $scope.billingHoursDefaultDate = getSelectedFilterDate($scope.billingHoursDefaultDate,$scope.sortDateKey);
     loadSpendingBudgetData($scope.selectedstateCode,$scope.filterDefaultDate);
     loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
     loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
     loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
     loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
     loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
     $scope.selectValueDisplay= getDisplayValueViewByDate($scope.filterDefaultDate);
  };

  function fillStateList() {
  $scope.selectedState = [];
  billingService.getDataForMapSelection("","state",$scope.filterDefaultDate)
        .then(
              function( mydata ) {
                  $scope.mapDataList = mydata;
                  $scope.stateDataList = mydata;
            });
    };

   function fillCountyList(stateSelected) {
       $scope.countyList = [];
       var stateS = "";
       if(stateSelected != "")
       {
         stateS = "state>>" + stateSelected;
       }else {
         stateS = "";
       }
       billingService.getDataForMapSelection(stateS,"county",$scope.filterDefaultDate)
            .then(
                  function( mydata ) {
                    console.log(mydata);
                  for(var i in mydata) {
                    $scope.countyList.push(
                      {
                        id:mydata[i].key,
                        label:mydata[i].key
                      });

                  };
            });
        };

    function onCountySelectionChanged() {
          var selectedCounty = getSelectedParams($scope.searchSelectCountyModel);
          if($scope.searchSelectCountyModel.length >= 0) {
              $scope.displayCounties = $scope.searchSelectCountyModel.map(function(el){return el.label}).join(",");
            }
          else {
            $scope.displayCounties = "";
          }
          $scope.selectedfilterS = selectedCounty;
          loadSpendingBudgetData($scope.selectedstateCode,$scope.filterDefaultDate);
          loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
          loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
          loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
          loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
          loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
          //}
        };


function loadSpendingBudgetData(selectedStateS,filterdate){
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = $scope.selectedfilterS;
    var selectedkpiS = "net_amt";
    var subcategoryS = "firm_name";
    var datefilterS = filterdate;
    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
                   var spendingByBudget = d3.nest()
                  .rollup(function(v) { return d3.sum(v, function(d) { return d.value; }); })
                  .entries(mydata);
                   $scope.spendingHours = spendingHoursCurrencyFormat(spendingByBudget);
                   $scope.dataSpendingByBudgetLoaded = true;
             });
      };


  function loadBillingHoursData(selectedStateS,filterdate){
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = $scope.selectedfilterS;
    var selectedkpiS = "hours";
    var subcategoryS = "item_date";
    var datefilterS = filterdate;

    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
                $scope.billedHours =  getFormattedJson(mydata,$scope.filterDefaultDate);
                $scope.billcategories = setCategoriesLabel($scope.billedHours);
                $scope.billedHours.reverse();
            //    console.log("console.log billedhours reverse "+JSON.stringify($scope.billedHours));
                $scope.billcategories.reverse();
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
    // Get the date and sort the correct json array.moment('2016-10-30').isBetween('2016-10-30', '2016-10-30', null, '[]'); //true
    for (var key in myServerData) {
           if (myServerData.hasOwnProperty(key)) {
              if(moment(myServerData[key].name).isBetween(condC,condD,null,'[]')) {
              totalA = totalA + parseFloat(myServerData[key].value);
          }else if(moment(myServerData[key].name).isBetween(condA,condB,null,'[]')) {
              totalB = totalB + parseFloat(myServerData[key].value);
           }
          }
      }

        labelC = getDateLabels(condA,condB);
        labelD = getDateLabels(condC,condD);
        fData.push({key:labelC[0],y: totalB, color:"#cbcbcb"},
                 {key:labelD[0],y: totalA, color:"#c31820"});
    //    console.log("dSorter array = " + JSON.stringify(fData));
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
    var filtersS = $scope.selectedfilterS;
    var selectedkpiS = "anomaly_description";
    var subcategoryS = "item_date";
    var datefilterS = filterdate;

    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
                $scope.violationHours =  getFormattedJson(mydata,$scope.filterDefaultDate);
                $scope.violationcategories = setCategoriesLabel($scope.violationHours);
                $scope.violationHours.reverse();
                $scope.violationcategories.reverse();
                $scope.dataViolationsLoaded = true;
            }
          );
      };

 function formatDataForMatterChart(trackedMattersData) {
   $scope.categories = [];
   for (var key in trackedMattersData) {
          if (trackedMattersData.hasOwnProperty(key)) {
             var tmpStrCatValue = trackedMattersData[key].name;
             $scope.categories.push(tmpStrCatValue);
          }
       }
   return $scope.categories;
 }
  function loadTrackedMattersData(selectedStateS,filterdate){
    $scope.dataTrackedMattersLoaded = false;
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = $scope.selectedfilterS;
    var selectedkpiS = "net_amt";
    var subcategoryS = "matter_name";
    var datefilterS =  filterdate;
    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {   
              $scope.topTrackedMatters = mydata.slice(0,3);
              formatDataForMatterChart($scope.topTrackedMatters);
              $scope.dataTrackedMattersLoaded = true;
            });
      };

  function loadTopFirmExpenditureData(selectedStateS,filterdate){
    $scope.dataTopExpendituresLoaded = false;
    var categoryS = "state";
    var categorySvalue = selectedStateS;
    var filtersS = $scope.selectedfilterS;
    var selectedkpiS = "net_amt";
    var subcategoryS = "firm_name";
    var datefilterS = filterdate;
    var dataList = [];
    billingService.getServiceData(categoryS,categorySvalue,filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
              for(var i in mydata) {
                  dataList.push(
                    { "name":mydata[i].name,
                      "value": mydata[i].value
                    });
                }
              var topFirmByExpenditures = d3.nest()
              .key(function(d) { return d.name})
              .rollup(function(v) { return d3.sum(v, function(d) { return d.value; }); })
              .entries(dataList);

              var top5Firms = topFirmByExpenditures.slice(0,5);
              $scope.topStateExpenditureData = top5Firms;
              $scope.dataTopExpendituresLoaded = true;
            }
          );
      };

  function loadTopFirmAnamoliesData(selectedStateS,filterdate){
    $scope.dataTopAnamoliesLoaded = false;
    var datefilterS = filterdate;
    var dataList = [];
    var selectedStatevalue = "";
    var selectedCountyvalue = "";
    if(selectedStateS != "") {
      selectedStatevalue = "state>>"+ selectedStateS + "&&";
    }
    selectedCountyvalue = $scope.selectedfilterS;
    filtersS = selectedStatevalue + selectedCountyvalue;
    var selectedkpiS = "anomaly_description";
    var subcategoryS = "firm_name";
    billingService.getAnomaliesData(filtersS,selectedkpiS,subcategoryS,datefilterS)
          .then(
            function( mydata ) {
              for(var i in mydata) {
                  dataList.push(
                    { "name":mydata[i].name,
                      "value": mydata[i].value,
                      "percentage":mydata[i].percentage
                    });
                }
               var top5Anomalies = dataList.slice(0,5);
               for (var i = 0; i < top5Anomalies.length; i++) {
                    if (top5Anomalies[i].name === undefined) {
                        top5Anomalies.splice(i, 1);
                    }
                }
                $scope.topFirmAnomaliesData = top5Anomalies;
                $scope.dataTopAnamoliesLoaded = true;
            }
          );
      };

        // This method will returns the formatted filtervalue required for the endpoints.
        function getSelectedParams(sourceParams){
          var selectedValue = "";
          if(sourceParams.length > 0) {
            selectedValue = $scope.countyfieldname + ">>" + getSelectedValues(sourceParams);
          } else {
            selectedValue = "";
          }
          return selectedValue
        }

        // Method to return selectd values from dropdown and concate different values using pipe. Use Id of the dropdown when it is available
        function getSelectedValues(sourceParams){
          var sourceValue = "";
          for (i = 0; i < sourceParams.length; i++) {
            sourceValue = sourceValue + sourceParams[i] + "||"; //need to add this after we update endpoint to handle multiple values separated by ||
          }
          return sourceValue;
        }

        function _isContains(json, value) {
          var contains = json.some(function (el) {
            return el.key === value;
          });
          if (contains) {
              return true;
          }
          return false;
        }

            $scope.updateStateData = function (selectedItem) {
                 $scope.selectedfilterS = [];
                 $scope.displayCounties = "";
                 $scope.selectedstateCode = selectedItem;
                 $scope.showCountyView = true;
                 if(selectedItem == ""){
                   init();
                  } else {
                     fillCountyList($scope.selectedstateCode);
                     loadSpendingBudgetData($scope.selectedstateCode,$scope.filterDefaultDate);
                     loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
                     loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
                     loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
                     loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
                     loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
                   }
          };

          $scope.updateMapView = function (itemvalue) {
            if((itemvalue != "") && ($scope.resettoallstates)) {
              $scope.resettoallstates = true;
            } else if((itemvalue == "") && ($scope.resettoallstates)) {
              $scope.resettoallstates = false;
            } else if((itemvalue == "") && (!$scope.resettoallstates)) {
                $scope.resettoallstates = true;
            } else {
                $scope.resettoallstates = false;
            }
          }

          $scope.updateCountyData = function (selectedItem) {
               $scope.displayCounties = selectedItem.join();
               $scope.selectedfilterS = [];
               var selectedCounty = getSelectedParams(selectedItem);
               $scope.selectedfilterS = selectedCounty;
               loadSpendingBudgetData($scope.selectedstateCode,$scope.filterDefaultDate);
               loadBillingHoursData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
               loadVoilationData($scope.selectedstateCode,$scope.billingHoursDefaultDate);
               loadTrackedMattersData($scope.selectedstateCode,$scope.filterDefaultDate);
               loadTopFirmExpenditureData($scope.selectedstateCode,$scope.filterDefaultDate);
               loadTopFirmAnamoliesData($scope.selectedstateCode,$scope.filterDefaultDate);
        };
    init();
}]);

app.directive('hcBarChart', function($window){
    return {
        restrict: 'EAC',
        replace: true,
        template: '<div id="barcontainer" style="margin: 0 auto;height:250px">Loading Chart...</div>',
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
                tooltip:{
                formatter:function(){
                  var currencyFormat = d3.format(".3s");
                  return this.key + ':' + currencyFormat(this.y);
                }
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
                       series: {
                           dataLabels: {
                               enabled: true,
                               align: 'center',
                               color: '#FFFFFF',
                               x: 0,
                               y:30,
                               formatter: function () {
                                 var currencyFormat = d3.format(".3s");
                                 return currencyFormat(this.y);
                              //return this.y;
                               },
                               style: {
                                 "fontWeight": "normal",
                                 "font-family": "Roboto",
                                 "font-size": "16px"
                             }
                           },
                           pointPadding: 0,
                           groupPadding: 0
                       }
                   },
                series: [{
                    maxPointWidth: 100,
                    pointPadding: 0,
                    groupPadding: 0,
                    data: scope.data
                }]
            });
            scope.$watch("data", function (newValue) {
              //console.log("date for chart = " + JSON.stringify(newValue));
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
        template: '<div id="mattercontainer" style="margin: 0 auto;height:250px"><div class="loader center-block"></div></div>',
        scope: {
            data: '=',
            cat: '=',
            labelLink: '@?'
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
                tooltip: {
                   formatter: function () {
                       var s = this.x + ':' + '<b>$' + Highcharts.numberFormat(Math.round(this.y)) + '</b>';
                       return s;
                   }
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
                    		    var text = this.value;
  				  //  console.log("Label Link:"+scope.labelLink);
  				    retStr = '';
  				    if(scope.labelLink)
              {
                  retStr = '<a href="'+scope.labelLink+text+'">'
              }
				      retStr = retStr + '<div class="js-ellipse" width="400px;margin: 0 auto;" title="' + text + '">' ;
				      retStr = retStr + text;
              retStr = retStr + '</div>'
              if(scope.labelLink)
              {
                retStr = retStr + '</a>'
              }
              return retStr;
				      },
              useHTML: true,
                style: {
              	    width: '400px'
                }
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
                            crop: false,
                            overflow: 'none',
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
              console.log("date for chart = " + JSON.stringify(newValue));
                if(newValue != undefined) {
                  chart.series[0].setData(newValue, true);
                  chart.xAxis[0].setCategories(scope.cat, true, true);
                  $(".js-ellipse").each(function(){this.parentElement.style.width = '600px'})
              }
          }, true);
        }
    };
});

app.directive('hcMap', ['billingService',function(billingService) {
return {
    restrict: 'EAC',
    replace: true,
    scope: {
        dataselect: '=',
        itemchanged: '@',
        datefilter: '@',
        countystate: '@',
        selectedstate:'@'
    },
    template: '<div id="container" style="margin: 0 auto"><div class="loader center-block"></div></div>',
    link: function(scope, element, attrs) {
        var data = "";
        var datefilterparam = "";
        scope.$watch("itemchanged", function (oldValue, newValue) {
        if(oldValue != newValue) {
          data  = Highcharts.geojson(Highcharts.maps['countries/us/us-all']);
          render_map();
          }
        }, true);

        data = Highcharts.geojson(Highcharts.maps['countries/us/us-all']),
            // Some responsiveness
          small = $('#container').width() < 400;
        // Set drilldown pointers
        var dataselect1 = [];
        scope.$watch("datefilter", function (oldValue, newValue,scope) {
        console.log(scope);
        if(scope.countystate == ""){
        billingService.getDataForMapSelection("","state",scope.datefilter)
              .then(
                    function( mydata ) {
                      dataselect1 = mydata;
                      render_map();
            });
          } else {
            var statetmp = "state>>" + extracted;
             console.log("selectedState****" + scope.selectedstate);
              billingService.getDataForMapSelection(statetmp,"county",scope.datefilter)
               .then(
                     function( mydata ) {
                       dataselect1 = mydata;
                       render_countymap();
             });
          }
        }, true);
        
        function render_map() {
        $.each(data, function(i) {
            // retrieve the state data from wex and color the states.
            this.drilldown = this.properties['hc-key'];
            postalcode = this.properties['postal-code'];
            mycolor = "#cbcbcb";
            myvalue = "#cbcbcb";
            $.each(dataselect1, function(i) {
                if (postalcode == dataselect1[i].key) {
                    myvalue = dataselect1[i].value;
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
                          console.log("scope in county");
                          console.log(scope);
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

                            //chart.showLoading('<i class="icon-spinner icon-spin icon-5x"></i>');
                            chart.showLoading('<div class="loader center-block"></div>');
                            $.getScript('https://code.highcharts.com/mapdata/' + mapKey + '.js', function() {
                                data = Highcharts.geojson(Highcharts.maps[mapKey]);
                                console.log("selectedState = " + selectedState);
                                var selectedPoints = [];
                                var split = selectedState.split("-");
                                     if (split.length === 2) {
                                         extracted = split[1];
                                     }
                                var stateselected = "state>>" + extracted;
                                console.log("datefilter = " + scope);
                                billingService.getDataForMapSelection(stateselected,"county",scope.datefilter)
                                        .then(
                                              function( mydata ) {
                                                countydata = mydata;
                                                render_countymap();
                                                scope.$parent.updateStateData(extracted);
                                                scope.$parent.updateMapView(extracted);
                                  });
                                  $('#countyreset').click(function() {
                                      var chart = $('#container').highcharts();
                                      var point = chart.series[0].data[0];
                                      point.select(false);
                                  });
                                function render_countymap() {
                                $.each(data, function(i) {
                                    countyname = this.name;
//console.log("countyname" + countyname);
                                    mycolor = "#cbcbcb";
                                    myvalue = "#cbcbcb";
                                    $.each(countydata, function(i) {
                                        var tmpCounty = countydata[i].key
                                        var cTmp = tmpCounty.replace(' County','');
                                        if (countyname == cTmp) {
                                            myvalue = countydata[i].value;
                                            mycolor = "#c31820";
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
                                    states: {
                                          hover: {
                                              color: '#029fdb'
                                          },
                                          select: {
                                              color: '#029fdb'
                                          }
                                      },
                                    point: {
                                        events: {
                                            select: function() {
                                                var chart = this.series.chart;
                                                var selectedPoints = chart.getSelectedPoints();
                                                selectedPoints.push(this);
                                                var selectedPointsStr = [];
                                                  scope.$apply(function() {
                                                    $.each(selectedPoints, function(i, value) {
                                                        selectedPointsStr.push(value.name);
                                                    });
                                                  scope.$parent.updateCountyData(selectedPointsStr);
                                                })
                                            },
                                            unselect: function() {
                                                var chart = this.series.chart;
                                                var selectedPoints = chart.getSelectedPoints();
                                                var selectedPointsStr = [];
                                                scope.$apply(function() {
                                                    $.each(selectedPoints, function(i, value) {
                                                        selectedPointsStr.push(value.name);
                                                    });
                                                    scope.$parent.updateCountyData(selectedPointsStr);
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
                              }
                            });
                        }
                    },
                    drillup: function() {
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
                name: 'All States',
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
    }
  }
  }
}]);

var DataService = angular.module('DataService', [])
    .service('billingService', function ($http,$q) {
    return({
          getServiceData: getServiceData,
          getAnomaliesData: getAnomaliesData,
          getDataForMapSelection:getDataForMapSelection
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

  function getDataForMapSelection(filtervalue,findfieldname,dateFilterS) {
    var request = $http({
              method: "post",
              url: "/AppBuilder/endpoint/DashboardStateListEndpoint",
              params: {
                        FilterValue: filtervalue,
                        FindFieldName: findfieldname,
                        datefilter:dateFilterS
                    }
            });
          return(request.then( handleSuccess, handleError ) );
      }

  function  getAnomaliesData(filters,selectedkpi,subcategory,datefilter) {
  var request = $http({
            method: "post",
            url: "/AppBuilder/endpoint/getAnomaly",
            data : {
                    filters: filters,
                    selectedkpi: selectedkpi,
                    subcategory: subcategory,
                    datefilter: datefilter
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
