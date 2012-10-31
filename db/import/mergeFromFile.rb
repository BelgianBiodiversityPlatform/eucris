#merge.rb 19/12/2011 by andre Heughebaert
# merge two similar objects of the cristal database: people, orgunits, projects or fundings

require 'rubygems'
require 'pg'

def checkPerson(id)
  begin
    sql = "select firstname, familyname from cl.people where id=#{id}"
    res = @conn.exec(sql)
    res.each do |s|
        puts "Person #{id}=#{s['familyname']}, #{s['firstname']}"
    end
  end
end

def mergePerson(from, to)
  begin

    #person_class
    @conn.exec("delete from cl.person_class where person_id=$1 and classification_id in (select classification_id from cl.person_class where person_id=$2)", [from, to])
    @conn.exec("update cl.person_class set person_id=$2 where person_id=$1", [from, to])
    #person_person
    @conn.exec("delete from cl.person_person where person1_id=$1 and person2_id in (select person2_id from cl.person_person where person1_id=$2)", [from, to])
    @conn.exec("delete from cl.person_person where person2_id=$1 and person1_id in (select person1_id from cl.person_person where person2_id=$2)", [from, to])
    @conn.exec("update cl.person_person set person1_id=$2 where person1_id=$1", [from, to])
    @conn.exec("update cl.person_person set person2_id=$2 where person2_id=$1", [from, to])
    #person_funding
    @conn.exec("delete from cl.person_funding where person_id=$1 and funding_id in (select funding_id from cl.person_funding where person_id=$2)", [from, to])
    @conn.exec("update cl.person_funding set person_id=$2 where person_id=$1", [from, to])
    #person_orgunit
    @conn.exec( "delete from cl.person_orgunit where person_id=$1 and orgunit_id in (select orgunit_id from cl.person_orgunit where person_id=$2)", [from, to])
    @conn.exec( "update cl.person_orgunit set person_id=$2 where person_id=$1", [from, to])
    #project_person
    @conn.exec("delete from cl.project_person where person_id=$1 and project_id in (select project_id from cl.project_person where person_id=$2)", [from, to])
    @conn.exec( "update cl.project_person set person_id=$2 where person_id=$1", [from, to])
    #person table
    @conn.exec("delete from cl.people where id=$1", [from])   
  end
end

def checkOrgunit(id)
  begin
    sql = "select origid, name from cl.orgunits where id=#{id}"
    res = @conn.exec(sql)
    res.each do |s|
        puts "Orgunit #{id}=#{s['origid']}, #{s['name']}"
    end
  end
end

def mergeOrgunit(from, to)
  begin

    #orgunit_class
    @conn.exec("delete from cl.orgunit_class where orgunit_id=$1 and classification_id in (select classification_id from cl.orgunit_class where orgunit_id=$2)", [from, to])
    @conn.exec("update cl.orgunit_class set orgunit_id=$2 where orgunit_id=$1", [from, to])
    #orgunit_orgunit
    @conn.exec("delete from cl.orgunit_orgunit where orgunit1_id=$1 and orgunit2_id in (select orgunit2_id from cl.orgunit_orgunit where orgunit1_id=$2)", [from, to])
    @conn.exec("delete from cl.orgunit_orgunit where orgunit2_id=$1 and orgunit1_id in (select orgunit1_id from cl.orgunit_orgunit where orgunit2_id=$2)", [from, to])
    @conn.exec("update cl.orgunit_orgunit set orgunit1_id=$2 where orgunit1_id=$1", [from, to])
    @conn.exec("update cl.orgunit_orgunit set orgunit2_id=$2 where orgunit2_id=$1", [from, to])
    #orgunit_funding
    @conn.exec("delete from cl.orgunit_funding where orgunit_id=$1 and funding_id in (select funding_id from cl.orgunit_funding where orgunit_id=$2)", [from, to])
    @conn.exec("update cl.orgunit_funding set orgunit_id=$2 where orgunit_id=$1", [from, to])
    #person_orgunit
    @conn.exec( "delete from cl.person_orgunit where orgunit_id=$1 and person_id in (select person_id from cl.person_orgunit where orgunit_id=$2)", [from, to])
    @conn.exec( "update cl.person_orgunit set orgunit_id=$2 where orgunit_id=$1", [from, to])
    #project_orgunit
    @conn.exec("delete from cl.project_orgunit where orgunit_id=$1 and project_id in (select project_id from cl.project_orgunit where orgunit_id=$2)", [from, to])
    @conn.exec( "update cl.project_orgunit set orgunit_id=$2 where orgunit_id=$1", [from, to])
    #orgunit table
    @conn.exec("delete from cl.orgunits where id=$1", [from])   
  end
end

def checkProject(id)
  begin
    sql = "select origid, title from cl.projects where id=#{id}"
    res = @conn.exec(sql)
    res.each do |s|
        puts "Project #{id}=#{s['origid']}, #{s['title']}"
    end
  end
end

def mergeProject(from, to)
  begin

    #project_class
    @conn.exec("delete from cl.project_class where project_id=$1 and classification_id in (select classification_id from cl.project_class where project_id=$2)", [from, to])
    @conn.exec("update cl.project_class set project_id=$2 where project_id=$1", [from, to])
    #project_project
    @conn.exec("delete from cl.project_project where project1_id=$1 and project2_id in (select project2_id from cl.project_project where project1_id=$2)", [from, to])
    @conn.exec("delete from cl.project_project where project2_id=$1 and project1_id in (select project1_id from cl.project_project where project2_id=$2)", [from, to])
    @conn.exec("update cl.project_project set project1_id=$2 where project1_id=$1", [from, to])
    @conn.exec("update cl.project_project set project2_id=$2 where project2_id=$1", [from, to])
    #project_funding
    @conn.exec("delete from cl.project_funding where project_id=$1 and funding_id in (select funding_id from cl.project_funding where project_id=$2)", [from, to])
    @conn.exec("update cl.project_funding set project_id=$2 where project_id=$1", [from, to])
    #project_orgunit
    @conn.exec("delete from cl.project_orgunit where project_id=$1 and orgunit_id in (select orgunit_id from cl.project_orgunit where project_id=$2)", [from, to])
    @conn.exec( "update cl.project_orgunit set project_id=$2 where project_id=$1", [from, to])
    #project_person
    @conn.exec( "delete from cl.project_person where project_id=$1 and person_id in (select person_id from cl.project_person where project_id=$2)", [from, to])
    @conn.exec( "update cl.project_person set project_id=$2 where project_id=$1", [from, to])
    #project_publication
    @conn.exec("delete from cl.project_publication where project_id=$1 and publication_id in (select publication_id from cl.project_publication where project_id=$2)", [from, to])
    @conn.exec( "update cl.project_publication set project_id=$2 where project_id=$1", [from, to])
    #project table
    @conn.exec("delete from cl.projects where id=$1", [from])   
  end
end

def checkFunding(id)
  begin
    sql = "select origid, name from cl.fundings where id=#{id}"
    res = @conn.exec(sql)
    res.each do |s|
        puts "Funding #{id}=#{s['origid']}, #{s['name']}"
    end
  end
end

def mergeFunding(from, to)
  begin

    #funding_class
    @conn.exec("delete from cl.funding_class where funding_id=$1 and classification_id in (select classification_id from cl.funding_class where funding_id=$2)", [from, to])
    @conn.exec("update cl.funding_class set funding_id=$2 where funding_id=$1", [from, to])
    #funding_funding
    @conn.exec("delete from cl.funding_funding where funding1_id=$1 and funding2_id in (select funding2_id from cl.funding_funding where funding1_id=$2)", [from, to])
    @conn.exec("delete from cl.funding_funding where funding2_id=$1 and funding1_id in (select funding1_id from cl.funding_funding where funding2_id=$2)", [from, to])
    @conn.exec("update cl.funding_funding set funding1_id=$2 where funding1_id=$1", [from, to])
    @conn.exec("update cl.funding_funding set funding2_id=$2 where funding2_id=$1", [from, to])
    #project_funding
    @conn.exec("delete from cl.project_funding where funding_id=$1 and project_id in (select project_id from cl.project_funding where funding_id=$2)", [from, to])
    @conn.exec("update cl.project_funding set funding_id=$2 where funding_id=$1", [from, to])
    #orgunit_funding
    @conn.exec("delete from cl.orgunit_funding where funding_id=$1 and orgunit_id in (select orgunit_id from cl.orgunit_funding where funding_id=$2)", [from, to])
    @conn.exec( "update cl.orgunit_funding set funding_id=$2 where funding_id=$1", [from, to])
    #person_funding
    @conn.exec( "delete from cl.person_funding where funding_id=$1 and person_id in (select person_id from cl.person_funding where funding_id=$2)", [from, to])
    @conn.exec( "update cl.person_funding set funding_id=$2 where funding_id=$1", [from, to])
    #funding table
    @conn.exec("delete from cl.fundings where id=$1", [from])   
  end
end
if ARGV.length != 5
  puts "usage: merge.rb <dbname> <user> <password> person/orgunit/project/funding <input>"
  exit
end

dbHost = "dev"
dbPort = 5432
dbName=ARGV[0]
dbLogin=ARGV[1]
dbPasswd=ARGV[2]
what=ARGV[3]
input= ARGV[4]


@conn = PGconn.connect(dbHost, dbPort,"","", dbName, dbLogin, dbPasswd)

    lines = IO.readlines(input)
    lines.each { |l|
      args=l.split(/\t/)
      from= args[0].to_i
      to=args[1].to_i
      if what=='person'
        puts "Merging Person #{from} into #{to}."
        checkPerson(from)
        checkPerson(to)
#        mergePerson(from,to)      
      elsif what=='orgunit'
        puts "Merging Orgunit #{from} into #{to}."
        checkOrgunit(from)
        checkOrgunit(to)
#        mergeOrgunit(from,to)
#        puts "#{from} merged into #{to}."
      elsif what=='project'
        puts "Merging Project #{from} into #{to}."
        checkProject(from)
        checkProject(to)
#        mergeProject(from,to)
#        puts "#{from} merged into #{to}."
      elsif what=='funding'
        puts "Merging Funding #{from} into #{to}."
        checkFunding(from)
        checkFunding(to)
#        mergeFunding(from,to)
#        puts "#{from} merged into #{to}."
end
    } 
    

  
@conn.close
