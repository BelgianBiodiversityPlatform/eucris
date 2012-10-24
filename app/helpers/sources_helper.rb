module SourcesHelper

  def SourcesHelper.to_cfEAddr(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
      s.orgunits.each do |o|
        if !o.tel.nil?
          xml.cfEAddr {
            xml.cfEAddrId     o.origid+'_Tel'
            xml.cfURI     o.tel
          }
        end
        if !o.fax.nil?
          xml.cfEAddr {
            xml.cfEAddrId     o.origid+'_Fax'
            xml.cfURI     o.fax
          }
        end
        if !o.email.nil?
          xml.cfEAddr {
            xml.cfEAddrId     o.origid+'_Email'
            xml.cfURI     o.email
          }
        end
      end 
        s.people.each do |p|
          if !p.tel.nil?
            xml.cfEAddr {
              xml.cfEAddrId     p.origid+'_Tel'
              xml.cfURI     p.tel
            }
          end
          if !p.fax.nil?
            xml.cfEAddr {
              xml.cfEAddrId     p.origid+'_Fax'
              xml.cfURI     p.fax
            }
          end
          if !p.email.nil?
            xml.cfEAddr {
              xml.cfEAddrId     p.origid+'_Email'
              xml.cfURI     p.email
            }
          end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfFund_Class(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.fundings.each do |f|
           f.classifications.each do |c|
             xml.cfFund_Class {
               xml.cfFundId f.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfFund(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.fundings.each do |f|
          xml.cfFund {
            xml.cfFundId    f.origid
            xml.cfStartDate f.startdate
            xml.cfEndDate   f.endate
            xml.cfCurrCode  f.currency
            xml.cfAmount    f.amount
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  def SourcesHelper.to_cfFund_Fund(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.fundings.each do |f|
           f.fundings.each do |link|
             c=Classification.find(link.classification_id)
             xml.cfFund_Fund {
               xml.cfFundId f.origid
               xml.cfFundId link.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
               xml.cfStartDate link.startdate
               xml.cfEndDate link.enddate
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  def SourcesHelper.to_cfOrgUnit_Class(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.orgunits.each do |o|
           o.classifications.each do |c|
             xml.cfOrgUnit_Class {
               xml.cfOrgUnitId o.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfOrgUnit(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.orgunits.each do |o|
          xml.cfOrgunit {
            xml.cfOrgUnitId    o.origid
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfOrgUnitName(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.orgunits.each do |o|
          xml.cfOrgunitName {
            xml.cfOrgUnitId    o.origid
            xml.cfName  o.name
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  

  def SourcesHelper.to_cfOrgUnit_EAddr(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.orgunits.each do |o|
          if !o.tel.nil?
            xml.cfOrgUnit_EAddr {
              xml.cfOrgUnitId   o.origid
              xml.cfEAddrId     o.origid+'_Tel'
              xml.cfClassId     'Tel'
              xml.cfClassSchemeId 'LinkRoles'  
            }
          end
          if !o.fax.nil?
            xml.cfOrgUnit_EAddr {
              xml.cfOrgUnitId   o.origid
              xml.cfEAddrId     o.origid+'_Fax'
              xml.cfClassId     'Fax'
              xml.cfClassSchemeId 'LinkRoles'  
            }
          end
          if !o.email.nil?
            xml.cfOrgUnit_EAddr {
              xml.cfOrgUnitId   o.origid
              xml.cfEAddrId     o.origid+'_Email'
              xml.cfClassId     'Email'
              xml.cfClassSchemeId 'LinkRoles'  
            }
          end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfOrgUnit_OrgUnit(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.orgunits.each do |o|
           o.orgunits.each do |link|
             c=Classification.find(link.classification_id)
             xml.cfOrgUnit_OrgUnit {
               xml.cfOrgUnitId o.origid
               xml.cfOrgUnitId link.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
               xml.cfStartDate link.startdate
               xml.cfEndDate link.enddate
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  def SourcesHelper.to_cfOrgUnit_PAddr(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.orgunits.each do |o|
          xml.cfOrgunit_PAddr {
            xml.cfOrgUnitId   o.origid
            xml.cfPAddrId     o.origid+'_PAddr'
            xml.cfClassId     'PAddr'
            xml.cfClassSchemeId 'LinkRoles'  
            xml.cfStartDate   o.startdate
            xml.cfEndDate   o.enddate
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfPAddr(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.orgunits.each do |o|
          xml.cfPAddr {
            xml.cfPAddrId     o.origid+'_PAddr'
            xml.cfCountryCode o.country
            xml.cfAddrline1   o.addrline1
            xml.cfAddrline2   o.addrline2
            xml.cfAddrline3   o.addrline3
            xml.cfPostCode    o.postcode
            xml.cfCityTown    o.city 
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfPers(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.people.each do |p|
          xml.cfPers {
            xml.cfPersId    p.origid
            xml.cfGender    p.gender
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfPers_Class(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.people.each do |p|
           p.classifications.each do |c|
             xml.cfPers_Class {
               xml.cfPersId p.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfPersName(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.people.each do |p|
          xml.cfPersName {
            xml.cfPersId    p.origid
            xml.cfFamilyNames    p.familyname
            xml.cfFirstName    p.firstname
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end


  def SourcesHelper.to_cfPers_EAddr(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.people.each do |p|
          if !p.tel.nil?
            xml.cfPers_EAddr {
              xml.cfPersId   p.origid
              xml.cfEAddrId     p.origid+'_Tel'
              xml.cfClassId     'Tel'
              xml.cfClassSchemeId 'LinkRoles'  
            }
          end
          if !p.fax.nil?
            xml.cfPers_EAddr {
              xml.cfPersId   p.origid
              xml.cfEAddrId     p.origid+'_Fax'
              xml.cfClassId     'Fax'
              xml.cfClassSchemeId 'LinkRoles'  
            }
          end
          if !p.email.nil?
            xml.cfPers_EAddr {
              xml.cfPersId   p.origid
              xml.cfEAddrId     p.origid+'_Email'
              xml.cfClassId     'Email'
              xml.cfClassSchemeId 'LinkRoles'  
            }
          end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfPers_OrgUnit(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.people.each do |p|
           p.orgunits.each do |o|
             c=Classification.find(o.classification_id)
             xml.cfPers_OrgUnit {
               xml.cfPersId p.origid
               xml.cfOrgUnitId o.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
               xml.cfStartDate o.startdate
               xml.cfEndDate o.enddate
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfProj_Class(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.projects.each do |p|
           p.classifications.each do |c|
             xml.cfProj_Class {
               xml.cfProjId p.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  
  def SourcesHelper.to_cfProj(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') { 
        s.projects.each do |p|
          xml.cfProj {
            xml.cfProjId    p.origid
            xml.cfStartDate p.startdate
            xml.cfEndDate   p.enddate
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfProjAbstr(s,name)
     builder = Nokogiri::XML::Builder.new do |xml|
     xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
     'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
     'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
     'release' => @releaseDate,
     'sourceDatabase' => 'BiodivERsA') { 
       s.projects.each do |p|
           xml.cfProjAbstr {
             xml.cfProjId     p.origid
             xml.cfAbstr('cfLangCode' => 'en', 'cfTrans' => 'o') { xml.text(p.abstract) }
           }
         end 
       }
     end
     f=File.new(name+'.xml','w')
     f.puts builder.to_xml
   end

   def SourcesHelper.to_cfProjTitle(s,name)
      builder = Nokogiri::XML::Builder.new do |xml|
      xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
      'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
      'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
      'release' => @releaseDate,
      'sourceDatabase' => 'BiodivERsA') { 
        s.projects.each do |p|
            xml.cfProjAbstr {
              xml.cfProjId     p.origid
              xml.cfTitle('cfLangCode' => 'en', 'cfTrans' => 'o') { xml.text(p.title) }
            }
          end 
        }
      end
      f=File.new(name+'.xml','w')
      f.puts builder.to_xml
    end




  def SourcesHelper.to_cfProj_Fund(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.projects.each do |p|
           p.fundings.each do |link|
             c=Classification.find(link.classification_id)
             xml.cfProj_Fund {
               xml.cfProjId p.origid
               xml.cfFundId link.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
               xml.cfStartDate link.startdate
               xml.cfEndDate link.enddate
               xml.cfCurrCode link.currency
               xml.cfAmount link.amount
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfProj_OrgUnit(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.projects.each do |p|
           p.orgunits.each do |link|
             c=Classification.find(link.classification_id)
             xml.cfProj_OrgUnit {
               xml.cfProjId p.origid
               xml.cfOrgUnitId link.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
               xml.cfStartDate link.startdate
               xml.cfEndDate link.enddate
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def SourcesHelper.to_cfProj_Pers(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.projects.each do |p|
           p.people.each do |link|
             c=Classification.find(link.classification_id)
             xml.cfProj_Pers {
               xml.cfProjId p.origid
               xml.cfPersId link.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
               xml.cfStartDate link.startdate
               xml.cfEndDate link.enddate

             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  def SourcesHelper.to_cfProj_Proj(s,name)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => @releaseDate,
    'sourceDatabase' => 'BiodivERsA') {
         s.projects.each do |p|
           p.projects.each do |link|
             c=Classification.find(link.classification_id)
             xml.cfProj_Proj {
               xml.cfProjId p.origid
               xml.cfProjId link.origid
               xml.cfClassId  c.origid
               xml.cfClassSchemeId  c.schemeorigid
               xml.cfStartDate link.startdate
               xml.cfEndDate link.enddate
             }
           end
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  
  def SourcesHelper.install(filename)
    if File.file?(filename) then File.unlink(filename) end
      File.link('../'+filename, filename)
  end  
  def SourcesHelper.to_CERIF
    now =DateTime.now
    @releaseDate=Date.new(now.year,now.month,now.day)
    
    Dir.chdir('export')
    ClassificationsHelper.to_cfClassScheme('cfClassScheme-CLASS', @releaseDate)
    ClassificationsHelper.to_cfClassSchemeDescr('cfClassSchemeDescr-LANG', @releaseDate)
    ClassificationsHelper.to_cfClass('cfClass-CLASS', @releaseDate)
    ClassificationsHelper.to_cfClassTerm('cfClassTerm-LANG', @releaseDate)
    
    sources=Source.all
    sources.each do |s|
    puts s.origid
    Dir.mkdir(s.origid)
    Dir.chdir(s.origid)

    install('cfClassScheme-CLASS.xml')
    install('cfClassSchemeDescr-LANG.xml')
    install('cfClass-CLASS.xml')
    install('cfClassTerm-LANG.xml')

    to_cfEAddr(s,'cfEAddr-2ND')

    to_cfFund(s,'cfFund-2ND')
    to_cfFund_Class(s,'cfFund_Class-LINK')
    to_cfFund_Fund(s,'cfFund_Fund-LINK')

    to_cfOrgUnit(s,'cfOrgUnit-BASE')
    to_cfOrgUnitName(s,'cfOrgUnitName-LANG')
    to_cfOrgUnit_Class(s,'cfOrgUnit_Class-LINK')
    to_cfOrgUnit_EAddr(s,'cfOrgUnit_EAddr-LINK')
    to_cfOrgUnit_PAddr(s,'cfOrgUnit_PAddr-LINK')
    to_cfOrgUnit_OrgUnit(s,'cfOrgUnit_OrgUnit-LINK')

    to_cfPAddr(s,'cfPAddr-2ND')

    to_cfPers(s,'cfPers-BASE')
    to_cfPersName(s,'cfPersName-LANG')
    to_cfPers_Class(s,'cfPers_Class-LINK')
    to_cfPers_EAddr(s,'cfPers_EAddr-LINK')
    to_cfPers_OrgUnit(s,'cfPers_OrgUnit-LINK')

    to_cfProj(s,'cfProj-BASE')
    to_cfProjAbstr(s,'cfProjAbstr-LANG')
    to_cfProjTitle(s,'cfProjTitle-LANG')
    to_cfProj_Class(s,'cfProj_Class-LINK')
    to_cfProj_Fund(s, 'cfProjFund-LINK')
    to_cfProj_OrgUnit(s,'cfProj_OrgUnit-LINK')
    to_cfProj_Pers(s,'cfProj_Pers-LINK')
    to_cfProj_Proj(s,'cfProj_Proj-LINK')

    Dir.chdir('..')
    end #each source
  end

end
