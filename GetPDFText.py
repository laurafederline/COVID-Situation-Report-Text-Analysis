import PyPDF2
import re
import pandas

def getPDFtext(first, last):
    header_text = [['sitrep','header','text']]
    all_text = [['sitrep','full_string']]
    for sitrep in range(first,last+1):
        #get file
        pdf_file = open(f'C:\\Users\\lafede\\Documents\\COVID sitreps\\RawPDFs\\sitrep{sitrep}.pdf','rb')
        pdfReader = PyPDF2.PdfFileReader(pdf_file)
           
        #extract text from each page
        count = pdfReader.numPages
        pages = []
        for i in range(count):
            pageobj = pdfReader.getPage(i)
            pagetext= pageobj.extractText()
            pages.append(pagetext)
        
        #concatenate all pages to one string
        report_text= ''
        for page_text in pages:
            report_text += page_text
        
        #format report string
        report_text = report_text.replace('\n','')
        report_text = ' '.join(report_text.split())
        
        #make list of rawheaders using regex
        rawheaders = re.findall(r"\b(?:[A-Z]+\s*:*)+\s+", report_text)
        #remove strings that are not headers
        rawheaders = [x.replace('WHO','').replace('CDC','').replace('AM CET','').replace('ERRATUM','').replace(' A ','').replace(':','').strip(' ') for x in rawheaders]
        #print(rawheaders)
        unwanted_str = {'COVID','UNWTO','A GOARN RCCE','A GHC','UK EMT','PAH EMR EUR SEAR WPR','GOARN','SOLIDARITY','TOTAL','UNICEF','EMFLU','ZIKA VIRUS','RISK ASSESSMENT','SEARO','JANUARY','FEBRUARY','MARCH',
                        'SITUATION REPORT','STRENGTHENING SUPPLY CHAINS TO CREATE GREATEST IMPACT','SCICC','IOMSC','WHE IPC','INFODEMICS','UPDATE ON OPERATIONS SUPPLY AND LOGISTICS','CLINICAL MANAGEMENT OF PATIENTS WITH','UPDATE ON ADDITIONAL HEALTH MEASURES','UPDATE ON INFECTION PREVENTION AND CONTROL'}
        rawheaders = [x for x in rawheaders if x not in unwanted_str] 
        headers = [x for x in rawheaders if len(x) > 4]
        
        if report_text.find('Resources:') != -1:
            headers.append('Resources')
        
        if sitrep==93: 
            headers.remove('SUBJECT IN FOCUS')
            
        #print headers to check and add to unwanted_str
        #print(sitrep)
        #print(headers)
        #print('\n')
        
        #seperate text string into sections based on headers        
        ##capture beginning of report without header
        beginning = report_text.split(headers[0])[0]
        header_text.append([sitrep,'beginning',beginning])
        
        for i, h in enumerate(headers):
            if h==headers[-1]:
                sectiontext = report_text.split(headers[i])[-1]
            elif sitrep==93 and h=='SUBJECT IN FOCUS':
                afterheader = report_text.split(headers[i])[1] + report_text.split(headers[i])[2]
                sectiontext = afterheader.split(headers[i+1])[0]
            else:
                afterheader = report_text.split(headers[i])[-1]
                sectiontext = afterheader.split(headers[i+1])[0]
            header_text.append([sitrep,h,sectiontext])
        
        all_text.append([sitrep,report_text])
    
    return (header_text,all_text)
        
    
(header_text,all_text) = getPDFtext(1,100)

#convert final 2 arrays to dataframes
header_df = pandas.DataFrame(data=header_text[1:],columns=header_text[0])
all_df = pandas.DataFrame(data=all_text[1:],columns=all_text[0])