"
I provide examples for GtLPrimitiveDocumentDataBlock.
"
Class {
	#name : #GtLPrimitiveDocumentDataBlockExamples,
	#superclass : #GtLPrimitiveDataBlockExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLPrimitiveDocumentDataBlockExamples >> basicDocumentDataBlock [
	<gtExample>
	| block |
	block := GtLPrimitiveDocumentDataBlock new.
	
	self assert: block documentBytes isNil.
	self assert: block contentType isNil.
	self assert: block dataKey isNil.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveDocumentDataBlockExamples >> documentDataBlockWithBytesAndType [
	<gtExample>
	| block documentBytes |
	documentBytes := self samplePdfBytes.
	
	block := self basicDocumentDataBlock.
	block documentBytes: documentBytes.
	block contentType: 'application/pdf'.
	
	self assert: block documentBytes equals: documentBytes.
	self assert: block encodedBytes equals: documentBytes base64Encoded.
	self assert: block contentType equals: 'application/pdf'.
	self assert: block documentFormat equals: 'pdf'.
	self assert: block dataKey isNil.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveDocumentDataBlockExamples >> documentDataBlockWithContentLabel [
	<gtExample>
	| block documentBytes |
	documentBytes := self samplePdfBytes.
	
	block := self basicDocumentDataBlock.
	block documentBytes: documentBytes.
	block contentType: 'application/pdf'.
	block contentLabel: 'sample-document.pdf'.
	
	self assert: block documentBytes equals: documentBytes.
	self assert: block encodedBytes equals: documentBytes base64Encoded.
	self assert: block contentType equals: 'application/pdf'.
	self assert: block documentFormat equals: 'pdf'.
	self assert: block contentLabel equals: 'sample-document.pdf'.
	self assert: block dataKey isNil.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #examples }
GtLPrimitiveDocumentDataBlockExamples >> documentDataBlockWithDataKey [
	<gtExample>
	| block |
	block := self documentDataBlockWithBytesAndType.
	block dataKey: 'myDocument'.
	
	self assert: block dataKey equals: 'myDocument'.
	self assertSerializationForDataBlockWithOneDataPart: block.
	
	^ block
]

{ #category : #'examples - support' }
GtLPrimitiveDocumentDataBlockExamples >> samplePdfBytes [
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
