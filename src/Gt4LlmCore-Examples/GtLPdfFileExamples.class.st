"
I provide examples for GtLPdfFile.
"
Class {
	#name : #GtLPdfFileExamples,
	#superclass : #GtLFileReferenceExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLPdfFileExamples >> pdfFile [
	<gtExample>
	<after: #cleanupTempDirectory>
	| pdfFile |
	pdfFile := GtLPdfFile fileReference: self samplePdfFileReference.
	
	self assert: pdfFile fileReference exists.
	self assertFileReference: pdfFile hasContentType: 'application/pdf'.
	
	^ pdfFile
]

{ #category : #examples }
GtLPdfFileExamples >> pdfFileMainDataView [
	<gtExample>
	<after: #cleanupTempDirectory>
	| pdfFile mainDataView |
	pdfFile := self pdfFile.
	mainDataView := pdfFile llmDataViewsFor: GtLDataView new.
	
	self assertCompositeDataView: mainDataView hasTitle: 'Object views' viewsCount: 1.
	
	^ mainDataView
]

{ #category : #examples }
GtLPdfFileExamples >> pdfFileSerialization [
	<gtExample>
	<after: #cleanupTempDirectory>
	| mainDataView dataBlock |
	mainDataView := self pdfFileMainDataView.
	dataBlock := mainDataView serializeToLlmPrimiteData.
	
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assertDataBlock: dataBlock hasDocumentWithContentType: 'application/pdf'.
	
	^ dataBlock
]

{ #category : #'examples - support' }
GtLPdfFileExamples >> samplePdfContent [
	"Return sample PDF content for testing"
	^ '%PDF-1.4
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
%%EOF'
]

{ #category : #'examples - support' }
GtLPdfFileExamples >> samplePdfFileReference [
	<gtExample>
	<after: #cleanupTempDirectory>
	| fileRef |
	fileRef := self tempDirectory / 'sample.pdf'.
	fileRef writeStreamDo: [ :stream | stream nextPutAll: self samplePdfContent ].
	
	self assert: fileRef exists.
	
	^ fileRef
]
