#input data from given assignment

records = []

record = {
  student_id: 1,
  department: "a1",
  maths: 43,
  physics: 54,
  chemistry:65,
  year: 2016,
  count: 1
}
records << record

record = {
  student_id: 2,
  department: "a1",
  maths: 66,
  physics: 52,
  chemistry:65,
  year: 2016,
  count: 1
}
records << record

record = {
  student_id: 3,
  department: "a7",
  maths: 87,
  physics: 32,
  chemistry:43,
  year: 2016,
  count: 1
}
records << record

record = {
  student_id: 1,
  department: "a1",
  maths: 21,
  physics: 52,
  chemistry:65,
  year: 2015,
  count: 1
}
records << record

record = {
  student_id: 2,
  department: "a1",
  maths: 68,
  physics: 50,
  chemistry:65,
  year: 2015,
  count: 1
}
records << record

record = {
  student_id: 3,
  department: "a7",
  maths: 85,
  physics: 22,
  chemistry:43,
  year: 2015,
  count: 1
}
records << record

record = {
  student_id: 4,
  department: "a7",
  maths: 21,
  physics: 22,
  chemistry:13,
  year: 2016,
  count: 1
}
records << record

#starting of the program

#taking user input
print "Group_by ?  "
group_bi = gets.chomp
group_bi.downcase!

while (group_bi != "student_id" && group_bi != "department" && group_bi != "year")
  print "Enter valid Group_by ?  "
  group_bi = gets.chomp
  group_bi.downcase!
end

print "Sort_by ?  "
sort_bi = gets.chomp
sort_bi.downcase!

while (sort_bi != "maths" && sort_bi != "physics" && sort_bi != "chemistry")
  print "Enter valid Group_by ?  "
  sort_bi = gets.chomp
  sort_bi.downcase!
end

print "Display_fields ?  "
display = gets.chomp
display.downcase!
display_fields = display.split(",")

display_fields.each {
  |field| puts "#{field} is not a valid field" unless records[0].has_key? field.to_sym
}

print "Should_compare ?  "
should_compare = ((gets.chomp).downcase == "true")
if should_compare
  print "Compare_on ?  "
  compare_on = gets.chomp
  print "First_comprer_element:  "
  first_element = gets.chomp
  print "Second_comparer_element:  "
  second_element = gets.chomp
end

print "Show_total ?  "
show_total = ((gets.chomp).downcase == "true")

#group_by logic
duplicate = []

records.each{
  |record|
  flag = false;
  duplicate.each{
    |dup_record|
    (flag = true;
    dup_record[:maths] += record[:maths]
    dup_record[:physics] += record[:physics]
    dup_record[:chemistry] += record[:chemistry]
    dup_record[:count] += 1
    ) if (!should_compare && (dup_record[group_bi.to_sym] == record[group_bi.to_sym])) || (should_compare && (dup_record[group_bi.to_sym] == record[group_bi.to_sym]) && (dup_record[compare_on.to_sym] == record[compare_on.to_sym] ))
  }

  duplicate << record if flag == false
}



#in group_by taking the average using count
duplicate.each{
  |dup_record|
  dup_record.each{
    |key,val|
    dup_record[key] = val/dup_record[:count] if key == :maths || key == :physics || key == :chemistry
  }
}

#sorting
duplicate.sort!{
  |a,b| b[sort_bi.to_sym] <=> a[sort_bi.to_sym]  # b<=>a for descending order
}

#display

#displaying fields

print "#{group_bi}     "
display_fields.each{ |field| print "#{field}       "}
puts " "

#displaying data
unless should_compare   # if should_compare is true
  duplicate.each{
    |dup_record|
    print "#{dup_record[group_bi.to_sym]}               "
    display_fields.each{
      |field| print "#{dup_record[field.to_sym]}             "
    }
    puts " "
  }

else  # if should_compare is true
  check_duplicates = []

  for index1 in 0...duplicate.length                                  #iterating whole length of duplicate array
    unless check_duplicates.include? duplicate[index1][:student_id]   #check for duplicates
      puts duplicate[index1][:student_id]                             #print id for the first entry
      check_duplicates << duplicate[index1][:student_id]              #push the element into dup array for later reference

      f1 = {maths: 0, physics: 0, chemistry: 0, year: first_element}                       #initializing f1 & f2 to 0
      f2 = {maths: 0, physics: 0, chemistry: 0, year: second_element}
      for index2 in index1...duplicate.length                         #iterating the inner loop for remaining duplicates of current element
        if duplicate[index1][:student_id] == duplicate[index2][:student_id]
          f1=duplicate[index2] if duplicate[index2][compare_on.to_sym] == first_element.to_i   #storing f1 & f2 objects to find change
          f2=duplicate[index2] if duplicate[index2][compare_on.to_sym] == second_element.to_i
          print "year:#{duplicate[index2][compare_on.to_sym]}         "
          display_fields.each{
            |field| print "#{duplicate[index2][field.to_sym]}             "
          }
          puts " "
        end #end of if
      end #end of inner for

      if f1[:maths] == 0 && f1[:physics] == 0 && f1[:chemistry] == 0   #for missing comparer element 1
        print "year:#{f1[:year]}         "
        display_fields.each{
          |field| print "#{f1[field.to_sym]}               "
        }
        puts " "
      elsif f2[:maths] == 0 && f2[:physics] == 0 && f2[:chemistry] == 0   #for missing comparer element 2
        print "year:#{f2[:year]}         "
        display_fields.each{
          |field| print "#{f2[field.to_sym]}               "
        }
        puts " "
      end

      print "Change            "
      display_fields.each{
        |field| print "#{(f1[field.to_sym] - f2[field.to_sym])*100/ (f1[field.to_sym].nonzero? || 1)}%            "
      }
      puts " "
    end     #end of inner unless
  end       #end of outer for

end   #end of outer unless & else


#function for adding elements for getting total
def add_elements(element,display_fields,duplicate,compare_on)
  print "Total(#{element})        "
  display_fields.each{
    |field|
    sum = 0
    duplicate.each{
      |dup_record| sum += dup_record[field.to_sym] if dup_record[compare_on.to_sym] == element.to_i
    }
    print "#{sum}            "
  }
  puts " "
end


#show_total
if show_total
  if should_compare
    puts " "
    #for first compare element
    add_elements(first_element,display_fields,duplicate,compare_on)

    #for second_element
    add_elements(second_element,display_fields,duplicate,compare_on)
  end
  puts " "
  print "Total           "
  display_fields.each{
    |field|
    sum = 0
    duplicate.each{
      |dup_record|  sum += dup_record[field.to_sym]
    }
    print "#{sum}            "
  }
  puts " "
end
