newATC <- data.frame(ATC = ATC$`ATC code`,
                     Name = ATC$`ATC level name`,
                     DDD = ATC$DDD,
                     Unit = ATC$Unit,
                     Adm.R = ATC$Adm.R,
                     stringsAsFactors = F)

newATC <- filter(newATC, nchar(ATC) == 7)
newATC <- newATC %>% as.data.table()
newATC[, Adm.R := if_else(is.na(Adm.R), "", Adm.R)]
newATC[, Adm.R1 := if_else(grepl("J06", ATC), "parenteral",
                           if_else(grepl("J07", ATC), "oral|parenteral",
                                   if_else(grepl("L", ATC), "oral,parenteral|topical",
                                           if_else(grepl("V01", ATC), "oral|parenteral",
                                                   if_else(grepl("N01A", ATC), "oral|parenteral|inhalation",
                                                           if_else(grepl("N01B", ATC), "topical|parenteral|stomatologic",
                                                                   if_else(grepl("V08", ATC), "parenteral",
                                                                           if_else(grepl("V03AN", ATC), "inhalation",
                                                                                   if_else(grepl("B05", ATC), "parenteral|topical",
                                                                                           if_else(grepl("S01", ATC), "ophthalmic",
                                                                                                   if_else(grepl("S02", ATC), "otic",
                                                                                                           if_else(grepl("S03", ATC), "ophthalmic|otic",
                                                                                                                   if_else(grepl("A07EA", ATC), "rectal",
                                                                                                                           if_else(grepl("A06AG", ATC), "rectal",
                                                                                                                                   if_else(grepl("A01", ATC), "stomatologic",
                                                                                                                                           if_else(grepl("R02", ATC), "stomatologic",""))))))))))))))))]

oralText <- "A01AB,A01AC,A01AD,A02AH,A07AA,A07CA,A07EA,A07EB,A10BD,A11CC,A12CC,B02BC,B03AA,B03AB,B03BB,C01CA,C01DA,C02DB,C07A,C08,D07,G01AF,G02CB,G03BA,G04BD,H02AB,H05BX,J01FA,J01FF,J01XA,J01XB,J01XD,J01XX,J02AC,J07BF,L01BA,L01BB,L04AA,L04AX,M05BA,N05BA,R02AA,R02AB,R05CB,V01AA,V03AH,V06,V09DB"
oralText <- strsplit(oralText, ",")
oralText <- paste(oralText[[1]], collapse = "|")
NasalPreparationText <- "R01"
EnemaText <- "A06AG|A07EA"
VaginalText <- "G01AF|G01AX|G02BB|G02CC|G03XB|G03XX"
InhalantText <- "R01A|R03A|R03B|R05X|V09EA"
DermatologicalPreparationText <- "C02DC|D04A|D05A|D07|D10AA|D11"
I.V.Text <- "B05X|B05B|C05B|R05CB|V03AF"
ParenteralPreparationText <- "A11DB|B03AC|C01DA|C02DA"
SystemicText <- "A03AB,A03AD,A14AA,B02BB,B02BX,B06A,C02DC,D01B,D05B,D10B,G03A,H02A,H02B,H03C,J02,J01,J05,L01BC,M01A,R06A,R01B,R03C,R03D,R06,S01E,S01J"
SystemicText <- strsplit(SystemicText, ",")
SystemicText <- paste(SystemicText[[1]], collapse = "|")

newATC[, Adm.R2 := if_else(grepl(oralText, ATC), "oral",
                           if_else(grepl(NasalPreparationText, ATC), "nasal",
                                   if_else(grepl(EnemaText, ATC), "rectal",
                                           if_else(grepl(VaginalText, ATC), "vaginal",
                                                   if_else(grepl(InhalantText, ATC), "inhalation",
                                                           if_else(grepl(DermatologicalPreparationText, ATC), "topical",
                                                                   if_else(grepl(I.V.Text, ATC), "parenteral",
                                                                           if_else(grepl(ParenteralPreparationText, ATC), "parenteral",
                                                                                   if_else(grepl(SystemicText, ATC), "oral|parenteral","")))))))))]

newATC[, Adm.R3 := if_else(grepl("A09", ATC), "oral", "")]
newATC[, ATC2 := substr(ATC, 1, 5)]
newATC2 <- select(newATC, Adm.R, ATC2) %>% unique() %>% as.data.table()
newATC2[, Adm.R4 := Adm.R]
newATC2 <- select(newATC2, Adm.R4, ATC2) %>% filter(Adm.R4 != "")
newATC <- left_join(newATC, newATC2, by = "ATC2") %>% as.data.table()
newATC[, Adm.R4 := if_else(is.na(Adm.R4), "", Adm.R4)]
newATC[, Adm.R5 := if_else(Adm.R == "" & Adm.R1 == "" & Adm.R2 == "" & Adm.R3 == "" & Adm.R4 == "", "topical", "")]

newATC[, Adm.R6 := if_else(grepl("implant|s.c. implant", Adm.R4), "implant",
                           if_else(grepl("Inhal|Inhal.solution|Inhal.powder|Inh.aerosol|Inhal.aerosol|Instill.sol.", Adm.R4), "inhalation",
                                   if_else(grepl("N", Adm.R4), "nasal",
                                           if_else(grepl("O|Chewing gum|oral aerosol", Adm.R4), "oral",
                                                   if_else(grepl("lamella", Adm.R4), "ophthalmic",
                                                           if_else(grepl("otic", Adm.R4), "otic",
                                                                   if_else(grepl("P", Adm.R4), "parenteral",
                                                                           if_else(grepl("R", Adm.R4), "rectal",
                                                                                   if_else(grepl("SL", Adm.R4), "sublingual/buccal",
                                                                                           if_else(grepl("stomatologic", Adm.R4), "stomatologic",
                                                                                                   if_else(grepl("TD|TD patch", Adm.R4), "transdermal",
                                                                                                           if_else(grepl("intravesical|ointment", Adm.R4), "topical",
                                                                                                                   if_else(grepl("urethral", Adm.R4), "urethral",
                                                                                                                           if_else(grepl("V", Adm.R4), "vaginal",""))))))))))))))]


newATC[, Adm.RF := paste(Adm.R1, Adm.R2, Adm.R3, Adm.R5, Adm.R6, sep = "|")]

resATC_Adm.RF <- newATC %>% select(ATC, Adm.RF)
resATC_Adm.RF$Adm.RF<-gsub("[|][|][|]","|",resATC_Adm.RF$Adm.RF)
resATC_Adm.RF$Adm.RF<-gsub("[|][|]","|",resATC_Adm.RF$Adm.RF)
resATC_Adm.RF$Adm.RF<-gsub("^[|]|[|]$","",resATC_Adm.RF$Adm.RF)

