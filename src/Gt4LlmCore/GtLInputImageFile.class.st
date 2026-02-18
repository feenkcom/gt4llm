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

{ #category : #serialization }
GtLInputImageFile >> serializeForAnthropicMessagesAPI [
	^ {
		'type' -> 'image'.
		'source'-> {
			'media_type' -> self contentType.
			'type' ->'base64'.
			'data' -> self fileReference binaryContents base64Encoded } asDictionary}
			asDictionary
]

{ #category : #serialization }
GtLInputImageFile >> serializeForOpenAIResponsesAPI [
	^ {'type' -> 'input_image'.
		'image_url' -> ('data:'
			,self contentType
			,';base64,' 
			, self fileReference binaryContents base64Encoded)}
				asDictionary
]
