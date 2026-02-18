Class {
	#name : #GtLInputPdfFile,
	#superclass : #GtLInputAttachment,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLInputPdfFile >> contentType [
		^ 'application/pdf'
]

{ #category : #serialization }
GtLInputPdfFile >> serializeForAnthropicMessagesAPI [
	^ {
		'type' -> 'document'.
		'source'-> {
			'media_type' -> self contentType.
			'type' ->'base64'.
			'data' -> self fileReference binaryContents base64Encoded } asDictionary}
			asDictionary
]

{ #category : #serialization }
GtLInputPdfFile >> serializeForOpenAIResponsesAPI [
	^ {'type' -> 'input_file'.
		'filename' -> self fileReference basename.
		'file_data' -> ('data:'
				, self contentType 
				,';base64,' 
				, self fileReference binaryContents base64Encoded)}
			asDictionary
]
