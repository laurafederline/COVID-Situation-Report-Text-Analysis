# -*- coding: utf-8 -*-
"""
Created on Thu May 14 10:02:42 2020

@author: lafede
"""

# Extracting text from sitrep PDFs
    # https://automatetheboringstuff.com/chapter13/

#PyPDF2 package installed with 'pip install PyPDF2'
import PyPDF2

#Get PDF file
sitrep1 = open('C:\\Users\\lafede\\Documents\\COVID sitreps\\RawPDFs\\sitrep74.pdf','rb')

#Read PDF
pdfReader1 = PyPDF2.PdfFileReader(sitrep1)

#Select page and extract text
pageObj = pdfReader1.getPage(0)
page0text= pageObj.extractText()


noLines = page0text.split('\n')

afterAText = text.split(a)[-1]
aSectionText = afterAText.split(b)[0] #dont run if last header


#regex to grab capital words (headers)
\b([A-Z]+\s*:*)+\s+


#pdf WITH COLUMNS

#Get PDF file
sitrep74 = open('C:\\Users\\lafede\\Documents\\COVID sitreps\\RawPDFs\\sitrep74.pdf','rb')

#Read PDF
pdfReader74 = PyPDF2.PdfFileReader(sitrep74)

#Select page and extract text
pageObj74 = pdfReader74.getPage(0)
page0text= pageObj74.extractText()

#pdf WITH table

#Get PDF file
sitrep742 = open('C:\\Users\\lafede\\Documents\\COVID sitreps\\RawPDFs\\sitrep74.pdf','rb')

#Read PDF
pdfReader742 = PyPDF2.PdfFileReader(sitrep742)

#Select page and extract text
pageObj742 = pdfReader74.getPage(2)
page0text= pageObj742.extractText()