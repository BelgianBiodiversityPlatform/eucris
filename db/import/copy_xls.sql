---ANR
set datestyle='MDY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/ANR/Persons-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/ANR/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/ANR/Funding programmes-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/ANR/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/ANR/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/ANR/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/ANR/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/ANR/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;



--- Belspo
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/Belspo/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/Belspo/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/Belspo/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/Belspo/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/Belspo/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/Belspo/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/Belspo/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/Belspo/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/Belspo/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

--- BiodivERsA
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/Biodiversa/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/Biodiversa/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/Biodiversa/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/Biodiversa/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/Biodiversa/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/Biodiversa/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/Biodiversa/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/Biodiversa/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/Biodiversa/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

--- BNSF
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/BNSF/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/BNSF/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/BNSF/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/BNSF/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/BNSF/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/BNSF/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/BNSF/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/BNSF/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/BNSF/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---DEFRA
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/DEFRA/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/DEFRA/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/DEFRA/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/DEFRA/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/DEFRA/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/DEFRA/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/DEFRA/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/DEFRA/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/DEFRA/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---DFG
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/DFG/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/DFG/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/DFG/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/DFG/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---EU
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/EU/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/EU/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/EU/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/EU/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/EU/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/EU/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/EU/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/EU/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/EU/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---FCT
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/FCT/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/FCT/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/FCT/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/FCT/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/FCT/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/FCT/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/FCT/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/FCT/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/FCT/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

--- FORMAS
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/FORMAS/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/FORMAS/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/FORMAS/Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/FORMAS/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/FORMAS/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/FORMAS/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/FORMAS/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/FORMAS/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/FORMAS/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---FRB
set datestyle='YMD';
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/FRB/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/FRB/Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/FRB/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---FWF
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/FWF/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/FWF/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/FWF/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/FWF/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/FWF/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/FWF/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/FWF/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/FWF/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/FWF/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---MEC
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/MEC/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/MEC/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/MEC/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/MEC/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/MEC/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/MEC/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/MEC/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/MEC/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/MEC/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---MFAL
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/MFAL/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/MFAL/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/MFAL/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/MFAL/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/MFAL/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/MFAL/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/MFAL/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/MFAL/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/MFAL/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

--- MINECO
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/MINECO/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/MINECO/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/MINECO/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/MINECO/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/MINECO/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/MINECO/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/MINECO/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/MINECO/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/MINECO/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---NWO
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/NWO/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/NWO/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/NWO/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/NWO/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/NWO/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/NWO/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/NWO/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/NWO/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/NWO/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---RCL
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/RCL/People-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/RCL/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/RCL/Fundings-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/RCL/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/RCL/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/RCL/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/RCL/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/RCL/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou_fu FROM '/home/aheugheb/db2/biodiversa/RCL/OrgUnit-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;

---RCN
set datestyle='DMY';
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/RCN/Persons-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/RCN/Projects-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/RCN/Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/RCN/OrgUnits-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/RCN/Person-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/RCN/Person-Project-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/RCN/Project-Funding-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/RCN/Project-OrgUnit-Tableau 1.csv' NULL AS '' DELIMITER ';' HEADER CSV;


---VM
COPY xls.pe FROM '/home/aheugheb/db2/biodiversa/VM/persons.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr FROM '/home/aheugheb/db2/biodiversa/VM/projects.csv' NULL AS '' DELIMITER '\t' ESCAPE '"' HEADER CSV;
COPY xls.fu FROM '/home/aheugheb/db2/biodiversa/VM/funding.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.ou FROM '/home/aheugheb/db2/biodiversa/VM/orgunits.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_ou FROM '/home/aheugheb/db2/biodiversa/VM/person_orgunit.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pe_pr FROM '/home/aheugheb/db2/biodiversa/VM/person_project.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_fu FROM '/home/aheugheb/db2/biodiversa/VM/project_funding.csv' NULL AS '' DELIMITER ';' HEADER CSV;
COPY xls.pr_ou FROM '/home/aheugheb/db2/biodiversa/VM/project_orgunit.csv' NULL AS '' DELIMITER ';' HEADER CSV;




