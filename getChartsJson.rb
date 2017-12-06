#Combined scripts for all charttypes
#Based on the charttype apply the logic

$charttype = params[:charttype]
category = params[:category]
subcategory = params[:subcategory]
selectedkpi = params[:selectedkpi]
$filters = params[:filters].split("&&")
$datefilter = params[:datefilter].split("-")
#$categoryfilterstring = nil
categoryfilterstring = nil
$etc = nil
filterstring =nil
datanew = {}
dataall = {}
datanewvalue = []
series = ""
seriesmap = {}

if params[:charttype] == "timecomparison"
  categoryvalue = params[:categoryvalue].split("||")
  $datefilter = params[:datefilter].split("||")
else
  $datefilter = params[:datefilter].split("-")
  categoryvalue = params[:categoryvalue].split("||")
  #print "\n********** \n"
  #print categoryvalue
end



if subcategory.eql?("full_name")
  facet_by_subcategory = field(subcategory).with_facet_id('subcategory_id').with_maximum_facet_values_of(-1).without_pruning.then(field('firm_name').with_facet_id('firm_name').with_maximum_facet_values_of(-1).without_pruning.then(field('staff_level').with_facet_id('staff_level')))
elsif subcategory.eql?("matter_number") && !params[:charttype].include?("timeline")
  facet_by_subcategory = field(subcategory).with_facet_id('subcategory_id').with_maximum_facet_values_of(-1).without_pruning.then(field('matter_name').with_facet_id('matter_name').with_maximum_facet_values_of(-1).without_pruning)
else
  facet_by_subcategory = field(subcategory).with_facet_id('subcategory_id').with_maximum_facet_values_of(-1).without_pruning
end
if selectedkpi.include?("rate")
  #facet_by_hours = sum(xpath('$net_amt')).with_facet_id('net_amt')(sum(xpath('$hours')).with_facet_id('hours'))
  facet_by_hours = sum(xpath('$net_amt')).with_facet_id('kpi_id')

else
facet_by_hours = sum(xpath('$'+selectedkpi)).with_facet_id('kpi_id')
end
facet_by_invdate = nil

if params[:charttype].include?("matteropen")
    facet_by_invdate = field("numberofdayssincematteropen").with_facet_id('invdate_id').with_maximum_facet_values_of(-1).without_pruning

else
   facet_by_invdate=  xpath("viv:format-date($item_date,'%m/%d/%Y')").with_facet_id('invdate_id').with_maximum_facet_values_of(-1).without_pruning

end


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
		tmpFilterDateString = nil
		if filtervalue.any?
			  filtervalue.each do |filtereach|
				if(filtername.include?("_date"))
				  tmpDate = filtereach.split("-")
				  tmpdateStart = tmpDate[0].split("/")
				  tmpactualStartDate = Date.new(tmpdateStart[2].to_i,tmpdateStart[0].to_i,tmpdateStart[1].to_i)
				  tmpdateEnd = tmpDate[1].split("/")
				  tmpactualEndDate = Date.new(tmpdateEnd[2].to_i,tmpdateEnd[0].to_i,tmpdateEnd[1].to_i)
				  tmpFilterDateString = "true"
				end

          if(filtername.include?("opposing_firm_id"))
            # find all matter numbers

            entity_type("matter_firms").where(field("firm_id").is(filtereach).and(field('firm_type').contains("Opposing"))).faceted_by(field("matter_number").with_facet_id("matter_number").with_maximum_facet_values_of(-1).without_pruning).faceting.get_facet('matter_number').facet_values.each do |matter_number|

             #print matter_number.value.to_s
             if internalfilterstring.nil?
               internalfilterstring = field("matter_number").contains(matter_number.value)
              else
                internalfilterstring = internalfilterstring.or(field("matter_number").contains(matter_number.value))
              end
            #internalfilterstring = field("firm_id").contains(filtereach)

end
          else

				if internalfilterstring.nil?
					if tmpFilterDateString.nil?
							internalfilterstring = field(filtername).is(filtereach)
					else
							  internalfilterstring = field(filtername).isLessThanOrEqual(tmpactualEndDate.to_time.to_i.to_java).and(field(filtername).isGreaterThanOrEqual(tmpactualStartDate.to_time.to_i.to_java))
					end
				else
					if tmpFilterDateString.nil?
					  internalfilterstring = internalfilterstring.or(field(filtername).is(filtereach))
					else
					  internalfilterstring = internalfilterstring.and(field(filtername).isLessThanOrEqual(tmpactualEndDate.to_time.to_i.to_java)).and(field(filtername).isGreaterThanOrEqual(tmpactualStartDate.to_time.to_i.to_java))
					end
				end
          end
			  end
		else
			internalfilterstring = ""
		end
		if filterstring.nil?
			  #filterstring = $categoryfilterstring.and(internalfilterstring)
      filterstring = categoryfilterstring.and(internalfilterstring)
		else
			  filterstring = filterstring.and(internalfilterstring)
		end
	end
  else
    # for loop ends here
    #filterstring = $categoryfilterstring
    filterstring = categoryfilterstring
  end
    # for invoicelevel anomaly
    #searchstringwithoutdate = filterstring
  if !daterange.nil?
	dates = daterange.split("-")
	dateStart = dates[0].split("/")
	actualStartDate = Date.new(dateStart[2].to_i,dateStart[0].to_i,dateStart[1].to_i)
	dateEnd = dates[1].split("/")
	actualEndDate = Date.new(dateEnd[2].to_i,dateEnd[0].to_i,dateEnd[1].to_i)

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
  print filterstring
  return filterstring
end

# For pie and bar. If the category is phase, task and fullname, then apply select only line item anomalies, else do both invoice as well as line item. Need to change the filter string also
def getDataFromFacetsPBC(data,entitytype,filterstring,facet_by_subcategory,facet_by_hours)
    cattmp = params[:category]
    subcattmp = params[:subcategory]
  uniqueanomalycount = 0
	if (params[:selectedkpi] == "anomaly_description")
uniqueanomalycount = uniqueanomalycount + entity_type("AnalysisAnomaly_Matrix").where(filterstring).faceted_by(field('anomaly_group_id').with_facet_id('anomaly_group_id').with_maximum_facet_values_of(-1).without_pruning).faceting.get_facet('anomaly_group_id').facet_values.count


		facets = entity_type("AnalysisAnomaly_Matrix").where(filterstring).faceted_by(facet_by_subcategory.then(field('anomaly_group_id').with_facet_id('anomaly_group_id').with_maximum_facet_values_of(-1).without_pruning)).faceting

		arr = []
    #print "\n-- filterstraing for lineitem anomaly --\n"
    #print filterstring
		facets.get_facet('subcategory_id').facet_values.each do |firm|
      if params[:subcategory].eql?('full_name')
        #firm.get_facet('firm_name').facet_values.each do |readlfirm|
        data[firm.value + "||" + firm.getChildren[0].getChildren[0].value.to_s + "||" + firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].value.to_s] = firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].get_facet('anomaly_group_id').facet_values.count
        #end
      elsif params[:subcategory].eql?('matter_number')
        firm.get_facet('matter_name').facet_values.each do |readlfirm|
          data[firm.value + "||" + readlfirm.value] = readlfirm.get_facet('anomaly_group_id').facet_values.count
        end
      else

      data[firm.value] = firm.get_facet('anomaly_group_id').facet_values.count
      end

		end

		if (cattmp != "phase") && (cattmp != "task_code") && (cattmp != "full_name") && (cattmp != "rate") && (cattmp != "expense") && (subcattmp != "phase") && (subcattmp != "task_code") && (subcattmp != "full_name") && (subcattmp != "rate") && (subcattmp != "expense")

      #filterstring = getFilterString(nil,$filters,"invoice_date",$categoryfilterstring,$datefilter,nil)
      categoryfilterstring = field(params[:category]).contains(params[:categoryvalue])
      filterstring = getFilterString(nil,$filters,"invoice_date",categoryfilterstring,$datefilter,nil)
      print "\n-- filterstraing for invoice anomaly --\n"
    print filterstring

      #facets = entity_type("AnalysisInvoiceAnomalies").where(filterstring).faceted_by(facet_by_hours).faceting
      #facets.get_facet('kpi_id').facet_values.each do |anomaly|
        uniqueanomalycount = uniqueanomalycount +  entity_type("AnalysisInvoiceAnomalies").where(filterstring).total_results
    #end

			facets = entity_type("AnalysisInvoiceAnomalies").where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_hours)).faceting

			facets.get_facet('subcategory_id').facet_values.each do |firm|

      if params[:subcategory].eql?('full_name')

      elsif params[:subcategory].eql?('matter_number')
        firm.get_facet('matter_name').facet_values.each do |readlfirm|
          if data.key?(firm.value + "||" + readlfirm.value)
				   data[firm.value + "||" + readlfirm.value] = data[firm.value + "||" + readlfirm.value] + readlfirm.ndocs
			    else
				   data[firm.value + "||" + readlfirm.value] = firm.ndocs
			    end


        end
      else
         if data.key?(firm.value)
				data[firm.value] = data[firm.value] + firm.ndocs
         else
           data[firm.value] = firm.ndocs
         end
      end

			end
		end
    data["unique_anomaly_count"] = uniqueanomalycount
	else

                    if params[:selectedkpi].include?("rate")
                      facets = entity_type(entitytype).where(filterstring.and(field("task_code").is("NA").negated)).faceted_by(facet_by_subcategory.then(facet_by_hours)).faceting
                      arr = []
    if params[:subcategory].eql?('full_name')
      facets.get_facet('subcategory_id').facet_values.each do |firm|
        #firm.get_facet('firm_name').facet_values.each do |readlfirm|
            data[firm.value + "||" + firm.getChildren[0].getChildren[0].value + "||" + firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].value] = firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].getChildren.first.value
        #end
		  end
    elsif params[:subcategory].eql?('matter_number')
      facets.get_facet('subcategory_id').facet_values.each do |firm|
        firm.get_facet('matter_name').facet_values.each do |readlfirm|
            data[firm.value + "||" + readlfirm.value] = readlfirm.getChildren.first.value
        end
		  end
    else
		  facets.get_facet('subcategory_id').facet_values.each do |firm|
        data[firm.value] = firm.getChildren.first.value
		  end
    end
         facet_by_hours2 = sum(xpath('$hours')).with_facet_id('kpi_id')

    facets = entity_type(entitytype).where(filterstring.and(field("task_code").is("NA").negated)).faceted_by(facet_by_subcategory.then(facet_by_hours2)).faceting
                      arr = []
    if params[:subcategory].eql?('full_name')
      facets.get_facet('subcategory_id').facet_values.each do |firm|
        #firm.get_facet('firm_name').facet_values.each do |readlfirm|
        if firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].getChildren.first.value > 0
            data[firm.value + "||" + firm.getChildren[0].getChildren[0].value + "||" + firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].value] = ((data[firm.value + "||" + firm.getChildren[0].getChildren[0].value + "||" + firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].value])/firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].getChildren.first.value).round(2)
          else
            data[firm.value + "||" + readlfirm.value] = 0
          end
        #end
		  end
	elsif params[:subcategory].eql?('matter_number')
      facets.get_facet('subcategory_id').facet_values.each do |firm|
        firm.get_facet('matter_name').facet_values.each do |readlfirm|
          if readlfirm.getChildren.first.value > 0
            data[firm.value + "||" + readlfirm.value] = ((data[firm.value + "||" + readlfirm.value])/readlfirm.getChildren.first.value).round(2)
          else
                        data[firm.value + "||" + readlfirm.value] = 0

          end
        end
	  end
    else
		  facets.get_facet('subcategory_id').facet_values.each do |firm|
        data[firm.value] =  (data[firm.value]/firm.getChildren.first.value).round(2)
		  end
    end
                    else
                      facets = entity_type(entitytype).where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_hours)).faceting
                      arr = []
    if params[:subcategory].eql?('full_name')
      facets.get_facet('subcategory_id').facet_values.each do |firm|
        #firm.get_facet('firm_name').facet_values.each do |readlfirm|
        data[firm.value + "||" + firm.getChildren[0].getChildren[0].value + "||" + firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].value] = firm.getChildren[0].getChildren[0].getChildren[0].getChildren[0].getChildren.first.value
        #end
	  end
	 elsif params[:subcategory].eql?('matter_number')
      facets.get_facet('subcategory_id').facet_values.each do |firm|
        firm.get_facet('matter_name').facet_values.each do |readlfirm|
            data[firm.value + "||" + readlfirm.value] = readlfirm.getChildren.first.value
        end
	  end
    else
		  facets.get_facet('subcategory_id').facet_values.each do |firm|
                  data[firm.value] = firm.getChildren.first.value
		  end
    end
                    end



	end

  return data
end

# For timeline
def getDataFromFacetsTC(data,entitytype,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate)
	cattmp = params[:category]
    subcattmp = params[:subcategory]
	if (params[:selectedkpi] == "anomaly_description")

	# do lineitem anomalies first
	arr = []
	facets = entity_type("AnalysisAnomaly_Matrix").where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_invdate).then(field('anomaly_group_id').with_facet_id('anomaly_group_id').with_maximum_facet_values_of(-1).without_pruning)).faceting
		facets.get_facet('subcategory_id').facet_values.each do |firm|
		  firm.get_facet('invdate_id').facet_values.each_with_index do |invdate,index|
         datenew = invdate.value.split("/")
        actualdatenew = Date.new(datenew[2].to_i,datenew[0].to_i,datenew[1].to_i)
        arr << {(actualdatenew.to_time.to_i*1000) => invdate.get_facet('anomaly_group_id').facet_values.count}
        #arr << {invdate.value => invdate.ndocs}

		  end
		end
	#see if invoice level anomalies need to be added.

		if (cattmp != "phase") && (cattmp != "task_code") && (cattmp != "full_name") && (cattmp != "rate") && (cattmp != "expense") && (subcattmp != "phase") && (subcattmp != "task_code") && (subcattmp != "full_name") && (subcattmp != "rate") && (subcattmp != "expense")
      #filterstring = getFilterString(nil,$filters,"invoice_date",$categoryfilterstring,$datefilter,nil)
      categoryfilterstring = field(params[:category]).contains(params[:categoryvalue])
      filterstring = getFilterString(nil,$filters,"invoice_date",categoryfilterstring,$datefilter,nil)

      facet_by_invdate = xpath("viv:format-date($invoice_date,'%m/%d/%Y')").with_facet_id('invdate_id').with_maximum_facet_values_of(-1).without_pruning
			facets = entity_type("AnalysisInvoiceAnomalies").where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_invdate)).faceting
			facets.get_facet('subcategory_id').facet_values.each do |firm|
				firm.get_facet('invdate_id').facet_values.each_with_index do |invdate,index|
          datenew = invdate.value.split("/")
        actualdatenew = Date.new(datenew[2].to_i,datenew[0].to_i,datenew[1].to_i)
   arr << {(actualdatenew.to_time.to_i*1000) => invdate.ndocs}
					#arr << {invdate.value => invdate.ndocs}
                  print " \n inserted into arr \n"

				end
			end
		end

    data = arr
	else

    print "facet_by_invdate ___________"+ facet_by_invdate.to_s
		facets = entity_type(entitytype).where(filterstring).faceted_by(facet_by_subcategory.then(facet_by_invdate.then(facet_by_hours))).faceting
		facets.get_facet('subcategory_id').facet_values.each do |firm|
		  arr = []
		  firm.get_facet('invdate_id').facet_values.each_with_index do |invdate,index|
			invdate.getChildren.each do |total|
if params[:charttype].include?("matteropen")
  arr << {invdate.value => total.value}
else
  datenew = invdate.value.split("/")
        actualdatenew = Date.new(datenew[2].to_i,datenew[0].to_i,datenew[1].to_i)
			  arr << {(actualdatenew.to_time.to_i*1000) => total.value}

end

			end
			data = arr
		  end
		end
	end

#print "\n data is "
#print data
  return data
end

def getDataStore(datanew,data)
 data = data.sort_by {|k,v| v}.reverse
 datanew = {}
 i = 1
  othercount = 0
 totalrest = 0
 data.each do |key,value|
     datanew.store(key,value)
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
  if params[:charttype] == "pie"
datavalue.each_with_index do |(key, val), i|
    if key.eql? ("totalitems")
      next
    end

    if key.eql? ("average")
      next
    end
        if key.eql? ("others")
          series << "\{\"name\":\"#{key}\",\"y\": #{val}\,\"average\": #{datavalue["average"]}\,\"totalitems\": #{datavalue["totalitems"]}\}"
        else
          if params[:subcategory].eql?("full_name")
            firm_name= key.split("||")[1]
            full_name = key.split("||")[0]
            staff_level = key.split("||")[2]
            if params[:charttype] == "pie"
              series << "\{\"name\":\"#{full_name}\",\"firm_name\":\"#{firm_name}\",\"staff_level\":\"#{staff_level}\",\"y\": #{val}\}"
            else
              series << "\{\"name\":\"#{full_name}\",\"firm_name\":\"#{firm_name}\",\"staff_level\":\"#{staff_level}\",\"data\": #{val}\}"
			end
		  elsif params[:subcategory].eql?("matter_number")
            matter_name= key.split("||")[1]
            matter_number = key.split("||")[0]
            if params[:charttype] == "pie"
              series << "\{\"name\":\"#{matter_number}\",\"matter_name\":\"#{matter_name}\",\"y\": #{val}\}"
            else
              series << "\{\"name\":\"#{matter_number}\",\"matter_name\":\"#{matter_name}\",\"data\": #{val}\}"
			end
          else
            series << "\{\"name\":\"#{key}\",\"y\": #{val}\}"

          end
           unless i == datavalue.size - 1
            series << ","
           end
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
    if charttype.include?("timeline")
      data  = getDataFromFacetsTC(data,'AnalysisAnomaly_Matrix',filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate)
    else
      data  = getDataFromFacetsPBC(data,'AnalysisAnomaly_Matrix',filterstring,facet_by_subcategory,facet_by_hours)
    #print "\n data in executeQuery \n"
    #print data
    end
  else
   if charttype.include?("timeline")
      data  = getDataFromFacetsTC(data,'Analysis_Matrix',filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate)
    else
     data  = getDataFromFacetsPBC(data,'Analysis_Matrix',filterstring,facet_by_subcategory,facet_by_hours)
    end
  end
  if charttype.include?("timeline")
    datanew = data
    else
     datanew = getDataStore(datanew,data)
  end
  return datanew
end


#main code to execute all functions

if params[:charttype] == "timecomparison"
  if $datefilter.any?
    $datefilter.each do |daterange|
    data = {}

    datanew = {}

      if(categoryvalue.any?)
        datanewvalue ={}
        categoryvalue.each do |catval|
          if categoryfilterstring.nil?
            categoryfilterstring = field(category).contains(catval)
          else
          categoryfilterstring = categoryfilterstring.or(field(category).contains(catval))
          end
        end

      end


       filterstring = getFilterString(filterstring,$filters,"item_date",categoryfilterstring,$datefilter,daterange)
      dataall[daterange] = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,params[:charttype])
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

     # $categoryfilterstring = field(category).contains(catval)
       categoryfilterstring = field(category).contains(catval)
      filterstring =nil
      daterange = nil
       # filterstring = getFilterString(filterstring,$filters,"item_date",$categoryfilterstring,$datefilter,daterange)
         filterstring = getFilterString(filterstring,$filters,"item_date",categoryfilterstring,$datefilter,daterange)
      #print filterstring
        if params[:charttype].include?("timeline")
        datanewvalue[catval] = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,params[:charttype])
      else
        if params[:charttype] == "pie"
          datanew = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,params[:charttype])
        else
          dataall[catval] = executeQuery(data,datanew,selectedkpi,filterstring,facet_by_subcategory,facet_by_hours,facet_by_invdate,params[:charttype])
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
  series = series + "]"
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
others = []
  seriesmap.each_with_index do |(key,val),i|

    seriesmap[key] = makeproperarray(val,dataall)
    if key.eql? ("others")
      others = val
      others = others.to_s.gsub('"', '')
      others = others.to_s.gsub('\'y\'','"y"')
      others = others.to_s.gsub('\'average\'','"average"')
      others = others.to_s.gsub('\'totalitems\'','"totalitems"')
      #others = others.map{|n|eval n}
    else
     # series << "\{name:\"#{key}\",data: #{val}\}"
      if params[:subcategory].eql?("full_name")
            firm_name= key.split("||")[1]
            full_name = key.split("||")[0]
        staff_level = key.split("||")[2]
        series << "\{\"name\":\"#{full_name}\",\"firm_name\":\"#{firm_name}\",\"staff_level\":\"#{staff_level}\",\"data\": #{val}\}"
        elsif params[:subcategory].eql?("matter_number")
    matter_name = key.split("||")[1]
    matter_number = key.split("||")[0]
    series << "\{\"name\":\"#{matter_number}\",\"matter_name\":\"#{matter_name}\",\"data\": #{val}\}"
          else

        series << "\{\"name\":\"#{key}\",\"data\": #{val}\}"

          end
      unless i == (seriesmap.size-1)
        series << ","
        end
      end
    end

if others.empty?
else

  others1 = []

  #others.each do |test|
  #  others1 = test.to_s.gsub('\'y\'','\"y\"')
  #end

  series << "\,{\"name\":\"others\",\"data\":#{others}\}"
end
  series = series + "]"
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
others = []
seriesmap.each_with_index do |(key,val),i|
  seriesmap[key] = makeproperarray(val,dataall)
  if key.eql? ("others")

      others = val
      others = others.to_s.gsub('"', '')
      others = others.to_s.gsub('\'y\'','"y"')
      others = others.to_s.gsub('\'average\'','"average"')
      others = others.to_s.gsub('\'totalitems\'','"totalitems"')
   # print "\n ==== \n"
   # print others
      #others = others.map{|n|eval n}
    else
  if params[:subcategory].eql?("full_name")
            firm_name= key.split("||")[1]
            full_name = key.split("||")[0]
    staff_level =  key.split("||")[2]
        series << "\{\"name\":\"#{full_name}\",\"firm_name\":\"#{firm_name}\",\"staff_level\":\"#{staff_level}\",\"data\": #{val}\}"
  elsif params[:subcategory].eql?("matter_number")
    matter_name = key.split("||")[1]
    matter_number = key.split("||")[0]
    series << "\{\"name\":\"#{matter_number}\",\"matter_name\":\"#{matter_name}\",\"data\": #{val}\}"
          else

        series << "\{\"name\":\"#{key}\",\"data\": #{val}\}"

          end
      unless i == (seriesmap.size-1)
        series << ","
        end
  end
end
if others.empty?
else

  others1 = []

  #others.each do |test|
  #  others1 = test.to_s.gsub('\'y\'','\"y\"')
  #end

  series << "\,{\"name\":\"others\",\"data\":#{others}\}"
end
  series = series + "]"
    return series
end
if params[:charttype].eql?"bar"
  series = getJsonFormattedBarData(dataall)
end
if params[:charttype].eql?"pie"
  #print datanew
  series = getJsonFormattedPieData(datanew)
end
if params[:charttype].include?"timeline"
  series = "["
  datanewvalue.each do |name,month_array|
    i = 0

 month_array = month_array.sort_by {|k| k.first[0].to_i}
    month_array.each do |timeint|
      timeint.each_with_index do |(key,val),j|
        series << "[#{key},#{val}]"
        unless i == (month_array.size - 1)
          series << ","
        end
      end
      i = i +1
    end

  end
  series << "]"

end

if params[:charttype].eql?"timecomparison"
  series = getJsonFormattedTimeComparisonData(dataall)
  #

end

series.gsub!('nil','null')
series.gsub!('"Skip"','\\"Skip\\"')
#datanew.length
series.html_safe
