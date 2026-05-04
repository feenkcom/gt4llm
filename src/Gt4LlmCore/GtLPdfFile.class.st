Class {
	#name : #GtLPdfFile,
	#superclass : #GtLFileReference,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLPdfFile >> contentType [
		^ 'application/pdf'
]

{ #category : #views }
GtLPdfFile >> llmDocumentDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView documentData
			contentType: self contentType;
			document: [ self fileReference binaryContents ];
			contentLabel: [ self fileReference basename ]
]
