import os.path
import xml.etree.ElementTree as xml
# install lib lxml
# sudo pip install lxml

class Pik:
    def __init__(self, name):
        self.name  = name
        self.paths = []
        self.isHave = False

    def addpath(self, path):
        self.paths.append(path)

    def checkPik(self):
    	isHave = False
        for path in self.paths:
        	if os.path.isfile(path):
        		isHave = True
        self.isHave = isHave 
        print(self.name, self.isHave)

p1 = Pik("Skills")
p1.addpath("../app/controllers/test_controller.rb")
p1.addpath("../app/controllers/ka_tests_controller.rb")
p1.addpath("../app/controllers/ka_answers_controller.rb") 
p1.addpath("../app/controllers/ka_questions_controller.rb") 
p1.addpath("../app/controllers/ka_results_controller.rb" )
 
p1.addpath("../app/helpers/test_helper.rb" )
p1.addpath("../app/helpers/ka_answers_helper.rb") 
p1.addpath("../app/helpers/ka_questions_helper.rb") 
p1.addpath("../app/helpers/ka_results_helper.rb" )
p1.addpath("../app/helpers/ka_tests_helper.rb" )
 
p1.addpath("../app/views/ka_answers/index.html.slim") 
p1.addpath("../app/views/ka_questions/index.html.slim") 
p1.addpath("../app/views/ka_questions/show.html.slim" )
p1.addpath("../app/views/ka_results/detail.html.slim" )
p1.addpath("../app/views/ka_results/index.html.slim" )
p1.addpath("../app/views/ka_results/show.html.slim" )
p1.addpath("../app/views/ka_results/show_problem_areas_and_competences_coverage.html.slim")
p1.addpath("../app/views/ka_tests/index.html.slim" )
p1.addpath("../app/views/ka_tests/new.html.slim" )
p1.addpath("../app/views/ka_tests/run.html.slim" )
p1.addpath("../app/views/ka_tests/show.html.slim" )
p1.addpath("../app/views/test/get_g.html.erb" )
p1.addpath("../app/views/test/get_s.html.erb" )
p1.addpath("../app/views/test/get_task.html.erb") 
p1.addpath("../app/views/test/get_v.html.erb" )
 
p1.addpath("../app/models/ka_answer.rb" )
p1.addpath("../app/models/ka_answer_log.rb") 
p1.addpath("../app/models/ka_question.rb" )
p1.addpath("../app/models/ka_questions_variants.rb") 
p1.addpath("../app/models/ka_result.rb") 
p1.addpath("../app/models/ka_test.rb" )
p1.checkPik()


p2 = Pik("Competence")
p2.addpath("../app/controllers/competences_controller.rb") 
p2.addpath("../app/helpers/competences_helper.rb")  
p2.addpath("../app/views/competences/edit.html.slim")  
p2.addpath("../app/views/competences/index.html.slim")  
p2.addpath("../app/models/competence.rb")  
p2.addpath("../app/models/competence_coverage.rb")  
p2.addpath("../app/models/topic_competence.rb")  

p2.checkPik()

piks = [p1,p2]



filename = "lib.xml"
root = xml.Element("PIK_LIBRARY")
appt = xml.Element("appointment")
root.append(appt)

for pik in piks:
	pikName = xml.SubElement(appt, "pikname")
	pikName.text = pik.name

	pikIsUse = xml.SubElement(appt, "isUse")
	pikIsUse.text = str(pik.isHave)

tree = xml.ElementTree(root)
with open(filename, "w") as fh:
	tree.write(fh)
