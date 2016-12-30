#taking all the required user input
def group_by_input
  begin
    print "Enter valid Group_by ?  "
    group_bi = gets.chomp
    group_bi.downcase!
  end until (["student_id","department","year"].include? group_bi)
  return group_bi
end

def sort_by_input
  begin
    print "Enter valid Sort_by ?  "
    sort_bi = gets.chomp
    sort_bi.downcase!
  end until (["physics", "chemistry", "maths"].include? sort_bi)
  return sort_bi
end

def display_fields_input(records)
  begin
    print "Enter all valid Display_fields ?  "
    display = gets.chomp
    display.downcase!
    display_fields = display.split(",")
    flag = true

    display_fields.each do |field|
      unless records[0].has_key? field.to_sym
        puts "#{field} is not a valid field"
        flag = false
      end
    end         #end of loop display_fields

  end until flag    #end of begin
  return display_fields
end

def should_compare_input?
  begin
    print "Should_compare (true/false) ? "
    should_compare = gets.chomp
    should_compare.downcase!
  end until (["true","false"].include? should_compare)
  return (should_compare == "true"? true : false)
end

def compare_on_input
  begin
    print "Enter valid field to Compare_on ?  "
    compare_on = gets.chomp
    compare_on.downcase!
  end until (["student_id","department","year"].include? compare_on)
  return compare_on
end

def comparer_element_input(records, compare_on, num_inp)
  begin
    print "Enter valid #{num_inp}_comparer_element:  "
    comparer_element = gets.chomp
    comparer_element.downcase!
  end until records.any? {|record| record[compare_on.to_sym].to_s == comparer_element.to_s}
  return comparer_element
end

def show_total_input?
  begin
    print "Show_total (true/false) ? "
    show_total = gets.chomp
    show_total.downcase!
  end until (["true","false"].include? show_total)
  return (show_total == "true"? true : false)
end

#group_by logic
def group_by_functionality(records, group_bi, should_compare, compare_on)
  duplicate = []
  records.each do |record|
    flag = false;
    duplicate.each do |dup_record|
      if dup_record[group_bi.to_sym] == record[group_bi.to_sym]
        if (!should_compare || (should_compare && dup_record[compare_on.to_sym] == record[compare_on.to_sym] ))
          flag = true;
          dup_record[:maths] += record[:maths]
          dup_record[:physics] += record[:physics]
          dup_record[:chemistry] += record[:chemistry]
          dup_record[:count] += 1
        end   #end of inner if
      end     #end of outer if
    end       #end of duplicate
    duplicate << record if flag == false
  end         #end of records
  return duplicate
end           #end of group_by_functionality

#in group_by taking the average using count
def averaging_of_group_by(duplicate)
  duplicate.each do |dup_record|
    dup_record.each do |key,val|
      dup_record[key] = val/dup_record[:count] if ([:maths, :physics, :chemistry].include? key)
    end
  end
end           #end of averaging_of_group_by

#sorting
def sort_by_functionality(duplicate, sort_bi)
  duplicate.sort! do |a,b|
    b[sort_bi.to_sym] <=> a[sort_bi.to_sym]      # b<=>a for descending order
  end
end          #end of sort_by_functionality

#displaying the output
def display_fields_only(group_bi, display_fields)
  puts "\n"
  print "#{group_bi}     "
  display_fields.each do |field|
    print "#{field}       "
  end
  puts " "
end

#displaying data
def display_unless_should_compare(group_bi, display_fields, duplicate)
  duplicate.each do |dup_record|
    print "#{dup_record[group_bi.to_sym]}               "
    display_fields.each do |field|
       print "#{dup_record[field.to_sym]}             "
    end         #end of field
    puts " "
  end         #end of dup_record
end

def display_missing_comparer_element(comparer_element, display_fields)
  if comparer_element[:maths] == 0 && comparer_element[:physics] == 0 && comparer_element[:chemistry] == 0      #for missing comparer element 1
    print "year:#{comparer_element[:year]}         "
    display_fields.each do |field|
      print "#{comparer_element[field.to_sym]}               "
    end
    puts " "
  end
end

def display_if_should_compare(duplicate, display_fields, compare_on, first_element, second_element)
  check_duplicates = []
  duplicate.each do |dup_record1|                                      #iterating whole length of duplicate array
    unless check_duplicates.include? dup_record1[:student_id]       #check for duplicates
      puts dup_record1[:student_id]                                 #print id for the first entry
      check_duplicates << dup_record1[:student_id]                  #push the element into dup array for later reference

      f1 = {maths: 0, physics: 0, chemistry: 0, year: first_element}      #initializing f1 & f2 to 0
      f2 = {maths: 0, physics: 0, chemistry: 0, year: second_element}
      duplicate.each do |dup_record2|                              #iterating the inner loop for remaining duplicates of current element
        if dup_record1[:student_id] == dup_record2[:student_id]
          f1=dup_record2 if dup_record2[compare_on.to_sym] == first_element.to_i   #storing f1 & f2 objects to find change
          f2=dup_record2 if dup_record2[compare_on.to_sym] == second_element.to_i
          print "year:#{dup_record2[compare_on.to_sym]}         "
          display_fields.each do |field|
            print "#{dup_record2[field.to_sym]}             "
          end
          puts " "
        end #end of if
      end #end of inner loop of duplicate

      display_missing_comparer_element(f1, display_fields)
      display_missing_comparer_element(f2, display_fields)

      print "Change            "
      display_fields.each do |field|
        if f1[field.to_sym].nonzero?
          print "#{(f1[field.to_sym] - f2[field.to_sym]) * 100 / (f1[field.to_sym])}%            "
        else
            print "N/A             "
        end      #end of if
      end        #end of loop display_fields
      puts " "
    end     #end of inner unless
  end       #end of outer loop of duplicate
end         #end of display_if_should_compare method

#show_total
def show_only_total(display_fields, duplicate)
  print "Total           "
  display_fields.each do |field|
    sum = 0
    duplicate.each do |dup_record|
      sum += dup_record[field.to_sym]
    end
    print "#{sum}            "
  end
  puts " "
end

#method for adding elements for getting and printing total on comparer elements
def add_elements(element,display_fields,duplicate,compare_on)
  print "Total(#{element})        "
  display_fields.each do |field|
    sum = 0
    duplicate.each do |dup_record|
      sum += dup_record[field.to_sym] if dup_record[compare_on.to_sym] == element.to_i
    end
    print "#{sum}            "
  end           #end of display_fields
  puts " "
end             #end of add_elements method

def start_of_main
  #input data from given assignment
  records = [ {student_id: 1, department: "a1", maths: 43, physics: 54, chemistry:65, year: 2016, count: 1},
              {student_id: 2, department: "a1", maths: 66, physics: 52, chemistry:65, year: 2016, count: 1},
              {student_id: 3, department: "a7", maths: 87, physics: 32, chemistry:43, year: 2016, count: 1},
              {student_id: 1, department: "a1", maths: 21, physics: 52, chemistry:65, year: 2015, count: 1},
              {student_id: 2, department: "a1", maths: 68, physics: 50, chemistry:65, year: 2015, count: 1},
              {student_id: 3, department: "a7", maths: 85, physics: 22, chemistry:43, year: 2015, count: 1},
              {student_id: 4, department: "a7", maths: 21, physics: 22, chemistry:13, year: 2016, count: 1} ]

  #defining & initializing
  group_bi = group_by_input
  sort_bi = sort_by_input
  display_fields = display_fields_input(records)
  should_compare = should_compare_input?

  if should_compare
    compare_on = compare_on_input
    first_element = comparer_element_input(records, compare_on, "First")
    second_element = comparer_element_input(records, compare_on, "Second")
  end
  show_total = show_total_input?

  #calling all the methods
  duplicate = group_by_functionality(records, group_bi, should_compare, compare_on)
  averaging_of_group_by(duplicate)
  sort_by_functionality(duplicate, sort_bi)

  display_fields_only(group_bi, display_fields)
  unless should_compare
    display_unless_should_compare(group_bi, display_fields, duplicate)
  else
    display_if_should_compare(duplicate, display_fields, compare_on, first_element, second_element)
  end

  if show_total
    if should_compare
      puts " "
      add_elements(first_element,display_fields,duplicate,compare_on)       #print for first compare element
      add_elements(second_element,display_fields,duplicate,compare_on)      #print for second_element
    end
    puts " "
    show_only_total(display_fields, duplicate)        #printing only total if should_compare is false and show_total is true
  end     #end of if show_total_input
end       #end of start_of_main method

start_of_main           #calling main method
