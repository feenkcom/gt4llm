"
I provide examples for GtLDocumentDataView.
"
Class {
	#name : #GtLDocumentDataViewExamples,
	#superclass : #GtLDataViewExamples,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'examples - support' }
GtLDocumentDataViewExamples >> samplePdfBytes [
	<gtExample>
	"Return sample bytes representing a minimal PDF document for testing."
	| pdfBytes |
	pdfBytes := '%PDF-1.4
1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj
2 0 obj << /Type /Pages /Kids [] /Count 0 >> endobj
xref
0 3
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
trailer << /Size 3 /Root 1 0 R >>
startxref
116
%%EOF' asByteArray.
	
	self assert: pdfBytes isNotEmpty.
	
	^ pdfBytes
]

{ #category : #examples }
GtLDocumentDataViewExamples >> standaloneDocumentDataViewWithContentLabel [
	<gtExample>
	| basicView documentBytes |
	
	documentBytes := self samplePdfBytes.
	
	basicView := GtLDocumentDataView new
		document: [ documentBytes ];
		contentType: 'application/pdf';
		contentLabel: [ 'test-document.pdf' ].
	
	self assert: basicView title isNil.
	self assert: basicView dataKey isNil.
	self assert: basicView contentType equals: 'application/pdf'.
	self assert: basicView computedDocumentBytes equals: documentBytes.
	self assert: basicView computeContentLabel equals: 'test-document.pdf'.
	
	^ basicView
]

{ #category : #examples }
GtLDocumentDataViewExamples >> standaloneDocumentDataViewWithContentLabel_serialization [
	<gtExample>
	| basicView dataBlock documentDataBlock documentBytes |
	
	documentBytes := self samplePdfBytes.
	basicView := self standaloneDocumentDataViewWithContentLabel.
	dataBlock := basicView serializeToLlmPrimiteData.
	
	self assert: dataBlock sourceDataView equals: basicView.
	self assert: dataBlock dataKey isNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock documentDataBlocks size equals: 1.
	
	documentDataBlock := dataBlock documentDataBlocks first.
	self assert: documentDataBlock sourceDataView equals: basicView.
	self assert: documentDataBlock dataKey isNil.
	self assert: documentDataBlock documentBytes equals: documentBytes.
	self assert: documentDataBlock contentType equals: 'application/pdf'.
	self assert: documentDataBlock encodedBytes equals: documentBytes base64Encoded.
	self assert: documentDataBlock contentLabel equals: 'test-document.pdf'.
	
	^ dataBlock
]

{ #category : #examples }
GtLDocumentDataViewExamples >> standaloneDocumentDataViewWithPdf [
	<gtExample>
	| basicView documentBytes |
	
	documentBytes := self samplePdfBytes.
	
	basicView := GtLDocumentDataView new
		pdf: [ documentBytes ].
	
	self assert: basicView title isNil.
	self assert: basicView dataKey isNil.
	self assert: basicView contentType equals: 'application/pdf'.
	self assert: basicView computedDocumentBytes equals: documentBytes.
	
	^ basicView
]

{ #category : #examples }
GtLDocumentDataViewExamples >> standaloneDocumentDataViewWithoutDataKey [
	<gtExample>
	| basicView documentBytes |
	
	documentBytes := self samplePdfBytes.
	
	basicView := GtLDocumentDataView new
		document: [ documentBytes ];
		contentType: 'application/pdf'.
	
	self assert: basicView title isNil.
	self assert: basicView dataKey isNil.
	self assert: basicView contentType equals: 'application/pdf'.
	self assert: basicView computedDocumentBytes equals: documentBytes.
	
	^ basicView
]

{ #category : #examples }
GtLDocumentDataViewExamples >> standaloneDocumentDataViewWithoutDataKey_serialization [
	<gtExample>
	| basicView dataBlock documentDataBlock documentBytes |
	
	documentBytes := self samplePdfBytes.
	basicView := self standaloneDocumentDataViewWithoutDataKey.
	dataBlock := basicView serializeToLlmPrimiteData.
	
	self assert: dataBlock sourceDataView equals: basicView.
	self assert: dataBlock dataKey isNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock documentDataBlocks size equals: 1.
	
	documentDataBlock := dataBlock documentDataBlocks first.
	self assert: documentDataBlock sourceDataView equals: basicView.
	self assert: documentDataBlock dataKey isNil.
	self assert: documentDataBlock documentBytes equals: documentBytes.
	self assert: documentDataBlock contentType equals: 'application/pdf'.
	self assert: documentDataBlock encodedBytes equals: documentBytes base64Encoded.
	
	^ dataBlock
]
