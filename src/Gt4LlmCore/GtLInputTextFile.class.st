Class {
	#name : #GtLInputTextFile,
	#superclass : #GtLInputAttachment,
	#category : #Gt4LlmCore
}

{ #category : #serialization }
GtLInputTextFile >> contentType [
		^ 'text/plain'
]

{ #category : #serialization }
GtLInputTextFile >> serializeForAnthropicMessagesAPI [
	^ {
		'type' -> 'document'.
		'source'-> {
			'media_type' -> self contentType.
			'type' ->'base64'.
			'data' -> self base64EncodedContent } asDictionary}
			asDictionary
]

{ #category : #serialization }
GtLInputTextFile >> serializeForOpenAIResponsesAPI [
	^ {'type' -> 'input_file'.
		'filename' -> self fileReference basename.
		'file_data' -> ('data:'
				, self contentType 
				,';base64,' 
				, self base64EncodedContent)}
			asDictionary
]
