Class {
	#name : #GtLInputImageFile,
	#superclass : #GtLInputAttachment,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLInputImageFile >> contentType [
	 self fileReference extension = 'png'
	 	ifTrue: [ ^ 'image/png' ].
	 
		^ 'image/jpeg'
]

{ #category : #views }
GtLInputImageFile >> gtFileReferencePictureFor: aView [
	<gtView>
	^ aView forward
		title: 'Picture';
		object: [ fileReference ];
		view: #gtFigureFor:
]

{ #category : #serialization }
GtLInputImageFile >> serializeToAnthropicResponseOutput [
	^ {
		'type' -> 'image'.
		'source'-> {
			'media_type' -> self contentType.
			'type' ->'base64'.
			'data' -> self base64EncodedContent } asDictionary}
			asDictionary
]

{ #category : #serialization }
GtLInputImageFile >> serializeToOpenAIResponseOutput [
	^ {'type' -> 'input_image'.
		'image_url' -> ('data:'
			,self contentType
			,';base64,' 
			, self base64EncodedContent)}
				asDictionary
]
