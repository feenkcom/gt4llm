Class {
	#name : #GtLInputImageFile,
	#superclass : #GtLInputAttachment,
	#category : #Gt4LlmCore
}

{ #category : #serialization }
GtLInputImageFile >> serializeForAnthropicMessagesAPI [
	^ {'type' -> 'image'.
		'media_type' -> 'image/jpeg'.
		'image_url' -> self fileReference binaryContents base64Encoded}
			asDictionary
]

{ #category : #serialization }
GtLInputImageFile >> serializeForOpenAIResponsesAPI [
	^ {'type' -> 'input_image'.
		'image_url' -> ('data:image/jpeg;base64,' , self fileReference binaryContents base64Encoded)}
			asDictionary
]
