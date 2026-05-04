Class {
	#name : #GtLImageFile,
	#superclass : #GtLFileReference,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLImageFile >> contentType [
	 self fileReference extension = 'png'
	 	ifTrue: [ ^ 'image/png' ].
	 
		^ 'image/jpeg'
]

{ #category : #views }
GtLImageFile >> gtFileReferencePictureFor: aView [
	<gtView>
	^ aView forward
		title: 'Picture';
		object: [ fileReference ];
		view: #gtFigureFor:
]

{ #category : #views }
GtLImageFile >> llmImageDataViewFor: aDataView [
	<gtLlmDataView>
	
	| imageType |
	imageType := self fileReference extension asLowercase.
	(#('jpg' 'jpeg') includes: imageType) ifTrue: [ imageType := 'jpeg' ].
	
	^ aDataView imageData
			imageType: imageType;
			imageBytes: [ self fileReference binaryContents ];
			contentLabel: [ self fileReference basename ]
]
