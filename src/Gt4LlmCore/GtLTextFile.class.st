Class {
	#name : #GtLTextFile,
	#superclass : #GtLFileReference,
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #serialization }
GtLTextFile >> contentType [
		^ 'text/plain'
]

{ #category : #views }
GtLTextFile >> llmDocumentDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView documentData
			contentType: self contentType;
			document: [ self fileReference binaryContents ];
			contentLabel: [ self fileReference basename ]
]
