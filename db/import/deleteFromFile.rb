#delete.rb 19/12/2011 by andre Heughebaert
# delete two similar objects of the cristal database: people, orgunits, projects or fundings

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

def deletePerson(from, to)
  begin

    #person_class
    @conn.exec("delete from cl.person_class where person_id=$1", [from])
    #person_person
    @conn.exec("delete from cl.person_person where person1_id=$1", [from])
    @conn.exec("delete from cl.person_person where person2_id=$1", [from])
    #person_funding
    @conn.exec("delete from cl.person_funding where person_id=$1", [from])
    #person_orgunit
    @conn.exec( "delete from cl.person_orgunit where person_id=$1", [from])
     #project_person
    @conn.exec("delete from cl.project_person where person_id=$1", [from])
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

def deleteOrgunit(from, to)
  begin

    #orgunit_class
    @conn.exec("delete from cl.orgunit_class where orgunit_id=$1", [from])
    #orgunit_orgunit
    @conn.exec("delete from cl.orgunit_orgunit where orgunit1_id=$1", [from])
    @conn.exec("delete from cl.orgunit_orgunit where orgunit2_id=$1", [from])
    #orgunit_funding
    @conn.exec("delete from cl.orgunit_funding where orgunit_id=$1", [from])
    #person_orgunit
    @conn.exec( "delete from cl.person_orgunit where orgunit_id=$1", [from])
    #project_orgunit
    @conn.exec("delete from cl.project_orgunit where orgunit_id=$1", [from])
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

def deleteProject(from, to)
  begin

    #project_class
    @conn.exec("delete from cl.project_class where project_id=$1", [from])
    #project_project
    @conn.exec("delete from cl.project_project where project1_id=$1", [from])
    @conn.exec("delete from cl.project_project where project2_id=$1", [from])
    #project_funding
    @conn.exec("delete from cl.project_funding where project_id=$1", [from])
    #project_orgunit
    @conn.exec("delete from cl.project_orgunit where project_id=$1", [from])
    #project_person
    @conn.exec( "delete from cl.project_person where project_id=$1", [from])
    #project_publication
    @conn.exec("delete from cl.project_publication where project_id=$1", [from])
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

def deleteFunding(from, to)
  begin

    #funding_class
    @conn.exec("delete from cl.funding_class where funding_id=$1", [from])
    #funding_funding
    @conn.exec("delete from cl.funding_funding where funding1_id=$1", [from])
    @conn.exec("delete from cl.funding_funding where funding2_id=$1", [from])
    #project_funding
    @conn.exec("delete from cl.project_funding where funding_id=$1", [from])
    #orgunit_funding
    @conn.exec("delete from cl.orgunit_funding where funding_id=$1", [from])
    #person_funding
    @conn.exec( "delete from cl.person_funding where funding_id=$1", [from])
    #funding table
    @conn.exec("delete from cl.fundings where id=$1", [from])   
  end
end
if ARGV.length != 5
  puts "usage: deleteFromFile.rb <dbname> <user> <password> person/orgunit/project/funding <input>"
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
        puts "Deleting Person #{from} duplicate of #{to}."
        checkPerson(from)
        checkPerson(to)
#        deletePerson(from,to)      
#        puts "#{from} deleted."
      elsif what=='orgunit'
        puts "Deleting Orgunit #{from} duplicate of #{to}."
        checkOrgunit(from)
        checkOrgunit(to)
#        deleteOrgunit(from,to)
#        puts "#{from} deleted."
      elsif what=='project'
        puts "Deleting Project #{from} duplicate of #{to}."
        checkProject(from)
        checkProject(to)
        deleteProject(from,to)
#        puts "#{from} deleted."
      elsif what=='funding'
        puts "Deleting Funding #{from} duplicate of #{to}."
        checkFunding(from)
        checkFunding(to)
#        deleteFunding(from,to)
#        puts "#{from} deleted."
end
    } 
    

  
@conn.close
