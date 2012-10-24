module ClassificationsHelper
  def ClassificationsHelper.to_cfClassScheme(name,date)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => date,
    'sourceDatabase' => 'BiodivERsA') { 
      classschemes=Classscheme.all
      classschemes.each do |c|
          xml.cfClassScheme {
            xml.cfClassSchemeId c.origid  
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  def ClassificationsHelper.to_cfClass(name,date)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => date,
    'sourceDatabase' => 'BiodivERsA') { 
      classifications=Classification.all
      classifications.each do |c|
          xml.cfClass {
            xml.cfClassId     c.origid
            xml.cfClassSchemeId c.schemeorigid  
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

  def ClassificationsHelper.to_cfClassSchemeDescr(name,date)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => date,
    'sourceDatabase' => 'BiodivERsA') { 
      classschemes=Classscheme.all
      classschemes.each do |c|
          xml.cfClassSchemeDescr {
            xml.cfClassSchemeId c.origid
            xml.cfDescr('cfLangCode' => 'en', 'cfTrans' => 'o'){ xml.text(c.description) }
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end
  
  def ClassificationsHelper.to_cfClassTerm(name,date)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.CERIF('xsi:schemaLocation' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name+'.xsd',
    'xmlns' => 'http://www.eurocris.org/Uploads/Web%20pages/CERIF2008/Release_1.2/XML-SCHEMAS/'+name, 
    'xmlns:xsi' => 'http://biodiversa.biodiversity.be',
    'release' => date,
    'sourceDatabase' => 'BiodivERsA') { 
      classifications=Classification.all
      classifications.each do |c|
          xml.cfClassTerm {
            xml.cfClassId     c.origid
            xml.cfClassSchemeId c.schemeorigid
            xml.cfTerm('cfLangCode' => 'en', 'cfTrans' => 'o') { xml.text(c.term) }
          }
        end 
      }
    end
    f=File.new(name+'.xml','w')
    f.puts builder.to_xml
  end

end
