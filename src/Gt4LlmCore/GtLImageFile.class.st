Class {
	#name : #GtLImageFile,
	#superclass : #GtLFileReference,
	#category : 'Gt4LlmCore-Domain Objects'
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
		imageBytes: [ self fileReference binaryContents ];
		imageType: imageType
]

{ #category : #serialization }
GtLImageFile >> serializeToAnthropicResponseOutput [
	^ {
		'type' -> 'image'.
		'source'-> {
			'media_type' -> self contentType.
			'type' ->'base64'.
			'data' -> self base64EncodedContent } asDictionary}
			asDictionary
]

{ #category : #serialization }
GtLImageFile >> serializeToOllamaOpenAIResponseOutput [
	^ {'type' -> 'image_url'.
		'image_url' -> ('data:'
			,self contentType
			,';base64,' 
			, self base64EncodedContent)}
				asDictionary
]

{ #category : #serialization }
GtLImageFile >> serializeToOllamaResponseOutput [
	^ self base64EncodedContent
]

{ #category : #serialization }
GtLImageFile >> serializeToOpenAIResponseOutput [
	^ {'type' -> 'input_image'.
		'image_url' -> ('data:'
			,self contentType
			,';base64,' 
			, self base64EncodedContent)}
				asDictionary
]
