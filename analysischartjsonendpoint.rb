#Combined scripts for all charttypes
#Based on the charttype apply the logic

$charttype = params[:charttype]
category = params[:category]
subcategory = params[:subcategory]
selectedkpi = params[:selectedkpi]
excludeothers = params[:excludeothers]
$filters = params[:filters].split("&&")
$datefilter = params[:datefilter].split("-")
$categoryfilterstring = nil
filterstring =nil
datanew = {}
dataall = {}
datanewvalue = []
series = "["
seriesmap = {}

if $charttype == "timecomparison"
  categoryvalue = params[:categoryvalue]
  $datefilter = params[:datefilter].split("||")
else
  $datefilter = params[:datefilter].split("-")
  categoryvalue = params[:categoryvalue].split("||")
  #print "\n********** \n"
  #print categoryvalue
end

facet_by_subcategory = field(subcategory).with_facet_id('subcategory_id').with_maximum_facet_values_of(-1).without_pruning
facet_by_hours = sum(xpath('$'+selectedkpi)).with_facet_id('kpi_id')
facet_by_invdate = xpath("viv:format-date($item_date,'%m/%d/%Y')").with_facet_id('invdate_id').with_maximum_facet_values_of(-1).without_pruning

def getStartAndEndDateForTimeComparison(actualStartDate,actualEndDate,daterange)
  dates = daterange.split("-")
  dateStart = dates[0].split("/")
  actualStartDate = Date.new(dateStart[2].to_i,dateStart[0].to_i,dateStart[1].to_i)
  dateEnd = dates[1].split("/")
  actualEndDate = Date.new(dateEnd[2].to_i,dateEnd[0].to_i,dateEnd[1].to_i)
end

def getStartAndEndDate(datefilter)
  actualStartDate = ""
  actualEndDate = ""

  dateStart = datefilter[0].split("/")
  actualStartDate = Date.new(dateStart[2].to_i,dateStart[0].to_i,dateStart[1].to_i)
  dateEnd = datefilter[1].split("/")
  actualEndDate = Date.new(dateEnd[2].to_i,dateEnd[0].to_i,dateEnd[1].to_i)
end

def getFilterString(filterstring,filters,datefieldname,categoryfilterstring,datefilter,daterange)
  if filters.any?
    filters.each do |filterwhole|
    filtername = filterwhole.split(">>")[0]
    filtervalue = filterwhole.split(">>")[1].split("||")
    internalfilterstring = nil
    if filtervalue.any?
          filtervalue.each do |filtereach|
          		if internalfilterstring.nil?
          				internalfilterstring = field(filtername).contains(filtereach)
          		else
          				internalfilterstring = internalfilterstring.or(field(filtername).contains(filtereach))
          		end
	         end
    else
    		internalfilterstring = ""
    end
      if filterstring.nil?
          filterstring = $categoryfilterstring.and(internalfilterstring)
      else
          filterstring = filterstring.and(internalfilterstring)
      end
    end
    else
      filterstring = $categoryfilterstring
    end
    # for invoicelevel anomaly
    #searchstringwithoutdate = filterstring
    if !daterange.nil?

       dates = daterange.split("-")
  dateStart = dates[0].split("/")
  actualStartDate = Date.new(dateStart[2].to_i,dateStart[0].to_i,dateStart[1].to_i)
  dateEnd = dates[1].split("/")
  actualEndDate = Date.new(dateEnd[2].to_i,dateEnd[0].to_i,dateEnd[1].to_i)

      # print "\n**start date***\n"
      #print actualStartDate
      #print "\n**end date***\n"
      #print actualEndDate
      # datefieldname  can be item_date or invoice date in case of anomalies
      filterstring = filterstring.and(field(datefieldname).isLessThanOrEqual(actualEndDate.to_time.to_i.to_java)).and(field(datefieldname).isGreaterThanOrEqual(actualStartDate.to_time.to_i.to_java))
    else
      if datefilter.any?
          dateStart = datefilter[0].split("/")
          actualStartDate = Date.new(dateStart[2].to_i,dateStart[0].to_i,dateStart[1].to_i)
          dateEnd = datefilter[1].split("/")
          actualEndDate = Date.new(dateEnd[2].to_i,dateEnd[0].to_i,dateEnd[1].to_i)
          if filterstring.nil?
          filterstring =(field(datefieldname).isLessThanOrEqual(actualEndDate.to_time.to_i.to_java)).and(field(datefieldname).isGreaterThanOrEqual(actualStartDate.to_time.to_i.to_java))
      else
          filterstring =  filterstring.and(field(datefieldname).isLessThanOrEqual(actualEndDate.to_time.to_i.to_java)).and(field(datefieldname).isGreaterThanOrEqual(actualStartDate.to_time.to_i.to_java))
      end
      end
    end
  #print "\n**********\n"
  #print filterstring
  return filterstring
end

# For pie and bar. If the category is phase, task and fullname, then apply select only line item anomalies, else do both invoice as well as line item. Need to change the filter string also
def getDataFromFacetsPBC(data,entitytype,filterstring,facet_by_subcategory,facet_by_hours)
    cattmp = params[:category]
    subcattmp = params[:subcategory]

	if (params[:selectedkpi] == "anomaly_description")
		facets = entity_type("AnalysisAnomaly_Matrix").where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_hours)).faceting

		arr = []
		facets.get_facet('subcategory_id').facet_values.each do |firm|
      data[firm.value] = firm.ndocs
		end

		if (cattmp != "phase") && (cattmp != "task_code") && (cattmp != "full_name") && (cattmp != "rate") && (cattmp != "expense") && (subcattmp != "phase") && (subcattmp != "task_code") && (subcattmp != "full_name") && (subcattmp != "rate") && (subcattmp != "expense")

      filterstring = getFilterString(nil,$filters,"invoice_date",$categoryfilterstring,$datefilter,nil)
			facets = entity_type("AnalysisInvoiceAnomalies").where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_hours)).faceting

			facets.get_facet('subcategory_id').facet_values.each do |firm|

			  if data.key?(firm.value)
				data[firm.value] = data[firm.value]+firm.ndocs
			   # print "\n if data.key loop \n"
			  else
				#print "\n else loop \n"
				data[firm.value] = firm.ndocs
			  end
			end
		end
	else
		facets = entity_type(entitytype).where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_hours)).faceting

		arr = []
		facets.get_facet('subcategory_id').facet_values.each do |firm|
		  data[firm.value] = firm.getChildren.first.value
		end
	end

  return data
end

# For timeline
def getDataFromFacetsTC(data,entitytype,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate)


  print "\n getDataFromFacetsTC printing values"
  print filterstring
  print facet_by_subcategory.to_s
  print facet_by_hours.to_s
  print facet_by_invdate.to_s
    facets = entity_type(entitytype).where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_invdate.then(facet_by_hours))).faceting
    facets.get_facet('subcategory_id').facet_values.each do |firm|
      arr = []
      firm.get_facet('invdate_id').facet_values.each_with_index do |invdate,index|
        invdate.getChildren.each do |total|
          arr << {invdate.value => total.value}
        end
        data = arr
      end
    end
  return data
end

def getDataStore(datanew,data)
 data = data.sort_by {|k,v| v}.reverse
 datanew = {}
 i = 1
 totalrest = 0
 total = 0;
 noofresults = 10;
 if params[:noofresults] != nil && params[:noofresults] != ''
   noofresults = params[:noofresults].to_i
 end
 data.each do |key,value|
   if(i <= noofresults)
     datanew.store(key,value)
   else
     totalrest = totalrest + value
   end
   i = i + 1
   total = total + value;
 end
 
  dataWithPercent = {}
 datanew.each_with_index do |(key,value), index|
   percent = (value.to_f*100/total).round(2);   
   dataWithPercent.store(key,(value.to_s+"#"+percent.to_s))
 end
  datanew = dataWithPercent;
  excludeothers = params[:excludeothers] != nil ? params[:excludeothers] : 'N';
  if(excludeothers != 'Y' && totalrest > 0)
   datanew.store("others",totalrest)
  end
  return datanew
end


# return the json formated data to return
def getJsonFormat(series,datavalue)
datavalue.each_with_index do |(key, val), i|
  series << "\{\"name\":'#{key}',\"data\": #{val}\}"
  unless i == datavalue.size - 1
    series << ","
  end
end
  return series
end

# return the json formated data for pie. Need to make it more generic.
def getJsonPieFormat(series,datavalue)
  if $charttype == "pie"
datavalue.each_with_index do |(key, val), i|
    value = val.to_s.split("#");
    if(value.length > 1)
      series << "\{\"name\":\"#{key}\",\"y\": #{value[0]},\"percent\": #{value[1]}\}"
    else
      series << "\{\"name\":\"#{key}\",\"y\": #{val}\}"
    end
  unless i == datavalue.size - 1
    series << ","
  end
end
  return series
else
  datavalue.each_with_index do |(key, val), i|
  series << "\{\"name\":'#{key}',\"y\": #{val}\}"
  unless i == datavalue.size - 1
    series << ","
  end
end
  return series
end
end


def executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,charttype)
  #datanew = {}

  #anomaly_description was anomalycount before
  if selectedkpi == "anomaly_description"
    if charttype == "timeline"
#      data  = getDataFromFacetsTC(data,'AnalysisAnomaly_Matrix',filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate)
    else
      data  = getDataFromFacetsPBC(data,'AnalysisAnomaly_Matrix',filterstring,facet_by_subcategory,facet_by_hours)
    #print "\n data in executeQuery \n"
    #print data
    end
  else
   if charttype == "timeline"
      data  = getDataFromFacetsTC(data,'Analysis_Matrix',filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate)
    else
      data  = getDataFromFacetsPBC(data,'Analysis_Matrix',filterstring,facet_by_subcategory,facet_by_hours)
    end
  end
  if charttype == "timeline"
    datanew = data
    else
     datanew = getDataStore(datanew,data)
  end
  return datanew
end


#main code to execute all functions

if $charttype == "timecomparison"
  if $datefilter.any?
    $datefilter.each do |daterange|
    data = {}
    datanew = {}
    $categoryfilterstring = field(category).contains(categoryvalue)
      filterstring = getFilterString(filterstring,$filters,"item_date",$categoryfilterstring,$datefilter,daterange)
    dataall[daterange] = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,$charttype)
    filterstring = nil

     # print "\n**********\n"
     # print daterange
     # print "\n data returned \n"
     # print dataall[daterange]
     # print "\n==========\n"

  end
 end
else
    #print "\n-----in else loop ---\n"
    if(categoryvalue.any?)
      datanewvalue ={}
      categoryvalue.each do |catval|
      data = {}
      datanew = {}
      $categoryfilterstring = field(category).contains(catval)
      filterstring =nil
      daterange = nil
        filterstring = getFilterString(filterstring,$filters,"item_date",$categoryfilterstring,$datefilter,daterange)
      #print filterstring
      if $charttype=="timeline"
        datanewvalue[catval] = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,$charttype)
      else
        if $charttype == "pie"
        datanew = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,$charttype)
        else
        dataall[catval] = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,$charttype)
        end
      end
      end
    end
end

def makeproperarray(arraytofix,dataall)
  if arraytofix.length < dataall.length
    arraytofix.push(0)
    makeproperarray(arraytofix,dataall)
  end
else
  return arraytofix
end

def getJsonFormattedPieData(datavalue)
  series = "["
  series = getJsonPieFormat(series,datavalue)
  return series
end

def getJsonFormattedBarData(dataall)
series = "["
seriesmap = {}
names = Array.new
dataall.each_with_index do |(key,val),i|
  val.each_with_index do |(key1,val1),j|
    if names.include?(key1)
    else
      names.push(key1)
    end
  end
end
dataall.each_with_index do |(key,val),i|
  names.each do |name|
    if seriesmap.key?(name)
    else
       seriesmap[name] = Array.new
    end
    if val.key?(name)
      seriesmap[name] = seriesmap[name].push(val[name])
    else
      seriesmap[name] = seriesmap[name].push(0)
    end

    end
  end
  seriesmap.each_with_index do |(key,val),i|
    seriesmap[key] = makeproperarray(val,dataall)
    series << "\{\"name\":\"#{key}\",\"data\": #{val}\}"
    unless i == seriesmap.size - 1
        series << ","
        end
    end
    return series
end

def getJsonFormattedTimeComparisonData(dataall)
series = "["
seriesmap = {}
dataall.each_with_index do |(key,val),i|
  val.each_with_index do |(key1,val1),j|
    if seriesmap.key?(key1)
      seriesmap[key1] = seriesmap[key1].push(val1)
    else
      seriesmap[key1] = Array.new(i,0)
      seriesmap[key1] = seriesmap[key1].push(val1)
    end
  end
end
seriesmap.each_with_index do |(key,val),i|
  seriesmap[key] = makeproperarray(val,dataall)
  series << "\{\"name\":'#{key}',\"data\": #{val}\}"
  unless i == seriesmap.size - 1
      series << ","
    end
end
return series
end

resultsize  = 0;
if $charttype.eql?"bar"
  series = getJsonFormattedBarData(dataall)
  resultsize = dataall.size;
end
if $charttype.eql?"pie"
  #print datanew
  series = getJsonFormattedPieData(datanew)
  resultsize = datanew.size;
end
if $charttype.eql?"timeline"
  month_values = datanewvalue.values.collect { |month_array| month_array.collect { |month_hash| month_hash.keys }}.flatten.uniq
  new_normalized_data = {}

  datanewvalue.each do |firm, month_array|
    this_firm = []
    month_values.each do |month|
      x = month_array.select{ |month_hash|month_hash. include? month}
      if x.empty?
        this_firm << nil
      else
        this_firm << x.first.values.first
      end
    end
    new_normalized_data[firm] = this_firm
  end

  series = "["
  series << "\{\"name\":'category',\"data\": #{month_values.to_json.html_safe }\},"
  getJsonFormat(series,new_normalized_data)
  resultsize = new_normalized_data.size;
end

if $charttype.eql?"timecomparison"
  series = getJsonFormattedTimeComparisonData(dataall)
  resultsize = dataall.size;
end
if(resultsize > 0)
  series << ","
end
series << "\{\"total\": #{resultsize }\}"
series.gsub!('nil','null')
series = series + "]"
series.html_safe
